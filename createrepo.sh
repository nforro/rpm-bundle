#!/bin/sh

target_dir="$(pwd)/repo"
gpg_key_id="133F16C2"

apt-ftparchive packages "$target_dir" > "$target_dir/Packages" || exit 1
gzip --to-stdout -9 "$target_dir/Packages" > "$target_dir/Packages.gz" || exit 1

apt-ftparchive -o 'Release::Codename="precise"' \
               -o 'Release::Components="main"' \
               -o 'Release::Architectures="i386 amd64"' \
               release "$target_dir" > "$target_dir/Release" || exit 1

rm --force "$target_dir/Release.gpg"
gpg --armor --detach-sign --default-key $gpg_key_id \
    --output "$target_dir/Release.gpg" --sign "$target_dir/Release" || exit 1
