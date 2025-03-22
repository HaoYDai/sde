# Base Image
FROM ubuntu:18.04
 
# Author
LABEL maintainer="darren <Darren_Serious@hotmail.com>"

 
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
      whiptail sudo time expect rsync xxd
 
# workspace
WORKDIR /home

