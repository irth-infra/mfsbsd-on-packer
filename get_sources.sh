#!/usr/bin/env bash

set -e

RELEASE=13.2-RELEASE
ARCH=amd64

DIR="./sources"
mkdir -p "$DIR"

URLS=(
    mfsbsd.txz=https://github.com/irth/mfsbsd/archive/c18de10874f5bee792ebbc7a0ef5c38ffb042000.zip
    kernel.txz=https://download.freebsd.org/releases/$ARCH/$RELEASE/kernel.txz
    base.txz=https://download.freebsd.org/releases/$ARCH/$RELEASE/base.txz
)

SHA256SUMS=(
    bb6b99b81179ecf98852cc24839d06758e34909648574072d76a2633da25c1e9
    e2d30b7236c47789bda6dc0753b14b9d40cdce1adf05e2dfae31d1a2eeaaee5c
    3a9250f7afd730bbe274691859756948b3c57a99bcda30d65d46ae30025906f0
)

i=0
for url in "${URLS[@]}"; do
    IFS="=" read -r name url <<<"$url"
    sum="${SHA256SUMS[$i]}  $DIR/$name"
    i=$((i + 1))

    if [ -f "$DIR/$name" ]; then
        if sha256sum -c <<<"$sum"; then
            sha256sum "$DIR/$name"
            continue
        else
            rm "$DIR/$name"
        fi
    fi

    echo "$DIR/$name: FETCH"
    curl -L "$url" -o "$DIR/$name"

    # verify checksum
    sha256sum -c <<<"$sum" || {
        sha256sum "$DIR/$name"
        exit 1
    }
    echo
done
