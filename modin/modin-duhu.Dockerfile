FROM nishikinocurtis/duhu:duhu-base

ARG USERNAME=ray

COPY --chown=$USERNAME:$USERNAME ./modin/duhureq.txt .
COPY --chown=$USERNAME:$USERNAME ./modin/modin $HOME/modin
# 
# # Install dependencies (prepared in duhu-base)
RUN sudo rm -rf /var/lib/apt/lists/*

RUN pip install -Ur duhureq.txt

WORKDIR $HOME/modin
RUN pip install -e .

COPY --chown=$USERNAME:$USERNAME ./modin/queries.py .
COPY --chown=$USERNAME:$USERNAME ./modin/tpch.sh .

RUN echo "alias cr='sudo chmod -R 777 /dev/hugepages'" >> ~/.bashrc

RUN echo 'alias rs="ray stop"' >> ~/.bashrc

RUN echo "export TPU_VISIBLE_CHIPS=\"\"" >> ~/.bashrc

RUN echo "alias ray1=\"ray start --head --fixed-node-id 0 --node-ip-address 192.168.10.201 --num-cpus=4 \
    --dashboard-host 0.0.0.0 --object-store-memory 5000000000 --disable-usage-stats \
    --kvs-config-path \"/home/ray/kvs.json\" \
    --resources='{\\\"head\\\":1, \\\"worker\\\":1}'\"" >> ~/.bashrc

RUN echo "alias ray2=\"ray start --fixed-node-id 1 --num-cpus=4 --node-ip-address 192.168.10.202 \
    --address='192.168.10.201:6379' --object-store-memory 5000000000 \
    --kvs-config-path \"/home/ray/kvs.json\" --resources='{\\\"worker\\\":1}'\"" >> ~/.bashrc

RUN echo "alias ray3=\"ray start --fixed-node-id 2 --num-cpus=4 --node-ip-address 192.168.10.203 \
    --address='192.168.10.201:6379' --object-store-memory 5000000000 \
    --kvs-config-path \"/home/ray/kvs.json\" --resources='{\\\"worker\\\":1}'\"" >> ~/.bashrc

RUN echo "alias ray4=\"ray start --fixed-node-id 3 --num-cpus=4 --node-ip-address 192.168.10.204 \
    --address='192.168.10.201:6379' --object-store-memory 5000000000 \
    --kvs-config-path \"/home/ray/kvs.json\" --resources='{\\\"worker\\\":1}'\"" >> ~/.bashrc