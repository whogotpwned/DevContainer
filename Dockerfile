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
    zsh \
    fzf \
    # WeasyPrint dependencies
    libcairo2 libcairo2-dev \
    libpango-1.0-0 libpango1.0-dev \
    libgdk-pixbuf2.0-0 libgdk-pixbuf2.0-dev \
    libffi-dev \
    shared-mime-info \
    libjpeg-dev libxml2-dev libxslt1-dev \
    libfontconfig1 libfreetype6 libharfbuzz-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set up a user and allow passwordless sudo
ARG USERNAME=dev
RUN useradd -ms /bin/bash $USERNAME && \
    usermod -aG sudo $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install Oh My Zsh manually for the user and enable fzf plugin
USER root
RUN git clone https://github.com/ohmyzsh/ohmyzsh.git /home/$USERNAME/.oh-my-zsh && \
    cp /home/$USERNAME/.oh-my-zsh/templates/zshrc.zsh-template /home/$USERNAME/.zshrc && \
    sed -i 's/plugins=(git)/plugins=(git fzf)/' /home/$USERNAME/.zshrc && \
    chown -R $USERNAME:$USERNAME /home/$USERNAME/.oh-my-zsh /home/$USERNAME/.zshrc

# Switch to dev user
USER $USERNAME
WORKDIR /home/$USERNAME

# Use zsh as default shell
SHELL ["/bin/zsh", "-c"]
CMD ["zsh"]
