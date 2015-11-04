#!/bin/sh

name="rpm-bundle"
orig_name="rpm"
version="4.12.0.1"

tarball="${orig_name}-${version}.tar.bz2"
url="http://rpm.org/releases/rpm-4.12.x/$tarball"

startdir="$(pwd)"
workdir="$(mktemp -d)"

trap "{ cd \"$startdir\"; rm -rf \"$workdir\"; }" EXIT

cd "$workdir"

wget -O "$tarball" "$url" || exit 1
tar -xf "$tarball" || exit 1
mv "${orig_name}-${version}" "${name}-${version}" || exit 1

cd "${name}-${version}"

ln -s "$startdir/debian" . || exit 1
# FIXME: find out why every odd build fails
dpkg-buildpackage -b -uc -us || exit 1

cp "../${name}_${version}"*.deb "$startdir/repo" || exit 1
