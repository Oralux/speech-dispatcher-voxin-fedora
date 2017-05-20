#!/bin/bash -x
cd "$(dirname "$0")"

PN=speech-dispatcher
PN1=speech-dispatcher-voxin
unset PV

PV=$(rpm -q speech-dispatcher | sed -r 's/speech-dispatcher-([^-]*).*/\1/')

LIST="wget fedpkg rpmlint"
rpm -q $LIST &> /dev/null    
if [ "$?" != "0" ]; then
    echo "Install the following packages: $LIST"
    exit 1
fi

download()
{
    dnf download --source $PN
    rpm -ivh $PN-*.src.rpm
    dnf builddep $PN
}

function build_pkg() {
    local PN=$1
    local BUILD_DIR=build/$PN-$PV
    rm -rf $BUILD_DIR
    mkdir -p $BUILD_DIR

    cp ~/rpmbuild/SOURCES/speech-dispatcher* ~/rpmbuild/SOURCES/sound-icons* fedora/* $BUILD_DIR
    
    pushd $BUILD_DIR
    fedpkg --release f25 local
    find . -name "$PN*rpm" | while read i; do echo "--> $i"; rpmlint $i; done
    popd
}

[ ! -d build ] && mkdir build
cd build
download
cd ..

ARCH=$(uname -m)
rm -rf build.$ARCH
mkdir -p build.$ARCH
build_pkg $PN1
cp build/$PN1-$PV/$ARCH/$PN1*rpm build.$ARCH
