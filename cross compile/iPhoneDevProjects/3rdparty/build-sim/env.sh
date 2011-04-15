#!/bin/bash

if [ -z $PROJECT_ROOT ]; then
    echo "PROJECT_ROOT is nil"
    return 0
fi

export prefix=$PROJECT_ROOT/iphone-sim

#export simulator_sdk="/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator4.0.sdk"

#export CFLAGS="-arch i386 -I$prefix/include -I$simulator_sdk/usr/include"
#export LDFLAGS="$CFLAGS -L$prefix/lib -L$simulator_sdk/usr/lib"
#export CXXFLAGS="$CFLAGS"

export LANG=en_US.US-ASCII
export PATH="/Developer/Platforms/iPhoneSimulator.platform/Developer/usr/bin:/Developer/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin"


export host=i686-apple-darwin9

export dev_root=/Developer/Platforms/iPhoneSimulator.platform/Developer
export sdk_root="${dev_root}/SDKs/iPhoneSimulator4.1.sdk"

export CC=$dev_root/usr/bin/gcc
export LD=$dev_root/usr/bin/ld
export CPP=$dev_root/usr/bin/cpp
export CXX=$dev_root/usr/bin/g++
unset AR
unset AS
export NM=$dev_root/usr/bin/nm
export CXXCPP=$dev_root/usr/bin/cpp
export RANLIB=$dev_root/usr/bin/ranlib


export CFLAGS="-arch i386 -mmacosx-version-min=10.5 -I$prefix/include -isysroot $sdk_root"
export CXXFLAGS=$CFLAGS
#export LDFLAGS="$CFLAGS -L$prefix/lib"
export LDFLAGS="$CFLAGS -L$prefix/lib -L$sdk_root/usr/lib"


