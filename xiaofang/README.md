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

Build RTSP server:
```
cd /snx_sdk/app/example/src/ipc_func/rtsp_server
make
```
