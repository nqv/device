# iSC5 Camera

## Specification
```
# uname -a
Linux iSmartAlarm 2.6.35.12 #27 Thu Dec 22 18:48:16 PST 2016 armv5tejl GNU/Linux

# cat /proc/version 
Linux version 2.6.35.12 (fedora@localhost.localdomain) (gcc version 4.5.2 (SONiX GCC-4.5.2 Release 2011-12-06) ) #27 Thu Dec 22 18:48:16 PST 2016

# cat /etc/os-release
ISA_VERSION=3.0.3.56

# cat /proc/cpuinfo
Processor       : ARM926EJ-S rev 5 (v5l)
BogoMIPS        : 200.29
Features        : swp half fastmult edsp java 
CPU implementer : 0x41
CPU architecture: 5TEJ
CPU variant     : 0x0
CPU part        : 0x926
CPU revision    : 5

Hardware        : SONiX SN98600 Development Platform
Revision        : 9302014
Serial          : 000014900827b000

# cat /proc/meminfo 
MemTotal:          36956 kB
...
```

## Bootstrap

```
# Make FAT32 partition and create snx_autorun.sh
mkfs.vfat -F 32 /dev/sdb1
mount /dev/sdb1 /media/sdb1
# Change PSK with value from `wpa_passphrase <ssid> [passphrase]`
cp snx_autorun.sh /media/sdb1
```

```
# Search for IP and telnet
nmap -p 23 192.168.1.0/24
telnet 192.168.1.200
# root:ismart12
```

To remove vendor apps, edit /etc/init.d/rcS and comment out:
```
#modprobe snx_wdt
#/usr/bin/iSC3S/iSC3S
```

## Development
Unpack SDK:
```
tar xf SN986_1.60_QR_Scan_019a_20160606_0951.tgz
cd SN986_1.60_QR_Scan_019a_20160606_0951
bash sdk.unpack
cd ..
```

Run Docker container:
```
./run-builder.sh
```

Set up environment:
```
cd /snx_sdk/buildscript
make sn98660_QR_Scan_402mhz_sf_defconfig
# Install libraries
make distribute-pre
make middleware_video middleware_rate_ctl middleware_audio middleware_gpio middleware_common middleware_sdrecord
```

### FTP Server
```
apt-get source linux-ftpd
cd linux-ftpd-0.17
./configure
sed -i "s|^CC=gcc|CC=${CROSS_COMPILE}gcc|" MCONFIG
sed -i '/^CFLAGS=/ s|$|-DUSE_SHADOW|' MCONFIG
make

# Run
./ftpd -D
```

### RTSP server
```
cd /snx_sdk/app/example/src/ipc_func/rtsp_server
make
# Also copy libsnx_vc.so libsnx_rc.so libsnx_audio.so libsnx_isp.so from middleware/_install/lib to sdcard
LD_LIBRARY_PATH=/media/mmcblk0p1/bin ./snx_rtsp_server -w 1920 -r 1080

# Play
rtsp://<IP>/media/stream1
```

### Start all services on sdcard
Copy `start.sh`, `bin` and `etc` folders to sdcard and set `START_SERVICES=1` in `snx_autorun.sh`
