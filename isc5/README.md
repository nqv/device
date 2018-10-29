# iSC5 Camera

## Bootstrap

```
mkfs.vfat -F 32 /dev/sdb1
mount /dev/sdb1 /media/sdb1
cp snx_autorun /media/sdb1
```

```
nmap -p 23 192.168.1.0/24
telnet 192.168.1.200
# root:ismart12
```

## SDK
Unpack SDK:
```
tar xf SN986_1.60_QR_Scan_019a_20160606_0951.tgz
cd SN986_1.60_QR_Scan_019a_20160606_0951
bash sdk.unpack
```

Run container:
```
./run-builder.sh
```

Set up environment:
```
cd /snx_sdk/buildscript
make sn98660_QR_Scan_402mhz_sf_defconfig
```

Install libraries:
```
cd /snx_sdk/middleware
mkdir -p _install/lib _install/include
cp video/middleware/lib/lib* rate_ctl/middleware/lib/lib* sdrecord/middleware/lib/lib* audio/middleware/lib/lib* _install/lib
cp -r video/middleware/include/snx_isp video/middleware/include/snx_vc rate_ctl/middleware/include/snx_rc sdrecord/middleware/include/snx_record audio/middleware/include/* _install/include
```

### RTSP server
```
cd /snx_sdk/app/example/src/ipc_func/rtsp_server
make
```

### Dropbear
```
cd /snx_sdk/app/dropbear
CC=${CROSS_COMPILE}gcc AR=${CROSS_COMPILE}ar RANLIB=${CROSS_COMPILE}ranlib STRIP=${CROSS_COMPILE}strip ./configure --host=arm-linux --disable-zlib --disable-lastlog --disable-utmp --disable-utmpx --disable-wtmp --disable-wtmpx
make PROGRAMS="dropbear dropbearkey scp" STATIC=1
```

```
mkdir /etc/dropbear
./bin/dropbear -R -F -E
```
./bin/dropbearkey -t rsa -f dropbear_rsa_host_key
./bin/dropbear -r dropbear_rsa_host_key -F -E
```
