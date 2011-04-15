#!/bin/sh
echo "Hello World"



#安装测试单元
ghName="GHUnit.framework"
RootFrameworksPath="/Library/Frameworks/"
UserFrameworksPath="~/Library/Frameworks/"

echo $ghName

#ghFrameworkPath = 

# 判断用户目录Framerowks是否存在
#if [-d "/"];then
#print "frameworks in user dir not exists"
#fi
#
#if [ -d "$UserFrameworksPath"]; then 
#print "frameworks in user dir  exists"
#fi

if [ -a "$RootFrameworksPath" ]; then
echo "Hellow"
fi
