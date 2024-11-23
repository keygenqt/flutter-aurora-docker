FROM ubuntu:24.04

# From .env
ARG USER
ARG CLI
ARG PSDK
ARG FLUTTER

# Add user and install sudo
RUN apt update
RUN apt install -y sudo adduser wget

RUN adduser --disabled-password --gecos '' ${USER}
RUN echo "${USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USER}
RUN chmod 0440 /etc/sudoers.d/${USER}

USER ${USER}
ENV USER=${USER}
WORKDIR /home/${USER}

# Install dependencies
RUN sudo apt install -y \
    git \
    git-lfs \
    ssh \
    curl \
    tar \
    unzip \
    bzip2 \
    clang-format

# Install latest Aurora CLI from pip
# RUN sudo apt install python3-pip -y
# RUN python3 -m pip install --upgrade setuptools --break-system-packages
# RUN python3 -m pip install aurora-cli --break-system-packages
# ENV LANG="en_EN"
# ENV PATH="/home/${USER}/.local/bin:$PATH"

# Install pyz Aurora CLI from GitHub
RUN wget https://github.com/keygenqt/aurora-cli/releases/download/${CLI}/aurora-cli-${CLI}.pyz
ENV LANG="en_EN"
RUN sudo apt install python3-pip -y
RUN python3 -m pip install shiv --break-system-packages

# Install Flutter for Aurora OS
RUN python3 aurora-cli-${CLI}.pyz api --route="/flutter/install?version=${FLUTTER}"
ENV PATH="/home/${USER}/.local/opt/flutter-${FLUTTER}/bin:$PATH"
RUN flutter precache --aurora --force

# Download PSDK, preparing for installation
RUN python3 aurora-cli-${CLI}.pyz api --route="/psdk/download?version=${PSDK}"
ENV PSDK_DIR="/home/${USER}/AuroraPlatformSDK-${PSDK}/sdks/aurora_psdk"
