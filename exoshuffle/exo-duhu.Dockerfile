FROM duhu

ARG USERNAME=ray
# ARG USER_UID=2000
# ARG USER_GID=2000

# RUN sudo groupadd --gid $USER_GID $USERNAME
# RUN sudo useradd -u $USER_UID -g $USER_GID $USERNAME -m -s /bin/bash 
# RUN sudo usermod -aG sudo,$USERNAME $USERNAME

# put everything in . folder
COPY --chown=$USERNAME:$USERNAME ./env.yml .
COPY --chown=$USERNAME:$USERNAME ./exoshuffle/exoreq.txt .
COPY --chown=$USERNAME:$USERNAME ./exoshuffle/raysort $HOME/raysort

COPY --chown=$USERNAME:$USERNAME ./exoshuffle/run.sh $HOME/raysort/run.sh
RUN chmod +x $HOME/raysort/run.sh
COPY --chown=$USERNAME:$USERNAME ./exoshuffle/sort.sh $HOME/raysort/sort.sh
RUN chmod +x $HOME/raysort/sort.sh

USER ${USERNAME}
RUN sudo apt update
RUN sudo apt install -y vim net-tools \
                        iputils-ping build-essential
RUN conda env create -f env.yml

WORKDIR $HOME/raysort

SHELL ["conda", "run", "--no-capture-output", "-n", "raysort", "/bin/bash", "-c"]

RUN pip install -Ur $HOME/exoreq.txt
RUN pip install -e .
RUN pushd raysort/sortlib && python setup.py build_ext --inplace && popd
RUN scripts/installers/install_binaries.sh

ENV CONDA_DEFAULT_ENV=raysort
RUN echo "conda activate raysort" >> ~/.bashrc
ENV PATH=$HOME/anaconda3/envs/raysort/bin:$PATH

RUN echo "alias cr='sudo chmod -R 777 /dev/hugepages'" >> ~/.bashrc

RUN echo "alias ray1=\"ray start --head --fixed-node-id 0 --node-ip-address 192.168.10.201 --num-cpus=8 \
    --dashboard-host 0.0.0.0 --object-store-memory 40000000000 \
    --kvs-config-path \"/home/ray/kvs.json\" \
    --resources='{\\\"head\\\":1, \\\"worker\\\":1}'\"" >> ~/.bashrc

RUN echo "alias ray2=\"ray start --fixed-node-id 1 --num-cpus=8 --node-ip-address 192.168.10.202 \
    --address='192.168.10.201:6379' --object-store-memory 40000000000 \
    --kvs-config-path \"/home/ray/kvs.json\" --resources='{\\\"worker\\\":1}'\"" >> ~/.bashrc


RUN echo "alias p2=\"ping 192.168.10.202\"" >> ~/.bashrc
