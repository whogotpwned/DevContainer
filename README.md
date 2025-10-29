# DevContainer

![Banner](./banner.png)

A multi-architecture development container image based on Ubuntu 24.04, pre-configured with essential development tools and a comfortable shell environment.

[![Docker Build](https://github.com/whogotpwned/DevContainer/actions/workflows/docker-build.yml/badge.svg)](https://github.com/whogotpwned/DevContainer/actions/workflows/docker-build.yml)

## Features

- **Multi-architecture support**: Built for both `linux/amd64` and `linux/arm64` platforms
- **Pre-installed development tools**: Python, Node.js, Go, Docker, and more
- **Enhanced shell environment**: Includes zsh with Oh My Zsh and fzf for an improved terminal experience
- **Ready-to-use**: No additional configuration required

## Architecture Support

This container image is built for multiple architectures:
- `linux/amd64` (Intel/AMD 64-bit)
- `linux/arm64` (ARM 64-bit, e.g., Apple Silicon)

Both architectures are automatically built and pushed to the GitHub Container Registry.

## Prerequisites

- Docker or a Docker-compatible container runtime
- For local builds: Docker Buildx (included with Docker Desktop)

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

You can customize the container during build:

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

If you need Docker inside the container:

```bash
docker run -it --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  ghcr.io/whogotpwned/devcontainer:latest
```

### Interactive Development

The container starts with zsh as the default shell. The default user is `dev` with sudo privileges (no password required).

## Included Tools

The container comes pre-installed with:

### Core Development Tools
- **Git**: Version control system
- **Build tools**: `make`, `build-essential`
- **Text editors**: `vim`, `nano`

### Programming Languages
- **Python 3**: Python runtime with `pip` and `venv`
- **Node.js**: JavaScript runtime with `npm`
- **Go**: Go programming language

### Container Tools
- **Docker**: Docker daemon and client (`docker.io`)

### Shell Environment
- **zsh**: Z shell with enhanced features
- **Oh My Zsh**: Framework for managing zsh configuration
- **fzf**: Fuzzy finder for command-line
- Configured plugins: `git`, `fzf`

### System Utilities
- **curl**, **wget**: HTTP clients
- **openssh-client**: SSH client tools

### WeasyPrint Dependencies
The container includes all dependencies required for WeasyPrint (Python PDF library):
- Cairo graphics library and development files
- Pango text layout engine
- GDK-Pixbuf image loading library
- Various font and image processing libraries

## Image Details

- **Base Image**: `ubuntu:24.04`
- **Default User**: `dev` (configurable via build arg `USERNAME`)
- **Working Directory**: `/home/dev`
- **Default Shell**: `/usr/bin/zsh`
- **User Privileges**: `dev` user has sudo access (no password required)

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

**Note**: Make sure you're logged into GHCR if the repository is private:
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

