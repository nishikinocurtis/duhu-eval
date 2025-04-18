# Use the official Debian 12 base image
FROM nishikinocurtis/duhu:duhu-base

ARG USERNAME=ray

COPY --chown=$USERNAME:$USERNAME ./daft/daftreq.txt .

# # Install dependencies
RUN sudo rm -rf /var/lib/apt/lists/*

RUN pip install -Ur daftreq.txt


RUN mkdir -p $HOME/daft
COPY --chown=$USERNAME:$USERNAME ./daft/run.sh $HOME/daft/run.sh
RUN chmod +x $HOME/daft/run.sh
COPY --chown=$USERNAME:$USERNAME ./daft/tpcds.sh $HOME/daft/tpcds.sh
RUN chmod +x $HOME/daft/tpcds.sh

WORKDIR $HOME/daft

RUN echo "alias cr='sudo chmod -R 777 /dev/hugepages'" >> ~/.bashrc

RUN echo "alias ray1=\"ray start --head --fixed-node-id 0 --node-ip-address 192.168.10.201 --num-cpus=4 \
    --dashboard-host 0.0.0.0 --object-store-memory 16000000000 --disable-usage-stats \
    --kvs-config-path \"/home/ray/kvs.json\" \
    --resources='{\\\"head\\\":1, \\\"worker\\\":1}'\"" >> ~/.bashrc

RUN echo "alias ray2=\"ray start --fixed-node-id 1 --num-cpus=4 --node-ip-address 192.168.10.202 \
    --address='192.168.10.201:6379' --object-store-memory 16000000000 \
    --kvs-config-path \"/home/ray/kvs.json\" --resources='{\\\"worker\\\":1}'\"" >> ~/.bashrc

RUN echo "alias ray3=\"ray start --fixed-node-id 2 --num-cpus=4 --node-ip-address 192.168.10.203 \
    --address='192.168.10.201:6379' --object-store-memory 16000000000 \
    --kvs-config-path \"/home/ray/kvs.json\" --resources='{\\\"worker\\\":1}'\"" >> ~/.bashrc

RUN echo "alias ray4=\"ray start --fixed-node-id 3 --num-cpus=4 --node-ip-address 192.168.10.204 \
    --address='192.168.10.201:6379' --object-store-memory 16000000000 \
    --kvs-config-path \"/home/ray/kvs.json\" --resources='{\\\"worker\\\":1}'\"" >> ~/.bashrc

RUN echo "alias p2=\"ping 192.168.10.202\"" >> ~/.bashrc

RUN echo 'alias rs="ray stop"' >> ~/.bashrc
RUN echo "export TPU_VISIBLE_CHIPS=\"\"" >> ~/.bashrc