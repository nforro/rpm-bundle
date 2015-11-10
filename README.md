# rpm-bundle

This repository contains scripts and files needed to build rpm-bundle package
for Ubuntu Precise running inside Travis CI environment.
The package itself bundles all rpm binaries and libraries, and includes
source code of python modules ready to be compiled by pip inside virtualenv
for specific python version.
The scripts also create Debian repository metadata so the package can be
installed by apt-get.

## Files and directories:

- **debian/**:
    directory that is copied inside package build directory and contains
    the instructions to execute to construct the package
- **docker/build.sh**:
    script to be run inside docker that builds the package and generates
    repository metadata
- **docker/Dockerfile**:
    dockerfile that is used to generate base docker image 
- **repo/**:
    directory that contains results of the build and gpg public key,
    this is the actual debian repository
- **travis/install-dependencies.sh**:
    script to be run inside Travis CI environment that installs the package
    and builds python modules
- **travis/test.py**:
    python test script that tries to import the rpm module
- **make.sh**:
    script that does it all, it builds the repository in docker container
    and signs its metadata
