FROM mcr.microsoft.com/devcontainers/base:noble

USER root

# Install dependencies
RUN apt-get update -y && apt-get upgrade -y

RUN apt-get install -y  \
    ca-certificates     \
    git                 \
    curl                \
    wget                \
    vim                 \
    nano                \
    micro               \
    python3

USER vscode
COPY .bashrc /home/vscode/.bashrc

USER root
COPY .bashrc /root/.bashrc

USER vscode
WORKDIR /home/vscode
CMD [ "sleep" , "infinity" ]
