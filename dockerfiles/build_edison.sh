#!/bin/bash
if [ ! -d "/source" ]; then
    echo no source dir /source
    exit 1
fi

if [ $# -gt 0 ]; then
    set cmakefile=$1
elif [ ! -f "/source/CMakeLists.txt" ]; then
    echo no /source/CMakeLists.txt
    exit 1
else
    set cmakefile=.
fi

if [ -f "/source/build.log" ]; then
    rm "/source/build.log"
fi

cd /source && cmake -DCMAKE_TOOLCHAIN_FILE=/home/toolchain-edison.cmake -DcompileOption_C:STRING="--sysroot=$EDISON_ROOT" -Dazure_IoT_Sdk_c=/azure-iot-sdk-c  . >> ./build.log 2>&1 
make >> ./build.log 2>&1

if [ $? -eq 0 ]; then
    echo source code build succeeded!
else
    exit $?
fi