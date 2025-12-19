FROM ghcr.io/obnitram/devcontainer/base:latest

USER root

# Install dependencies
RUN apt-get update -y && apt-get upgrade -y

RUN apt-get install -y \
    build-essential \
    gdb             \
    cmake           \
    clang-format    \
    lldb            \
    lld             \
    cppcheck        \
    valgrind       

USER vscode
WORKDIR /home/vscode
CMD [ "sleep" , "infinity" ]
