
FROM ubuntu:22.04

RUN apt-get update 
RUN apt-get install -y \
        curl \
        unzip \
        software-properties-common \
        vim \
        && \
    rm -rf /var/lib/apt/lists/*

# Version supported by ppa:deadsnakes/ppa. This is installed as an alternative
# binary for packages that can use it, but system installed python packages
# like ceph CLI will use the default system python3.
# renovate: datasource=docker depName=python versioning=docker
ARG PYTHON_VERSION=3.11
ARG DEBIAN_FRONTEND=noninteractive
RUN add-apt-repository ppa:deadsnakes/ppa && \
        apt-get install -y \
        python${PYTHON_VERSION} \
        python3-pip
RUN python3 --version
RUN python${PYTHON_VERSION} --version

# Update python3 alias to point at version installed
#RUN update-alternatives --install /usr/bin/python3 python /usr/bin/python${PYTHON_VERSION} 1
#RUN update-alternatives --config python

# Version supported by base image
ARG GO_VERSION=1.18
RUN apt-get install -y \
        golang-${GO_VERSION} \
        git
ENV PATH $PATH:/usr/lib/go-${GO_VERSION}/bin
RUN go version

# Ceph quincy versions upported by base ubuntu image
RUN apt-get install -y ceph-common
#RUN ceph version

# Cleanup from previous steps
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# renovate: datasource=github-releases depName=etcd-io/etcd
ARG ETCD_VERSION=v3.5.8
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

# renovate: datasource=github-releases depName=kubernetes/kubernetes versioning=kubernetes-api
ARG KUBECTL_VERSION=v1.27.0
RUN cd /usr/local/bin/ && \
    curl -OL https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x kubectl
RUN kubectl version --client=true

# renovate: datasource=github-releases depName=kubernetes/kubernetes
ARG TERRAFORM_VERSION=1.4.5
RUN mkdir -p /src && \
    cd /src && \
    curl -OL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    cp terraform /usr/local/bin/terraform && \
    rm -fr /src
RUN terraform version

# renovate: datasource=github-releases depName=GoogleCloudPlatform/cloud-sdk-docker
ARG GCLOUD_CLI_VERSION=427.0.0
RUN mkdir -p /usr/local/lib/ && \
    cd /usr/local/lib/ && \
    curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-${GCLOUD_CLI_VERSION}-linux-x86_64.tar.gz && \
    tar xf google-cloud-cli-${GCLOUD_CLI_VERSION}-linux-x86_64.tar.gz && \
    /usr/local/lib/google-cloud-sdk/install.sh --quiet --usage-reporting=false --rc-path=/etc/profile

# Install inventory plugins and other startup items
COPY root/ /root/

# Ansible "unsupported locale setting"
ENV LANG="C.UTF-8"

SHELL ["/bin/bash", "-c"]