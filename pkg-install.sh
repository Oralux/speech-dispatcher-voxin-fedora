#!/bin/bash -x

cd "$(dirname "$0")"

PN=speech-dispatcher-voxin
ARCH=$(uname -m)
PKG=$(ls build.$ARCH/$PN-*.$ARCH.rpm)

if [ "$(id -u)" != "0" ]; then
    echo "install.sh must be run as root"
    exit 1
fi

if [ ! -e "$PKG" ]; then
    echo "PKG=$PKG not found"
    exit 1
fi

dnf reinstall -y "$PKG"

