# Base Dev Container for all projects
FROM ubuntu:24.04

# Set noninteractive to avoid tzdata prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install common tools and Python, Node.js, Go, Docker, etc.
RUN apt-get update && apt-get install -y \
    git curl wget vim nano make build-essential \
    python3 python3-venv python3-pip \
    nodejs npm \
    golang \
    docker.io \
    openssh-client \
    dnsutils \
    sudo \
    # WeasyPrint dependencies
    libcairo2 libcairo2-dev \
    libpango-1.0-0 libpango1.0-dev \
    libgdk-pixbuf2.0-0 libgdk-pixbuf2.0-dev \
    libffi-dev \
    shared-mime-info \
    libjpeg-dev libxml2-dev libxslt1-dev \
    libfontconfig1 libfreetype6 libharfbuzz-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set up a user (optional)
ARG USERNAME=dev
RUN useradd -ms /bin/bash $USERNAME && \
    usermod -aG sudo $USERNAME

USER $USERNAME
WORKDIR /home/$USERNAME

# Default shell
CMD [ "bash" ]
