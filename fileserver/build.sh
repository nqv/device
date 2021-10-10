#!/bin/sh
TARGET=fileserver

mkdir -p $TARGET
GOOS=linux GOARCH=arm GOARM=7 go build
cp webdav $TARGET

if ! file "$TARGET/filebrowser" | grep ARM > /dev/null; then
	if [ ! -f linux-armv7-filebrowser.tar.gz ]; then
		curl -L -O https://github.com/filebrowser/filebrowser/releases/download/v2.17.2/linux-armv7-filebrowser.tar.gz
	fi
	tar xf linux-armv7-filebrowser.tar.gz -C "$TARGET" filebrowser
fi

cp README.md config.xml menu.json start.sh stop.sh "$TARGET"
zip -r "$TARGET.zip" "$TARGET"
