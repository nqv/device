#!/bin/sh
EXTDIR=/mnt/us/extensions/fileserver

if command -v fbink > /dev/null; then
	USE_FBINK=1
fi

msg() {
	if [ "$USE_FBINK" = "1" ]; then
		fbink -qpm -y -3 "$@"
	else
		echo "$@"
	fi
}

fw() {
	if iptables -C INPUT -p tcp --dport "$1" -j ACCEPT 2> /dev/null; then
		iptables -I INPUT -p tcp --dport "$1" -j ACCEPT
	fi
}

IP="$(ifconfig | grep inet | tail -1 | cut -d ':' -f 2 | cut -d ' ' -f 1)"
case "$1" in
	webdav)
		PID="$(pidof webdav)"
		if [ -n "$PID" ]; then
			msg "webdav is already running"
			exit 0
		fi
		fw 8080
		"$EXTDIR/webdav" -addr ":8080" -root /mnt/us >> "$EXTDIR/log.txt" 2>&1 &
		msg "http://$IP:8080/webdav/"
		;;
	filebrowser)
		PID="$(pidof filebrowser)"
		if [ -n "$PID" ]; then
			msg "filebrowser is already running"
			exit 0
		fi
		fw 8081
		"$EXTDIR/filebrowser" -a "0.0.0.0" -p 8081 -r /mnt/us >> "$EXTDIR/log.txt" 2>&1 &
		msg "http://$IP:8081/"
		;;
esac
