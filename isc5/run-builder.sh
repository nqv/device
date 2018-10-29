#!/bin/sh
docker run -i -t --rm \
  -v "$(pwd)/SN986_1.60_QR_Scan_019a_20160606_0951/snx_sdk:/snx_sdk" \
  -e "CROSS_COMPILE=/snx_sdk/toolchain/crosstool-4.5.2/bin/arm-unknown-linux-uclibcgnueabi-" \
  -e "ROOTFS=/snx_sdk/rootfs" \
  -w "/snx_sdk" \
  nqviet/snxsdk:builder
