#!/bin/sh
# Usage: ./speaker.sh <STATE>
# STATE: 1 (On) or 0 (Off)
gpio_ms1 -n 7 -m 1 -v $1
gpio_aud write 1 4 $1
