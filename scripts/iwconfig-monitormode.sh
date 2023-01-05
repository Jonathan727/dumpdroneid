#!/bin/bash
# A script to set a wlan interface to monitor mode

export USE_IF_CONFIG=yes

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/monitormode.sh"