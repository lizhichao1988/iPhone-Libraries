#!/bin/bash
if [ -z $PROJECT_ROOT ]; then
    echo "PROJECT_ROOT is nil"
    exit
fi

pwd=$PWD

tar -xzf openssl-0.9.8o.tar.gz  -C $PROJECT_ROOT/build-sim
tar -xzf libssh2-1.2.7.tar.gz -C $PROJECT_ROOT/build-sim


cd $pwd

tar -xzf openssl-0.9.8o.tar.gz  -C $PROJECT_ROOT/build-os
tar -xzf libssh2-1.2.7.tar.gz -C $PROJECT_ROOT/build-os

cp patch/ui_openssl.c ${PROJECT_ROOT}/build-os/openssl-0.9.8o/crypto/ui/

