#!/bin/bash

PKG=$1

PROJECT_ROOT=/Users/xw_max/Desktop/iPhoneDevProjects/3rdparty

cd ${PROJECT_ROOT}/pkg
echo "$PKG" >> pkg.lst
wget "$PKG"
cd -

