#!/bin/sh

srcdir="/mnt/src"
repodir="$srcdir/repo"
debiandir="$srcdir/debian"

upstream_name="rpm"
package="rpm-bundle"
version="4.12.0.1"
arch="amd64"

tarball="${upstream_name}-${version}.tar.bz2"
url="http://rpm.org/releases/rpm-4.12.x/$tarball"

# test if this script is running in container
if [ ! -f /.dockerenv ]; then
    echo "This script is intended to run in docker container!"
    exit 1
fi

# set non-interactive mode for debian tools
export DEBIAN_FRONTEND="noninteractive"

# download and unpack upstream tarball
wget -O "$tarball" "$url" || exit 1
tar -xf "$tarball" || exit 1
mv "${upstream_name}-${version}" "${package}-${version}" || exit 1

# copy debian directory
cp -r "$debiandir" "${package}-${version}/debian" || exit 1

# install build dependencies
sed -i 's/archive\.ubuntu\.com/cz.archive.ubuntu.com/' \
    /etc/apt/sources.list || exit 1
apt-get update || exit 1
mk-build-deps -i -t 'apt-get -y --no-install-recommends' \
    "${package}-${version}/debian/control" || exit 1

cd "${package}-${version}"

# build package
dpkg-buildpackage -b -uc -us || exit 1

# get rid of any existing deb files
rm -f "$repodir/"*.deb

# copy package to repo
cp "../${package}_${version}-1_${arch}.deb" "$repodir" || exit 1

cd "$repodir"

# generate Packages file
apt-ftparchive packages . > Packages || exit 1
gzip -c -9 Packages > Packages.gz || exit 1

# generate Release file
apt-ftparchive -o 'APT::FTPArchive::Release::Codename="precise"' \
               -o 'APT::FTPArchive::Release::Components="main"' \
               -o 'APT::FTPArchive::Release::Architectures="i386 amd64"' \
               release . > Release || exit 1

# remove invalid signature
rm -f Release.gpg
