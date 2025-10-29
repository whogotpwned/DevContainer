# Base Dev Container for all projects
FROM ubuntu:24.04

# Set noninteractive to avoid tzdata prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install common tools
RUN apt-get update && apt-get install -y \
    git curl wget vim nano make build-essential \
    python3 python3-venv python3-pip \
    nodejs npm \
    golang \
    docker.io \
    openssh-client \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set up a user (optional)
ARG USERNAME=dev
RUN useradd -ms /bin/bash $USERNAME && \
    usermod -aG sudo $USERNAME

USER $USERNAME
WORKDIR /home/$USERNAME

# Default shell
CMD [ "bash" ]
