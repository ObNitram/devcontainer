FROM ghcr.io/obnitram/devcontainer/base:latest

USER root

# deps
RUN apt-get update -y && apt-get upgrade -y && \
    apt-get install -y wget openjdk-17-jdk curl zip unzip ca-certificates openssh-server file jq

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


USER vscode

ARG INSTALL_PATH="/home/vscode/apps"
ARG HADOOP_VERSION=3.4.2
ARG HBASE_VERSION=2.5.13
ARG ZOOKEEPER_VERSION=3.8.5


RUN set -eux; \
    mkdir -p ${INSTALL_PATH}; \
    cd ${INSTALL_PATH}; \
    if [ ! -d "hadoop-${HADOOP_VERSION}" ]; then \
    wget -q -O hadoop-${HADOOP_VERSION}.tar.gz \
    https://miroir.univ-lorraine.fr/apache/hadoop/common/stable/hadoop-${HADOOP_VERSION}.tar.gz; \
    tar -xzf hadoop-${HADOOP_VERSION}.tar.gz; \
    rm -f hadoop-${HADOOP_VERSION}.tar.gz; \
    fi

COPY hadoop/core-site.xml ${INSTALL_PATH}/hadoop-${HADOOP_VERSION}/etc/hadoop/core-site.xml
COPY hadoop/hdfs-site.xml ${INSTALL_PATH}/hadoop-${HADOOP_VERSION}/etc/hadoop/hdfs-site.xml
COPY hadoop/mapred-site.xml ${INSTALL_PATH}/hadoop-${HADOOP_VERSION}/etc/hadoop/mapred-site.xml
COPY hadoop/yarn-site.xml ${INSTALL_PATH}/hadoop-${HADOOP_VERSION}/etc/hadoop/yarn-site.xml

RUN set -eux; \
    cd ${INSTALL_PATH}; \
    if [ ! -d "hbase-${HBASE_VERSION}" ]; then \
    wget -q -O hbase-${HBASE_VERSION}-bin.tar.gz \
    https://archive.apache.org/dist/hbase/stable/hbase-${HBASE_VERSION}-bin.tar.gz; \
    tar -xzf hbase-${HBASE_VERSION}-bin.tar.gz; \
    rm -f hbase-${HBASE_VERSION}-bin.tar.gz; \
    fi

COPY hbase/hbase-site.xml ${INSTALL_PATH}/hbase-${HBASE_VERSION}/conf/hbase-site.xml


RUN set -eux; \
    cd ${INSTALL_PATH}; \
    if [ ! -d "apache-zookeeper-${ZOOKEEPER_VERSION}-bin" ]; then \
    wget -q -O apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz \
    https://dlcdn.apache.org/zookeeper/stable/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz; \
    tar -xzf apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz; \
    rm -f apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz; \
    fi

COPY zookeeper/zoo.cfg ${INSTALL_PATH}/apache-zookeeper-${ZOOKEEPER_VERSION}-bin/conf/zoo.cfg

RUN cp /home/vscode/.bashrc /home/vscode/.bashrc_custom && \
    : > /home/vscode/.bashrc && \
    echo "export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64" >> /home/vscode/.bashrc && \
    echo "export INSTALL_PATH=${INSTALL_PATH}" >> /home/vscode/.bashrc && \
    echo "export MY_HADOOP_HOME=${INSTALL_PATH}/hadoop-${HADOOP_VERSION}" >> /home/vscode/.bashrc && \
    echo 'export HADOOP_HOME=$MY_HADOOP_HOME' >> /home/vscode/.bashrc && \
    echo 'export PATH=$PATH:$MY_HADOOP_HOME/bin:$MY_HADOOP_HOME/sbin' >> /home/vscode/.bashrc && \
    echo "export MY_ZOOKEEPER_HOME=${INSTALL_PATH}/apache-zookeeper-${ZOOKEEPER_VERSION}-bin" >> /home/vscode/.bashrc && \
    echo 'export PATH=$PATH:$MY_ZOOKEEPER_HOME/bin' >> /home/vscode/.bashrc && \
    echo "export MY_HBASE_HOME=${INSTALL_PATH}/hbase-${HBASE_VERSION}" >> /home/vscode/.bashrc && \
    echo 'export PATH=$PATH:$MY_HBASE_HOME/bin' >> /home/vscode/.bashrc && \
    echo '' >> /home/vscode/.bashrc && \
    cat /home/vscode/.bashrc_custom >> /home/vscode/.bashrc && \
    rm /home/vscode/.bashrc_custom && \
    chown vscode:vscode /home/vscode/.bashrc




# Setup ssh
RUN sudo mkdir -p /run/sshd

# Prepare SSH directory
RUN mkdir -p /home/vscode/.ssh \
    && chmod 700 /home/vscode/.ssh \
    && chown vscode:vscode /home/vscode/.ssh

# Generate SSH key pair for vscode and authorize it
RUN ssh-keygen \
    -t ed25519 \
    -f /home/vscode/.ssh/id_ed25519 \
    -N "" \
    && cat /home/vscode/.ssh/id_ed25519.pub >> /home/vscode/.ssh/authorized_keys \
    && chmod 600 /home/vscode/.ssh/authorized_keys \
    && chown vscode:vscode /home/vscode/.ssh/authorized_keys

# Setup config
RUN printf "Host localhost 127.0.0.1\n\
    StrictHostKeyChecking no\n\
    UserKnownHostsFile /dev/null\n\
    LogLevel ERROR\n" > /home/vscode/.ssh/config \
    && chmod 600 /home/vscode/.ssh/config \
    && chown -R vscode:vscode /home/vscode/.ssh


COPY scripts /home/vscode/.local/bin
RUN sudo chmod +x /home/vscode/.local/bin/*


WORKDIR /home/vscode
CMD ["/bin/bash", "-c", "sudo /usr/sbin/sshd && sleep infinity"]

