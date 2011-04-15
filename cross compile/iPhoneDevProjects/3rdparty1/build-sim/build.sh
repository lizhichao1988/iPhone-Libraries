#!/bin/bash

set -e

if [ -z $PROJECT_ROOT ]; then
    echo "PROJECT_ROOT is nil"
    exit
fi


pwd=$PWD

cd openssl-0.9.8o
../config-sim-openssl-0.9.8o.sh
make install

cd ..

cd libssh2-1.2.7
../config-sim-libssh2-1.2.7.sh
make install
