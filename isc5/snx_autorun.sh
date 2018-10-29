#!/bin/sh

# For autorun:
SSID=''
# Use quoted "passphrase" string or result from wpa_passphrase without double quotes
PSK='""'
STATUS_FILE=''
SNAPSHOT_DIR=''
START_TELNETD=1
START_SERVICES=0 # Requires start.sh

# setssid <SSID> <PASSWORD>
setssid() {
	cat > /tmp/wpa_supplicant.conf <<__EOF__
ctrl_interface=/var/run/wpa_supplicant
ctrl_interface_group=0
ap_scan=1

network={
	ssid="$1"
	psk=$2
	key_mgmt=WPA-PSK
	scan_ssid=1
}
__EOF__
}

starttelnetd() {
	if ! pidof telnetd > /dev/null; then
		telnetd &
	fi
}

startwpa() {
	if pidof wpa_supplicant > /dev/null; then
		killall -HUP wpa_supplicant
	else
		wpa_supplicant -Dwext -iwlan0 -c/tmp/wpa_supplicant.conf -B
	fi
}

startudhcpc() {
	if ! pidof udhcpc > /dev/null; then
		udhcpc -i wlan0 -p /var/run/udhcpc.pid -b
	fi
}

# snapshot [DEST]
snapshot() {
	if [ ! -z "$1" ]; then
		mkdir -p "$1"
		cd "$1"
	fi

	cat /proc/partitions > partitions.proc
	cat /proc/mtd > mtd.proc
	# uboot
	dd if=/dev/mtdblock0 of=mtdblock0.img bs=4096
	# kernel
	dd if=/dev/mtdblock1 of=mtdblock1.img bs=4096
	# rootfs
	dd if=/dev/mtdblock2 of=mtdblock2.img bs=4096
	# rescue
	dd if=/dev/mtdblock3 of=mtdblock3.img bs=4096
	# etc
	dd if=/dev/mtdblock4 of=mtdblock4.img bs=4096
	# userconfig
	dd if=/dev/mtdblock5 of=mtdblock5.img bs=4096

	nvram_utility list > list.nvr
	nvram_get -f UserRelated UserRelated.nvr
	nvram_get -f UserRelated_UID UserRelated_UID.nvr
	nvram_get -f UserRelated_SSID UserRelated_SSID.nvr
	nvram_get -f NetRelated NetRelated.nvr
	nvram_get -f NetRelated_IP NetRelated_IP.nvr
	nvram_get -f NetRelated_MAC NetRelated_MAC.nvr
}

status() {
	set -x
	date
	uname -a
	cat /proc/cpuinfo
	cat /proc/meminfo
	cat /proc/version
	ps
	mount
	ifconfig
	lsmod
	ls -lR /bin /dev /etc /lib /mnt /root /sbin /tmp /usr /var
	set +x
}

# tz <TZ>
# e.g. tz "AEST-10"
tz() {
	echo "$1" > /etc/TZ
	ntpd -q -n -p time.google.com
}

stopvendor() {
	killall -9 test_UP iCamera
	for i in 1 2 3; do
		sleep 1
		if lsmod | grep snx_wdt; then
			modprobe -r snx_wdt
		else
			break
		fi
	done
}

# autorun [PREFIX]
autorun() {
	if [ -n "$SSID" ]; then
		setssid "$SSID" "$PSK"
		startwpa
		startudhcpc
	fi
	if [ -n "$STATUS_FILE" ]; then
		status >> "$1/$STATUS_FILE" 2>&1
	fi
	if [ -n "$SNAPSHOT_DIR" ]; then
		snapshot "$1/$SNAPSHOT_DIR"
	fi
	if [ "$START_TELNETD" = "1" ]; then
		starttelnetd
	fi
	if [ "$START_SERVICES" = "1" ]; then
		"$1/start.sh"
	fi
}

case "$1" in
"")
	# autorun - requires $MDEV (e.g. "mmcblk0p1")
	if [ -n "$MDEV" ]; then
		autorun "/media/$MDEV"
	fi
	;;
*)
	CMD="$1"
	shift
	"$CMD" "$@"
	;;
esac
