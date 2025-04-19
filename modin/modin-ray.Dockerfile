# Use the official Debian 12 base image
FROM debian:12

ENV PATH="/opt/conda/bin:/opt/conda/envs/ray/bin:$PATH"

# Install dependencies
RUN apt-get update && \
    apt-get install -y git wget bzip2 vim net-tools iputils-ping iperf3 build-essential && \
    rm -rf /var/lib/apt/lists/*

# Download and install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm /tmp/miniconda.sh && \
    /opt/conda/bin/conda clean -ya && \
    /opt/conda/bin/conda init bash

COPY ./modin/modin ./modin
COPY ./env.yml .
COPY ./modin/modinreq.txt .
RUN /opt/conda/bin/conda env create -f env.yml

SHELL ["conda", "run", "--no-capture-output", "-n", "ray", "/bin/bash", "-c"]

RUN pip install -Ur modinreq.txt

WORKDIR /modin

RUN pip install -e .
COPY ./modin/queries.py .
COPY ./modin/tpch.sh .

ENV CONDA_DEFAULT_ENV=ray
RUN echo "conda activate ray" >> ~/.bashrc

RUN echo "alias ray1=\"ray start --head --node-ip-address 192.168.10.201 --num-cpus=8 \
    --dashboard-host 0.0.0.0 --object-store-memory 3072000000 --disable-usage-stats \
    --resources='{\\\"head\\\":1, \\\"worker\\\":1}'\"" >> ~/.bashrc

RUN echo "alias ray2=\"ray start --num-cpus=8 --node-ip-address 192.168.10.202 \
    --address='192.168.10.201:6379' --object-store-memory 3072000000 \
    --resources='{\\\"worker\\\":1}'\"" >> ~/.bashrc

RUN echo "alias ray3=\"ray start --num-cpus=8 --node-ip-address 192.168.10.203 \
    --address='192.168.10.201:6379' --object-store-memory 3072000000 \
    --resources='{\\\"worker\\\":1}'\"" >> ~/.bashrc

RUN echo "alias ray4=\"ray start --num-cpus=8 --node-ip-address 192.168.10.204 \
    --address='192.168.10.201:6379' --object-store-memory 3072000000 \
    --resources='{\\\"worker\\\":1}'\"" >> ~/.bashrc

RUN echo "export TPU_VISIBLE_CHIPS=\"\"" >> ~/.bashrc
# CMD ["/bin/bash"]
