#!/bin/sh
docker run --interactive --tty --rm \
  --env "CROSS_COMPILE=/snx_sdk/toolchain/crosstool-4.5.2/bin/arm-unknown-linux-uclibcgnueabi-" \
  --env "ROOTFS=/snx_sdk/rootfs" \
  --volume "$(pwd)/SN986_1.60_QR_Scan_019a_20160606_0951/snx_sdk:/snx_sdk" \
  --workdir "/snx_sdk" \
  --user "$(id -u):$(id -g)" \
  nqviet/sn986:0
