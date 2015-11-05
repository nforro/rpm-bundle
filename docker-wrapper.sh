#!/bin/sh

workdir="$(pwd)"
srcdir="/mnt/src"
repodir="$workdir/repo"

image="local:ubuntu_precise_deps"

gpg_key_id="133F16C2"

# enable docker access to files in working dir
chcon -Rt svirt_sandbox_file_t "$workdir"

# run docker image in temporary container
sudo docker run --rm -v "$workdir:$srcdir" "$image" \
    /bin/sh "$srcdir/build.sh" || exit 1

# reset ownership
sudo chown "$(id -u):$(id -g)" "$repodir/"*

# sign repository
gpg -a -b --default-key "$gpg_key_id" -o "$repodir/Release.gpg" \
    -s "$repodir/Release" || exit 1
