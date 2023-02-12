[![License](https://img.shields.io/badge/license-MIT-blue)](./LICENSE)
[![Ubuntu](https://img.shields.io/badge/ubuntu-20.04-orange)](https://ubuntu.com)
[![Ubuntu](https://img.shields.io/badge/ubuntu-22.04-orange)](https://ubuntu.com)

[![ARM64](https://img.shields.io/badge/linux%2farm64-Yes-red)](https://hub.docker.com/repository/docker/gpfister/firebase-devenv/tags)
[![AMD64](https://img.shields.io/badge/linux%2famd64-Yes-red)](https://hub.docker.com/repository/docker/gpfister/firebase-devenv/tags)

# Docker Dev Environment

Copyright (c) 2023, Greg PFISTER. MIT License

<div id="about" />

## About

This is a simple Ubuntu container to use as development environment for Docker
projects.

This is image is provided with both Ubuntu 20.04 and Ubuntu 22.04.

See [version](#version) mapping to find out which version Ubuntu and node and java.

This image is built from
[ghcr.io/gpfister/gp-base-devenv](https://github.com/gpfister/gp-base-devenv/pkgs/container/gp-base-devenv).

<div id="volumes" />

## Volumes

In order to persist user data, a volume for the /home folder is set. The root
user will not be persisted.

| Volume | Description                                        |
| ------ | -------------------------------------------------- |
| /home  |  Persist the user data stored in their home folder |

<div id="build-run-scan-push" />

## Build, scan and push

### Versioning

Image version contains the Ubuntu version and the build version, using the
format `<Ubuntu version>-<Build version>`. The build version refers to the
latest Dockerfile script, when modification consists of fixing (patch change),
or adding or removing something significant (minor change) or breaking (major).

Images are builts daily using the last build version (at the moment), and is
tagged with the day (`-YYYYMMDD`).

For example:

| Image                                                    | Description                                          |
| -------------------------------------------------------- | ---------------------------------------------------- |
| ghcr.io/gpfister/gp-firebase-devenv:22.04                | The latest build using Ubuntu 22.04                  |
| ghcr.io/gpfister/gp-firebase-devenv:22.04-1.1.0          | The latest build 1.1.0 using Ubuntu 22.04            |
| ghcr.io/gpfister/gp-firebase-devenv:22.04-1.1.0-20230102 | The build 1.1.0 on 2023 Jan. 2nd, using Ubuntu 22.04 |
| ghcr.io/gpfister/gp-firebase-devenv:22.04-1.0.0          | The latest build 1.0.0 using Ubuntu 22.04            |
| ghcr.io/gpfister/gp-firebase-devenv:22.04-1.0.0-20230101 | The build 1.0.0 on 2023 Jan. 1st, using Ubuntu 22.04 |

For CI/CD, the build version is store in `.version` file. The build version is
in the format
[SemVer](https://en.wikipedia.org/wiki/Software_versioning#Semantic_versioning).

### Testing locally using `-dev` images

When you are making change to the image, use :develop at the end of the
[build](#build), [run](#run) and [scan](#scan) commands. The `*-dev` tag
should never be pushed...

### Cross-platform building

#### Setup

In order to build x-platform, `docker buildx` must be enabled (more info
[here](https://docs.docker.com/buildx/working-with-buildx/)). Then, instead of
`build` command, `buildx` command should be used (for example:
`npm run buildx:develop` will create a cross-platform image tagged `develop`).

You will need to create a multiarch builder:

```sh
./src/scripts/buildx/setup.sh
```

Up successful completion, it should at least have platforms `linux/arm64` and
`linux/amd64`:

```sh
[+] Building 5.8s (1/1) FINISHED
 => [internal] booting buildkit                                             5.8s
 => => pulling image moby/buildkit:buildx-stable-1                            7s
 => => creating container buildx_buildkit_multiarch0                          1s
Name:   multiarch
Driver: docker-container

Nodes:
Name:      multiarch0
Endpoint:  unix:///var/run/docker.sock
Status:    running
Platforms: linux/arm64, linux/amd64, linux/amd64/v2, linux/riscv64,
           linux/ppc64le, linux/s390x, linux/386, linux/mips64le, linux/mips64,
           linux/arm/v7, linux/arm/v6
```

#### Build commands

Once the previous step is completed, simpy run to build the current version:

```sh
(cd src && ./scripts/buildx/build.sh)
```

<div id="build" />

### Build using local architecture (for local testing)

To build using a specific Ubuntu version, use:

```sh
(cd scr && ./scripts/dev/build.sh <UBUNTU_VERSION>)
```

where `UBUNTU_VERSION` can be 20.04 or 22.04.

It will create and image `gpfister/gp-firebase-devenv` tagged with the current
version (see `src/.version` file) and `-dev` suffix. For example:

```sh
REPOSITORY                       TAG               IMAGE ID       CREATED          SIZE
gpfister/gp-firebase-devenv      22.04-1.0.0-dev   21a32a4c2177   11 minutes ago   916MB
gpfister/gp-firebase-devenv      20.04-1.0.0-dev   466450fda71c   12 minutes ago   873MB
```

You may alter the `.src/.version` file should you want to have different tags or
names, however if you PR your change, it will be rejected. The ideal solution
is to run the `docker build` command instead.

<div id="run" />

## Run a container

To run an interactive container of a give Ubuntu version, simple use:

```sh
(cd src && ./scripts/dev/start.sh <UBUNTU_VERSION>)
```

where `UBUNTU_VERSION` can be 20.04 or 22.04.

<div id="scan" />

### Scan

To scan the image of a give Ubuntu version, simple use:

```sh
(cd src && ./scripts/dev/scan.sh <UBUNTU_VERSION>)
```

where `UBUNTU_VERSION` can be 20.04 or 22.04.

<div id="build-from-this-image" />

## Build from this image

Should you want to make other changes, the ideal solution is to build from this
image. For example, here's the way to set the image to a different timezone than
"Europe/Paris" (the default one):

```Dockerfile
FROM gpfister/firebase-devenv:latest

ENV TZ="America/New_York"

# Switch to root
USER root

# Reconfigure tzdata
RUN dpkg-reconfigure -f noninteractive tzdata

# Switch back to vscode
USER vscode
```

**Important:** unless you really want to use the root user, you should always
make sure the `vscode` is the last one activate.

<div id="version" />

## Version

_`Base image version` correspond to the undelying base image that can be found
[here](https://github.com/gpfister/gp-base-devenv/pkgs/container/gp-base-devenv)_

|    Image    |           Base image version          |   Ubuntu    | amd64 | arm64 |
| :---------: | :-----------------------------------: | :---------: | :---: | :---: |
| 20:04-1.0.0 | ghcr.io/gpfister/gp-base-devenv:20.04 | 20.04 (LTS) |   X   |   X   |
| 22:04-1.0.0 | ghcr.io/gpfister/gp-base-devenv:22.04 | 22.04 (LTS) |   X   |   X   |

<div id="faq" />

## FAQ

1. [How to require password for sudo command ?](#faq1)
2. [Is there an example to use it with Visual Studio Code ?](#faq2)

<div id="faq1" />

### 1. How to require password for sudo command ?

You will have to [build from this image](#build-from-this-image) to disable the
the password less sudo command. Typically create a `Dockerfile` like:

```Dockerfile
FROM gpfister/firebase-devenv:latest

ARG VSCODE_PASSWORD="dummy"

# Switch to root to make changes
USER root

# Remove the specific config for sudo and add to sudo group
RUN rm /etc/sudoers.d/vscode && \
    usermod -aG sudo vscode

# Change the password.
RUN usermod -p $VSCODE_PASSWORD vscode

# Switch back to vscode
USER vscode
```

If you simply want to get rid of `sudo`:

```Dockerfile

FROM gpfister/firebase-devenv:latest

# Switch to root to make changes
USER root

# Remove the specific config for sudo and add to sudo group
RUN rm /etc/sudoers.d/vscode && \
    apt-get purge -y sudo

# Switch back to vscode
USER vscode
```

<div id="faq2"/>

### 2. Is there an example to use it with Visual Studio Code ?

There will be one soon !!! Add notification to this project so that when the
update on this file is done you can check.

<div id="known_issues" />

## Known issues

See known issues [here](./KNOWN_ISSUES.md).

<div id="contrib" />

## Contributions

See instructions [here](./CONTRIBUTING.md).

<div id="license" />

## License

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

See license [here](./LICENSE.md).
