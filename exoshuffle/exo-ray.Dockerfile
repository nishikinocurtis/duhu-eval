# FROM rayproject/ray:2.42.0-py39
FROM debian:12
#ARG USERNAME=ray
# ARG USER_UID=2000
#USER ${USERNAME}
RUN apt-get update
RUN apt-get install -y git wget bzip2 vim net-tools \
                        iputils-ping build-essential
RUN rm -rf /var/lib/apt/lists/*


RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
  bash /tmp/miniconda.sh -b -p /opt/conda && \
  rm /tmp/miniconda.sh && \
  /opt/conda/bin/conda clean -ya && \
  /opt/conda/bin/conda init bash
# ARG USER_GID=2000

# RUN sudo groupadd --gid $USER_GID $USERNAME
# RUN sudo useradd -u $USER_UID -g $USER_GID $USERNAME -m -s /bin/bash 
# RUN sudo usermod -aG sudo,$USERNAME $USERNAME

# put everything in . folder
# COPY --chown=$USERNAME:$USERNAME ./ray-sdm/python/requirements_compiled.txt .
COPY ./env.yml .
COPY ./exoshuffle/exoreq.txt .
# COPY --chown=$USERNAME:$USERNAME ./ray-sdm/.whl/ray-2.40.0-cp39-cp39-manylinux2014_x86_64.whl .
#COPY --chown=$USERNAME:$USERNAME ./ray-sdm/examples/kvs.json .
COPY ./exoshuffle/raysort/raysort ./raysort

ENV PATH="/opt/conda/bin:/opt/conda/envs/ray/bin:$PATH"

# WORKDIR /raysort

RUN /opt/conda/bin/conda env create -f env.yml

SHELL ["conda", "run", "--no-capture-output", "-n", "ray", "/bin/bash", "-c"]
# RUN pip install -c $HOME/requirements_compiled.txt $HOME/ray-2.40.0-cp39-cp39-manylinux2014_x86_64.whl[all]
RUN pip install -Ur exoreq.txt

WORKDIR /raysort
RUN pip install -e .
RUN pip install Cython wandb boto3 azure-storage-blob
RUN python setup.py install
RUN pushd raysort/sortlib && python setup.py build_ext --inplace && popd
RUN scripts/installers/install_binaries.sh

ENV CONDA_DEFAULT_ENV=ray
RUN echo "conda activate ray" >> ~/.bashrc
ENV PATH=$HOME/anaconda3/envs/raysort/bin:$PATH
