FROM ubuntu:16.04                                                                

MAINTAINER Javier Fernandez Pastrana <javier.fernandez.pastrana@gmail.com>                               

# Upgrade system and Yocto Proyect basic dependencies                            
RUN apt-get update && apt-get -y upgrade && apt-get -y install vim gawk wget git-core diffstat unzip texinfo gcc-multilib build-essential chrpath socat cpio python python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping libsdl1.2-dev xterm curl
                                                                                 
# Set up locales                                                                 
RUN apt-get -y install locales apt-utils sudo && dpkg-reconfigure locales && locale-gen en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 
ENV LANG en_US.utf8                                                              
                                                                                 
ENV USER_NAME docker

# Clean up APT when done.                                                        
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*               
                                                                                 
# Replace dash with bash                                                         
RUN rm /bin/sh && ln -s bash /bin/sh                                        
                                                                                 
# User management                                                                
ARG host_uid=1001
ARG host_gid=1001
RUN groupadd -g $host_gid $USER_NAME && useradd -g $host_gid -m -s /bin/bash -u $host_uid $USER_NAME
RUN echo "$USER_NAME:$USER_NAME" | chpasswd && adduser $USER_NAME sudo
                                                                                 
# Install repo                                                                   
RUN curl -o /usr/local/bin/repo https://storage.googleapis.com/git-repo-downloads/repo && chmod a+x /usr/local/bin/repo 

ENV WORK_DIR /home/$USER_NAME/
                                                                                 
# Set the Yocto release                                                          
ENV YOCTO_RELEASE "sumo"                                                         

# Install GCO-BSP
USER $USER_NAME
WORKDIR $WORK_DIR
RUN mkdir -p gco-bsp && cd gco-bsp && repo init -u https://github.com/gcoUVa/v2x-platform.git -b ${YOCTO_RELEASE} && repo sync && mkdir build
