FROM debian:jessie

RUN echo "dash dash/sh boolean false" | debconf-set-selections \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash
RUN echo 'deb-src http://deb.debian.org/debian jessie main' >> /etc/apt/sources.list

# Essential packages
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y \
      build-essential libencode-detect-perl libncurses5-dev lzop \
      libstdc++6:i386 zlib1g:i386 \
      autoconf cmake curl wget git-core

# Extra packages
RUN apt-get install -y libtool \
    gettext \
    pkg-config \
    bison \
    screen

RUN apt-get clean

ARG USER_ID=1000
ARG GROUP_ID=1000

RUN groupadd --system --gid $GROUP_ID snx \
    && useradd --no-log-init --system --gid snx --uid $USER_ID snx
