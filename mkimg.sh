#!/bin/sh

set -ex
env

RELEASE=13.2-RELEASE
ARCH=amd64
SOURCES_URL="$1"

mkdir /w

tar -C / -xf /sources/base.txz

tar -xvf /sources/mfsbsd.txz -C /w

cd /w/mfsbsd-*

[ -z ]
fetch -o conf/authorized_keys "https://github.com/$GITHUB_USER.keys"

(
    cd tools/roothack
    make depend && make
)
make BASE=/sources RELEASE="$RELEASE" PERMIT_ROOT_LOGIN=without-password ROOTHACK=1

mv "mfsbsd-$RELEASE-$ARCH.img" /mfsbsd.img

echo 'Done :3'
