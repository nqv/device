#!/bin/sh
cd "$(dirname $0)"
DIR="$(pwd)"
export PATH="$PATH:$DIR/bin"
export LD_LIBRARY_PATH="$DIR/bin"
for f in ./etc/init.d/*; do
	"$f" start
done
