FROM ubuntu:16.04
MAINTAINER James Allenby <jallenby37@gmail.com>

#
# Useful packages and utilities
#
ARG SYSTEM_PKGS="android-tools-adb android-tools-fastboot bash-completion bsdmainutils ccache file vim screen sudo tig vim wget software-properties-common cpio"

#
# A list of all dependencies that are required to build LineageOS
#
ARG LINEAGEOS_DEPS="bc bison build-essential curl flex g++-multilib gcc-multilib git gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev lib32z1-dev liblz4-tool libncurses5-dev libsdl1.2-dev libssl-dev libwxgtk3.0-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev openjdk-8-jdk repo"

#
# Upgrade the container packages to the latest
# Download and install all LineageOS build dependencies
#
RUN export DEBIAN_FRONTEND=noninteractive &&\
    apt-get update &&\
    apt-get -y upgrade &&\
    apt-get -y install $SYSTEM_PKGS $LINEAGEOS_DEPS

#
# Install the OpenJDK 7 package for building
# LineageOS 11.0-13.0
#
RUN add-apt-repository -y ppa:openjdk-r/ppa &&\
    apt-get update &&\
    apt-get -y install openjdk-7-jdk

#
# Install Android bootimg tools
#

#
# Initialise directories for building LineageOS and
# set-up volumes for usage outside the container
#
RUN mkdir /srv/lineageos /srv/ccache
VOLUME /srv

#
# Enable SSH access from the outside
#
EXPOSE 22/tcp

#
# Set-up environment such as ccache and path
#
ENV ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4G"\
    USE_CCACHE=1\
    CCACHE_SIZE=50G\
    CCACHE_DIR=/srv/ccache\
    CCACHE_COMPRESS=1   

#
# Set-up the working directory to the root of lineageos and ccache
#
WORKDIR /srv

#
# Set bash to be the container entrypoint
#
ENTRYPOINT /bin/bash
