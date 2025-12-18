FROM ghcr.io/obnitram/devcontainer/base:latest

USER root

# deps
RUN apt-get update -y && apt-get upgrade -y && \
    apt-get install -y wget openjdk-17-jdk curl zip unzip ca-certificates openssh-server

# (1) s'assurer que /home/vscode est writable par vscode
RUN mkdir -p /home/vscode && \
    chown -R vscode:vscode /home/vscode && \
    touch /home/vscode/.bashrc && \
    chown vscode:vscode /home/vscode/.bashrc

# (2) SDKMAN + installs -> bash login shell
SHELL ["/bin/bash", "-lc"]
USER vscode

ENV HOME=/home/vscode
ENV SDKMAN_DIR=/home/vscode/.sdkman

RUN curl -s "https://get.sdkman.io" | bash && \
    source "$SDKMAN_DIR/bin/sdkman-init.sh" && \
    sdk version && \
    sdk install scala 2.12.17 && \
    sdk install sbt 1.11.7


USER root

ARG HADOOP_VERSION=3.4.2
ARG HBASE_VERSION=2.5.13
ARG ZOOKEEPER_VERSION=3.8.5


RUN set -eux; \
    mkdir -p /opt/ara; \
    cd /opt/ara; \
    if [ ! -d "hadoop-${HADOOP_VERSION}" ]; then \
    wget -q -O hadoop-${HADOOP_VERSION}.tar.gz \
    https://miroir.univ-lorraine.fr/apache/hadoop/common/stable/hadoop-${HADOOP_VERSION}.tar.gz; \
    tar -xzf hadoop-${HADOOP_VERSION}.tar.gz; \
    rm -f hadoop-${HADOOP_VERSION}.tar.gz; \
    fi


RUN set -eux; \
    cd /opt/ara; \
    if [ ! -d "hbase-${HBASE_VERSION}" ]; then \
    wget -q -O hbase-${HBASE_VERSION}-bin.tar.gz \
    https://archive.apache.org/dist/hbase/stable/hbase-${HBASE_VERSION}-bin.tar.gz; \
    tar -xzf hbase-${HBASE_VERSION}-bin.tar.gz; \
    rm -f hbase-${HBASE_VERSION}-bin.tar.gz; \
    fi


RUN set -eux; \
    cd /opt/ara; \
    if [ ! -d "apache-zookeeper-${ZOOKEEPER_VERSION}-bin" ]; then \
    wget -q -O apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz \
    https://dlcdn.apache.org/zookeeper/stable/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz; \
    tar -xzf apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz; \
    rm -f apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz; \
    fi


ARG TOOLS_PATH="/opt/ara/"
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

ENV MY_HADOOP_HOME=$TOOLS_PATH/hadoop-3.4.2
ENV PATH=$PATH:$MY_HADOOP_HOME/bin:$MY_HADOOP_HOME/sbin
ENV HADOOP_HOME=$MY_HADOOP_HOME

ENV MY_ZOOKEEPER_HOME=$TOOLS_PATH/apache-zookeeper-3.8.5-bin
ENV PATH=$PATH:$MY_ZOOKEEPER_HOME/bin

ENV MY_HBASE_HOME=$TOOLS_PATH/hbase-2.5.13
ENV PATH=$PATH:$MY_HBASE_HOME/bin

CMD ["/bin/bash", "-c", "sudo /usr/sbin/sshd && sleep infinity"]

USER vscode
WORKDIR /home/vscode
