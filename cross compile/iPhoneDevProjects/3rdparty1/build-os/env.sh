#!/bin/bash

if [ -z $PROJECT_ROOT ]; then
    echo "PROJECT_ROOT is nil"
    exit
fi

export prefix=$PROJECT_ROOT/iphone-os
export dev_root=/Developer/Platforms/iPhoneOS.platform/Developer
export sdk_root="${dev_root}/SDKs/iPhoneOS4.1.sdk"

export CC=$dev_root/usr/bin/gcc
export LD=$dev_root/usr/bin/ld
export CPP=$dev_root/usr/bin/cpp
export CXX=$dev_root/usr/bin/g++
unset AR
unset AS
export NM=$dev_root/usr/bin/nm
export CXXCPP=$dev_root/usr/bin/cpp
export RANLIB=$dev_root/usr/bin/ranlib


export CFLAGS="-arch armv6 -pipe -no-cpp-precomp -isysroot $sdk_root -I$prefix/include -I$sdk_root/usr/inclue"
export CXXFLAGS=$CFLAGS
#export LDFLAGS="$CFLAGS -L$prefix/lib"
export LDFLAGS="$CFLAGS -L$prefix/lib -L$sdk_root/usr/lib"

export host=arm-apple-darwin9


