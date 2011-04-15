#!/bin/bash

#
# xiewei.max@gmail.com
# Build successfully on Mac OS X 10.6.2
#
# Build timing:
# real	3m44.253s
# user	1m56.865s
# sys	1m11.921s

 

set -e

pwd=$PWD

source ./env.sh

cd pkg
./unzip.sh

cd $pwd
cd build-sim
source ./env.sh
./build.sh

cd $pwd
cd build-os
source ./env.sh
./build.sh

cd $pwd
cd script
./build-iphone-lipo-archive.sh

echo "completed!"


