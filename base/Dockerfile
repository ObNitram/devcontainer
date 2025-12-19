FROM mcr.microsoft.com/devcontainers/base:noble

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

COPY .bashrc /home/vscode/.bashrc

COPY .bashrc /root/.bashrc

USER vscode
CMD [ "sleep" , "infinity" ]
