
FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y \
        curl \
        unzip \
        software-properties-common \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# This version must be supported by ppa:deadsnakes/ppa
# renovate: datasource=docker depName=python versioning=docker
ARG PYTHON_VERSION="3.11"
ARG DEBIAN_FRONTEND=noninteractive
RUN add-apt-repository ppa:deadsnakes/ppa && \
        apt-get install -y \
        python${PYTHON_VERSION} \
        python3-pip \
        && \
    apt-get clean
RUN python3 --version

# Update python3 alias to point at version installed
RUN update-alternatives --install /usr/bin/python3 python /usr/bin/python${PYTHON_VERSION} 1
RUN update-alternatives --config python

# Version supported by base image
ARG GO_VERSION="1.18"
RUN apt-get install -y \
        golang-${GO_VERSION} \
        git \
        && \
    apt-get clean
ENV PATH $PATH:/usr/lib/go-${GO_VERSION}/bin
RUN go version

# renovate: datasource=docker depName=python versioning=docker
ARG ETCD_VERSION="v3.5.8"
RUN mkdir -p /src && \
    cd /src && \
    curl -OL https://github.com/etcd-io/etcd/archive/refs/tags/${ETCD_VERSION}.zip && \
    unzip ${ETCD_VERSION}.zip && \
    cd /src/etcd-${ETCD_VERSION#v} && \
    ./build.sh && \
    cp bin/etcdctl /usr/local/bin/etcdctl && \
    rm -fr /src
RUN etcdctl version

# Install python dependencies
RUN mkdir /src
COPY requirements.txt /src/requirements.txt
RUN pip3 install -r /src/requirements.txt

# Install inventory plugins
COPY inventory-plugins/hostdb.py /root/.ansible/plugins/inventory/hostdb.py

SHELL ["/bin/bash", "-c"]