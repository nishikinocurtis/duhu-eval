# Use the official Debian 12 base image
FROM debian:12

ENV PATH="/opt/conda/bin:/opt/conda/envs/ray/bin:$PATH"

# ARG USERNAME=ray

# COPY --chown=$USERNAME:$USERNAME ./daftreq.txt .
# COPY --chown=$USERNAME:$USERNAME ./modin $HOME/modin
# 
# # Install dependencies
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
#RUN pip install -U daft
#RUN pip install -U daft[ray]

RUN mkdir -p /home/ray/daft
# RUN pip install -e .
WORKDIR /home/ray/daft


COPY ./daft $HOME/daft

# COPY --chown=$USERNAME:$USERNAME ./queries.py .

# RUN echo "alias cr='sudo chmod -R 777 /dev/hugepages'" >> ~/.bashrc

RUN echo "alias ray1=\"ray start --head --num-cpus=8 \
--dashboard-host 0.0.0.0 --object-store-memory 40000000000 \
--resources='{\\\"head\\\":1, \\\"worker\\\":1}'\"" >> ~/.bashrc

RUN echo "alias ray2=\"ray start --num-cpus=8 \
--address='172.17.0.3:6379' --object-store-memory 40000000000 \
--resources='{\\\"worker\\\":1}'\"" >> ~/.bashrc

RUN echo "alias p2=\"ping 192.168.10.202\"" >> ~/.bashrc

ENV CONDA_DEFAULT_ENV=ray
RUN echo "conda activate ray" >> ~/.bashrc
