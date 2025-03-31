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
      cmake \
      git \
      libcurl4-openssl-dev \
      libgtest-dev \
      libxml2-dev \
      pkg-config repo ssh make gcc libssl-dev liblz4-tool \
       g++ patchelf chrpath gawk texinfo chrpath diffstat binfmt-support \
      qemu-user-static live-build bison flex fakeroot gcc-multilib g++-multilib \
      unzip device-tree-compiler ncurses-dev p7zip bc tree \
      whiptail sudo time expect rsync xxd python2 file bsdmainutils \
      && ln -s /usr/bin/python3 /usr/bin/python
 
# workspace
WORKDIR /home

