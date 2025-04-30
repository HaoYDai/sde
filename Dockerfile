# Base Image
FROM ubuntu:22.04

# Author
LABEL maintainer="darren <Darren_Serious@hotmail.com>"

ENV TZ=Asia/Shanghai

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

# expect
RUN apt-get update --fix-missing && apt-get install -y \
      build-essential \
      git \
      libcurl4-openssl-dev \
      libgtest-dev \
      libxml2-dev \
      pkg-config repo ssh make gcc libssl-dev liblz4-tool \
       g++ patchelf chrpath gawk texinfo chrpath diffstat binfmt-support \
      qemu-user-static live-build bison flex fakeroot gcc-multilib g++-multilib \
      unzip device-tree-compiler ncurses-dev p7zip bc tree \
      whiptail sudo time expect rsync xxd python2 file bsdmainutils \
      && ln -s /usr/bin/python3 /usr/bin/python \
      && wget -P /opt/ https://cmake.org/files/v3.31/cmake-3.31.7-linux-x86_64.tar.gz \
      && tar -zxvf /opt/cmake-3.31.7-linux-x86_64.tar.gz -C /opt/ \
      && ln -s /opt/cmake-3.31.7-linux-x86_64/bin/* /usr/bin/ \
      && rm -rf /opt/cmake-3.31.7-linux-x86_64.tar.gz \
      && wget -P /usr/ https://github.com/HaoYDai/builds/releases/download/grpc_v1.71.1_ubuntu22_x86_64/grpc_v1.71.1_ubuntu22_x86_64.tar.gz \
      && tar -zxvf /usr/grpc_v1.71.1_ubuntu22_x86_64.tar.gz -C /usr/ \
      && rm -rf /usr/grpc_v1.71.1_ubuntu22_x86_64.tar.gz \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
 
# workspace
WORKDIR /home

