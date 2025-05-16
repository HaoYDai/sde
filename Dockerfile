# ARG HOST_USER
# Base Image
FROM ubuntu:18.04
ARG HOST_USER
 
# Author
LABEL maintainer="darren <Darren_Serious@hotmail.com>"

ENV TZ=Asia/Shanghai

COPY resource/ /opt/resource/

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
        && echo $TZ > /etc/timezone \
        && apt-get update --fix-missing && apt-get install -y \
                build-essential git libcurl4-openssl-dev \
                libgtest-dev libxml2-dev pkg-config repo ssh \
                make gcc libssl-dev liblz4-tool g++ patchelf chrpath \
                gawk texinfo chrpath diffstat binfmt-support \
                qemu-user-static live-build bison flex fakeroot \
                unzip device-tree-compiler ncurses-dev p7zip bc tree \
                whiptail sudo time expect rsync xxd file bsdmainutils \
                python3-pip \
        && pip3 install conan \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
        && useradd -m -s /bin/bash ${HOST_USER} \
        && echo "${HOST_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
        && bash /opt/resource/install_resource.sh

USER ${HOST_USER}
 
# workspace
WORKDIR /home

