# DevContainer

![Banner](./banner.png)

A production-ready multi-architecture development container image based on Ubuntu 24.04, pre-configured with essential development tools and a comfortable shell environment for modern development workflows.

[![Docker Build](https://github.com/whogotpwned/DevContainer/actions/workflows/docker-build.yml/badge.svg)](https://github.com/whogotpwned/DevContainer/actions/workflows/docker-build.yml)

![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04-E95420?style=flat-square&logo=ubuntu&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-24.10-2496ED?style=flat-square&logo=docker&logoColor=white)
![Multi-Arch](https://img.shields.io/badge/multi--arch-amd64%20%7C%20arm64-0078D4?style=flat-square&logo=docker&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.12-3776AB?style=flat-square&logo=python&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-20.x-339933?style=flat-square&logo=nodedotjs&logoColor=white)
![Go](https://img.shields.io/badge/Go-1.23-00ADD8?style=flat-square&logo=go&logoColor=white)
![Zsh](https://img.shields.io/badge/Zsh-5.9-1B2C34?style=flat-square&logo=gnu-bash&logoColor=white)

## Features

- **Multi-architecture support**: Built for both `linux/amd64` and `linux/arm64` platforms
- **Comprehensive development toolkit**: Python, Node.js, Go, Docker, and essential build tools
- **Enhanced shell experience**: Includes zsh with Oh My Zsh and fzf for superior productivity
- **Zero-configuration**: Ready to use immediately without additional setup

## Architecture Support

This container image is built for multiple architectures:
- `linux/amd64` (Intel/AMD 64-bit)
- `linux/arm64` (ARM 64-bit, e.g., Apple Silicon)

Both architectures are automatically built and pushed to the GitHub Container Registry.

## Prerequisites

- Docker or a Docker-compatible container runtime
- For local multi-arch builds: Docker Buildx (included with Docker Desktop)

## Building Locally

### Single Architecture Build

Build for your current platform:

```bash
docker build -t devcontainer:latest .
```

### Multi-architecture Build

Build for both architectures (requires Docker Buildx):

```bash
# Create and use a buildx builder instance
docker buildx create --name multiarch --use

# Build for multiple platforms
docker buildx build --platform linux/amd64,linux/arm64 -t devcontainer:latest --load .
```

**Note**: The `--load` flag only loads a single platform image. To export for multiple platforms, use `--push` or `--output type=registry`.

### Custom Build Arguments

Customize the container during build:

```bash
docker build --build-arg USERNAME=myuser -t devcontainer:latest .
```

**Available build arguments:**
- `USERNAME`: Default username (default: `dev`)

## Running the Container

### Basic Usage

```bash
docker run -it --rm ghcr.io/whogotpwned/devcontainer:latest
```

### With Volume Mounting

Mount your workspace into the container:

```bash
docker run -it --rm \
  -v $(pwd):/home/dev/workspace \
  ghcr.io/whogotpwned/devcontainer:latest
```

### With Docker-in-Docker

Run Docker commands inside the container:

```bash
docker run -it --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  ghcr.io/whogotpwned/devcontainer:latest
```

### Interactive Development

The container starts with zsh as the default shell. The default user is `dev` with passwordless sudo privileges for seamless development.

## Included Tools

The container comes pre-installed with a comprehensive set of development tools:

### Programming Languages

- **Python 3**: Runtime with `pip` and `venv`
- **Node.js**: JavaScript runtime with `npm`
- **Go**: Go programming language

### Version Control & Build Tools

- **Git**: Version control system
- **make**: Build automation tool
- **build-essential**: Essential compilation tools

### Text Editors

- **vim**: Advanced text editor
- **nano**: Simple terminal editor

### Container Tools

- **Docker**: Docker daemon and client (`docker.io`)

### Shell Environment

- **zsh**: Enhanced Z shell
- **Oh My Zsh**: zsh configuration framework
- **fzf**: Command-line fuzzy finder
- **Configured plugins**: `git`, `fzf`

### Network & System Tools

- **curl**, **wget**: HTTP clients
- **openssh-client**: SSH client tools

### Python Libraries

**WeasyPrint Dependencies**: All dependencies required for WeasyPrint (Python PDF library):
- Cairo graphics library and development files
- Pango text layout engine
- GDK-Pixbuf image loading library
- Font and image processing libraries

## Image Details

- **Base Image**: `ubuntu:24.04`
- **Default User**: `dev` (configurable via `USERNAME` build arg)
- **Working Directory**: `/home/dev`
- **Default Shell**: `/usr/bin/zsh`
- **User Privileges**: Passwordless sudo access

## CI/CD

This project uses GitHub Actions to automatically build and push container images to the GitHub Container Registry (GHCR) whenever changes are pushed to the main branch.

**Registry**: `ghcr.io/whogotpwned/devcontainer`

**Image Tags**:
- `latest`: Latest build from main branch
- `sha-<commit-sha>`: Tagged builds for specific commits

The workflow builds multi-architecture images for both `linux/amd64` and `linux/arm64`.

### Pulling the Image

```bash
docker pull ghcr.io/whogotpwned/devcontainer:latest
```

**Note**: For private repositories, authenticate with GHCR:

```bash
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin
```

## Customization

### Changing the Default User

Build with a custom username:

```bash
docker build --build-arg USERNAME=developer -t devcontainer:latest .
```

### Extending the Image

Create your own `Dockerfile` that extends this image:

```dockerfile
FROM ghcr.io/whogotpwned/devcontainer:latest

# Install additional tools
USER root
RUN apt-get update && apt-get install -y \
    your-custom-package \
    && apt-get clean

USER dev
```

## License

Check the repository for license information.

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.
