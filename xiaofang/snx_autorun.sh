#!/bin/sh
# WiFi
SID=""
PSK=""
# Status file
STA=""
# Backup directory
BAK=""

# setssid [SSID] [PASSWORD]
setssid() {
	cat > /tmp/wpa_supplicant.conf <<__EOF__
ctrl_interface=/var/run/wpa_supplicant
ctrl_interface_group=0
ap_scan=1

network={
	ssid="$1"
	psk="$2"
	key_mgmt=WPA-PSK
	pairwise=CCMP TKIP
	group=CCMP TKIP WEP104 WEP40
	scan_ssid="1"
	priority=2
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

printstatus() {
	date
	echo '# uname'
	uname -a
	echo '# cat /proc/cpuinfo'
	cat /proc/cpuinfo
	echo '# cat /proc/meminfo'
	cat /proc/meminfo
	echo '# cat /proc/version'
	cat /proc/version
	echo '# ps'
	ps
	echo '# mount'
	mount
	echo '# ifconfig'
	ifconfig
	echo '# lsmod'
	lsmod
	echo '# ls'
	ls -lR /bin /dev /etc /lib /mnt /root /sbin /tmp /usr /var
}

# tz <TZ>
# e.g. tz "AEST-10"
settz() {
	echo "$1" > /etc/TZ
	ntpd -q -n -p time.google.com
}

case "$1" in
	"snapshot")
		snapshot "$2"
		;;
	"ssid")
		setssid "$2" "$3"
		startwpa
		startudhcpc
		;;
	"status")
		printstatus
		;;
	"tz")
		settz "$2"
		;;
	"-h")
		echo "$0 <COMMAND>"
		exit 2
		;;
	*)
		# autorun - requires $MDEV (e.g. "mmcblk0p1")
		if [ -z "$MDEV" ]; then
			exit 1
		fi
		if [ ! -z "$SID" ]; then
			setssid "$SID" "$PSK"
			startwpa
			startudhcpc
		fi
		if [ ! -z "$STA" ]; then
			printstatus >> "/media/$MDEV/$STA"
		fi
		if [ ! -z "$BAK" ]; then
			backup "/media/$MDEV/$BAK"
		fi
		starttelnetd
		;;
esac
