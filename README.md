# Dockerfile
Dockerfile to build GCO BSP using Yocto into a Docker
## Configuring the workspace
First of all, this repository is based on [cuteradio](https://github.com/bstubert/cuteradio) Dockerfile repository. If you do not have installed Docker on your host, I highly recommend you to follow its post [Using Docker Containers for Yocto Builds](https://www.embeddeduse.com/2019/02/11/using-docker-containers-for-yocto-builds).
The main idea of [gcoUVa/Dockerfile](https://github.com/gcoUVa/Dockerfile) repository is to give the chance to build the gco-bsp images in any system which supports Docker.
## Cloning the repository
```sh
$ git clone https://github.com/gcoUVa/Dockerfile.git
```
## Building the Docker image from scratch
It creates an image with [gco-bsp](https://github.com/gcoUVa/v2x-platform) sources, ready for be compiled.
For root permissions use 'docker' password.
```sh
$ cd Dockerfile
$ docker build --no-cache --build-arg "host_uid=$(id -u)" --build-arg "host_gid=$(id -g)" --tag "gco-uva-image:latest" .
```
## Running GCO-UVA Docker image
```sh
$ cd Dockerfile
$ mkdir output
$ docker run -it --rm -v $PWD/output:/home/docker/gco-bsp/build gco-uva-image:latest
```
By this way you can save cache and sstate-cache from your Yocto buildings, and every time that you run the docker image the data will be rescued.
## Compiling V2X image for Hummingboard
```sh
$ docker run -it --rm -v $PWD/output:/home/docker/gco-bsp/build gco-uva-image:latest
$ cd gco-bsp
$ repo sync
$ MACHINE=solidrun-imx6 DISTRO=poky source setup-environment build
$ bitbake core-image-v2x-dev
```
## Contributing
Email
    javier.fernandez.pastrana@gmail.com

## License
MIT
