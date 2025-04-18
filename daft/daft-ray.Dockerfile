# Use the official Debian 12 base image
FROM debian:12

ENV PATH="/opt/conda/bin:/opt/conda/envs/ray/bin:$PATH"

# Install dependencies
RUN apt-get update && \
    apt-get install -y git wget bzip2 vim net-tools iputils-ping build-essential && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm /tmp/miniconda.sh && \
    /opt/conda/bin/conda clean -ya && \
    /opt/conda/bin/conda init bash

COPY ./env.yml .

RUN /opt/conda/bin/conda env create -f env.yml

SHELL ["conda", "run", "--no-capture-output", "-n", "ray", "/bin/bash", "-c"]

RUN pip install -U ray[all]==2.40.0
COPY ./daft/daftreq.txt .

RUN echo "ray==2.40.0" > /tmp/constraints.txt
RUN pip install -Ur daftreq.txt --constraint /tmp/constraints.txt

RUN mkdir -p /home/ray/daft

COPY ./daft/run.sh /home/ray/daft/run.sh
RUN chmod +x $HOME/daft/run.sh
COPY ./daft/tpcds.sh /home/ray/daft/tpcds.sh
RUN chmod +x $HOME/daft/tpcds.sh

WORKDIR /home/ray/daft

RUN echo "alias ray1=\"ray start --head --num-cpus=8 \
--dashboard-host 0.0.0.0 --object-store-memory 40000000000 \
--resources='{\\\"head\\\":1, \\\"worker\\\":1}'\"" >> ~/.bashrc

RUN echo "alias ray2=\"ray start --num-cpus=8 \
--address='172.17.0.3:6379' --object-store-memory 40000000000 \
--resources='{\\\"worker\\\":1}'\"" >> ~/.bashrc

RUN echo "alias p2=\"ping 192.168.10.202\"" >> ~/.bashrc

ENV CONDA_DEFAULT_ENV=ray
RUN echo "conda activate ray" >> ~/.bashrc
RUN echo "export TPU_VISIBLE_CHIPS=\"\"" >> ~/.bashrc