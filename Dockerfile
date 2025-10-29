# Base Dev Container
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV SHELL=/usr/bin/zsh

# Install tools
RUN apt-get update && apt-get install -y \
    git curl wget vim nano make build-essential \
    python3 python3-venv python3-pip \
    nodejs npm \
    golang \
    docker.io \
    openssh-client \
    sudo \
    zsh \
    # WeasyPrint deps
    libcairo2 libcairo2-dev \
    libpango-1.0-0 libpango1.0-dev \
    libgdk-pixbuf2.0-0 libgdk-pixbuf2.0-dev \
    libffi-dev shared-mime-info \
    libjpeg-dev libxml2-dev libxslt1-dev \
    libfontconfig1 libfreetype6 libharfbuzz-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Add dev user with passwordless sudo
ARG USERNAME=dev
RUN useradd -ms /bin/bash $USERNAME && \
    usermod -aG sudo $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install Oh My Zsh
USER root
RUN git clone https://github.com/ohmyzsh/ohmyzsh.git /home/$USERNAME/.oh-my-zsh && \
    cp /home/$USERNAME/.oh-my-zsh/templates/zshrc.zsh-template /home/$USERNAME/.zshrc && \
    sed -i 's/plugins=(git)/plugins=(git fzf)/' /home/$USERNAME/.zshrc && \
    chown -R $USERNAME:$USERNAME /home/$USERNAME/.oh-my-zsh /home/$USERNAME/.zshrc

# Install fzf manually (with key bindings for Zsh)
RUN git clone --depth 1 https://github.com/junegunn/fzf.git /home/$USERNAME/.fzf && \
    /home/$USERNAME/.fzf/install --bin --all --no-bash --no-fish && \
    chown -R $USERNAME:$USERNAME /home/$USERNAME/.fzf

# Switch to dev user
USER $USERNAME
WORKDIR /home/$USERNAME

# Default shell
CMD ["zsh"]
