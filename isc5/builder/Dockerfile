FROM debian:jessie

# Install tools
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y \
      build-essential libencode-detect-perl libncurses5-dev lzop \
      libstdc++6:i386 zlib1g:i386 \
    && echo "dash dash/sh boolean false" | debconf-set-selections \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash \
    && rm -rf /var/lib/apt/lists/*
