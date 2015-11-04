#!/bin/sh

gpg_key_id="133F16C2"

startdir="$(pwd)"
workdir="$startdir/repo"

trap "{ cd \"$startdir\"; }" EXIT

cd "$workdir"

apt-ftparchive packages . > Packages || exit 1
gzip --to-stdout -9 Packages > Packages.gz || exit 1

apt-ftparchive -o 'APT::FTPArchive::Release::Codename="precise"' \
               -o 'APT::FTPArchive::Release::Components="main"' \
               -o 'APT::FTPArchive::Release::Architectures="i386 amd64"' \
               release . > Release || exit 1

rm --force Release.gpg
gpg --armor --detach-sign --default-key $gpg_key_id \
    --output Release.gpg --sign Release || exit 1
