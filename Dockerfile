# syntax=docker/dockerfile:1.4
# --- Basis: Ubuntu 24.04 für beide Architekturen ---
FROM --platform=${BUILDPLATFORM:-linux/amd64} ubuntu:24.04

# Docker setzt automatisch diese Variablen:
# BUILDPLATFORM -> Host (z.B. linux/amd64)
# TARGETPLATFORM -> Ziel (z.B. linux/arm64)
# TARGETARCH -> Architektur (amd64, arm64)
ARG TARGETARCH
ARG TARGETPLATFORM
ARG USERNAME=dev

ENV DEBIAN_FRONTEND=noninteractive
ENV SHELL=/usr/bin/zsh

# --- Plattform anzeigen (zur Fehlersuche) ---
RUN echo "Building for architecture: ${TARGETARCH}" && \
    echo "Target platform: ${TARGETPLATFORM}"

# --- Grundsystem & Tools installieren ---
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

# --- ARM64-spezifische Fixes (z. B. Node oder Go Toolchains) ---
RUN if [ "$TARGETARCH" = "arm64" ]; then \
        echo "Applying ARM64 specific adjustments..." && \
        npm install -g npm@latest; \
    else \
        echo "No ARM64-specific adjustments needed."; \
    fi

# --- Benutzer einrichten ---
RUN useradd -ms /bin/bash $USERNAME && \
    usermod -aG sudo $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# --- Oh My Zsh installieren ---
USER root
RUN git clone https://github.com/ohmyzsh/ohmyzsh.git /home/$USERNAME/.oh-my-zsh && \
    cp /home/$USERNAME/.oh-my-zsh/templates/zshrc.zsh-template /home/$USERNAME/.zshrc && \
    sed -i 's/plugins=(git)/plugins=(git fzf)/' /home/$USERNAME/.zshrc && \
    chown -R $USERNAME:$USERNAME /home/$USERNAME/.oh-my-zsh /home/$USERNAME/.zshrc

# --- fzf installieren ---
RUN git clone --depth 1 https://github.com/junegunn/fzf.git /home/$USERNAME/.fzf && \
    /home/$USERNAME/.fzf/install --bin --all --no-bash --no-fish && \
    chown -R $USERNAME:$USERNAME /home/$USERNAME/.fzf

USER $USERNAME
WORKDIR /home/$USERNAME

CMD ["zsh"]
