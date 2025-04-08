# Use the official Debian 12 base image
FROM duhu

ARG USERNAME=ray

COPY --chown=$USERNAME:$USERNAME ./modin/modinreq.txt .
COPY --chown=$USERNAME:$USERNAME ./modin/modin $HOME/modin
# 
# # Install dependencies
RUN sudo apt-get update && \
    sudo apt-get install -y git wget bzip2 vim net-tools iputils-ping build-essential && \
    sudo rm -rf /var/lib/apt/lists/*

RUN pip install -Ur modinreq.txt

WORKDIR $HOME/modin
RUN pip install -e .

COPY --chown=$USERNAME:$USERNAME ./modin/queries.py .

RUN echo "alias cr='sudo chmod -R 777 /dev/hugepages'" >> ~/.bashrc

RUN echo "alias ray1=\"ray start --head --fixed-node-id 0 --node-ip-address 192.168.10.201 --num-cpus=8 \
    --dashboard-host 0.0.0.0 --object-store-memory 40000000000 \
    --kvs-config-path \"/home/ray/kvs.json\" \
    --resources='{\\\"head\\\":1, \\\"worker\\\":1}'\"" >> ~/.bashrc

RUN echo "alias ray2=\"ray start --fixed-node-id 1 --num-cpus=8 --node-ip-address 192.168.10.202 \
    --address='192.168.10.201:6379' --object-store-memory 40000000000 \
    --kvs-config-path \"/home/ray/kvs.json\" --resources='{\\\"worker\\\":1}'\"" >> ~/.bashrc


RUN echo "alias p2=\"ping 192.168.10.202\"" >> ~/.bashrc
