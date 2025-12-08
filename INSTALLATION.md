# Creating the TTT publications

This file contains the instructions of how to build the various ebook formats of the Taming the Terminal tutorial.

## 2025-12-08 Update

The old Ruby build system didn't work any more, so the build system is now switched to a Docker container with a Makefile with easy targets to build the Docker container and the publication.

This document describes how to set up a fresh macOS machine so you can build the HTML, EPUB, PDF, Kindle, and static-site outputs for Taming the Terminal using the Docker-based toolchain.

The project is designed so all heavy dependencies run inside Docker, keeping your local system clean. Only lightweight tools (Docker + Make) are required on your Mac.

## System Requirements

### macOS Version

- macOS **12 Monterey** or later recommended  
- Intel and Apple Silicon are both supported

### Required tools

- Docker Desktop
- Make (preinstalled)
(Optional: Git, VS Code)

## Install Docker Desktop

Download from https://www.docker.com/products/docker-desktop/

After installation check the version to see if all runs.

```shell
docker --version
docker compose version
```

## Clone the Repository

```shell
git clone https://github.com/bartificer/taming-the-terminal.git
cd taming-the-terminal
```

## How the Build Environment Works

The book-builder Docker container contains:

- Ruby, Asciidoctor, EPUB/PDF toolchains
- Node.js + QR code tooling
- epubcheck
- Themes, fonts

Local mounts:

- `book/` source
- `output/` build artifacts
- `docs/` website output
- `website-static/`
- `scripts/`

Node dependencies live in a Docker volume: `node_modules_cache`.

## Building (Make Commands)

All commands are now added to the Makefile to allow for easy to remember commands.

### Help

Both

```shell
make
```

and

```shell
make help
```

give an explanation of available commands.

## First-Time Setup

If you haven't created the Docker container before or after changes in the Dockerfile and/or the docker-compose.yml file, you need to run a few commands to create and prepare the Docker container:

```shell
# Generate the container
make docker-build

# Install Node deps
make npm-install
```


## Build a release

See RELEASE.md for detailed instructions on creating a release.

For a test run:

```shell
# check if all the necessary files are updated based on a new episode
make check

# build the output formats
make build
```

