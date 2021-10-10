#!/bin/sh
if command -v fbink &> /dev/null; then
	USE_FBINK=1
fi

msg() {
	if [ "$USE_FBINK" = "1" ]; then
		fbink -qpm -y -3 "$@"
	else
		echo "$@"
	fi
}

case "$1" in
	webdav)
		PID="$(pidof webdav)"
		;;
	filebrowser)
		PID="$(pidof filebrowser)"
		;;
esac

if [ -z "$PID" ]; then
	msg "Process not running"
else
	kill $PID
	msg "Terminated $PID"
fi