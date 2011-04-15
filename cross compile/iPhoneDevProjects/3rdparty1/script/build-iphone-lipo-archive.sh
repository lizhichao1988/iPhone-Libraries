#!/bin/bash

if [ -z $PROJECT_ROOT ]; then
    echo "PROJECT_ROOT is nil"
    exit
fi

LIB_LIPO=${PROJECT_ROOT}/iphone
LIB_OS=${PROJECT_ROOT}/iphone-os/lib
LIB_SIM=${PROJECT_ROOT}/iphone-sim/lib
DEVROOT=/Developer/Platforms/iPhoneOS.platform/Developer

cd $LIB_SIM
find . -name "*.a" -print > $LIB_LIPO/lib.sim

cd $LIB_OS
find . -name "*.a" -print > $LIB_LIPO/lib.os

cd $LIB_LIPO
sort lib.* | awk '{if ($0 == prev) print $0; prev=$0}' > lib.iphone

mkdir -p lib

for l in `cat lib.iphone`; do
  baseDir=`dirname $l`
  if [ ! $baseDir = "." ] ; then
    if [ ! -d lib/test ] ; then
      echo "Need to create directory $LIB_LIPO/lib/$baseDir"
      mkdir -p $LIB_LIPO/lib/$baseDir 2> /dev/null
    fi
  fi

  echo "Lipo on $l"
  $DEVROOT/usr/bin/lipo -arch arm $LIB_OS/$l -arch i386 $LIB_SIM/$l -create -output lib/$l
done

rm -f $LIB_LIPO/lib.*

