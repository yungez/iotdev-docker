#!/bin/bash
if [ ! -d "/source" ]; then
    echo no source dir /source
    exit 1
fi

if [ -f "/source/build.log" ]; then
    rm "/source/build.log"
fi

srcfile=`ls /source/*.ino`
srccppfile=$(basename "$srcfile")
if [ "$srcfile" == "" ]; then
    echo No source .ino file found.
    return -1
fi

# generate output folder for output objects/binaries
if [ ! -d "/source/output" ]; then
    mkdir /source/output
fi

# step 0, generate temp cpp file
srccppfile=/source/output/$srccppfile.cpp
if [ -f "$srccppfile" ]; then
    rm -f $srccppfile
fi

echo \#include \<Arduino.h\> >> $srccppfile; cat $srcfile >> $srccppfile

# step 1, build source file
CXX=`echo ${CXX}`
CFLAGS=`echo ${CFLAGS}`
#echo cflags is $CFLAGS
obj=$srccppfile.o

$CXX -o $obj -c $srccppfile -fno-rtti -fno-exceptions -std=gnu++11 -fno-threadsafe-statics -g -Os -ffunction-sections -fdata-sections -Wall -mthumb -mcpu=cortex-m0plus -nostdlib --param max-inline-insns-single=500 -DF_CPU=48000000L -DUSBCON -DPLATFORMIO=30201 -DARDUINO_SAMD_FEATHER_M0 -DARDUINO_ARCH_SAMD -D__SAMD21G18A__ -DARDUINO=10608 -DUSB_VID=0x239A -DUSB_PID=0x800B  -I/framework-arduinosam/cores/adafruit_feather_m0 -I/framework-arduinosam/system/CMSIS/CMSIS/Include -I/framework-arduinosam/system/libsam -I/framework-arduinosam/system/libsam/include -I/framework-arduinosam/system/CMSIS/Device/ATMEL -I/framework-arduinosam/system/CMSIS/Device/ATMEL/d21g18a/include -I/framework-arduinosam/variants/adafruit_feather_m0 "-DUSB_PRODUCT=\"Adafruit Feather M0\"" -DUSB_MANUFACTURER=\"Adafruit\" >> /source/build.log

# step 2, link
$CXX -o /source/output/firmware.elf -Os -Wl,--gc-sections,--relax -mthumb -mcpu=cortex-m0plus -Wl,--check-sections -Wl,--unresolved-symbols=report-all -Wl,--warn-common -Wl,--warn-section-align --specs=nosys.specs --specs=nano.specs -Wl,-T"flash_with_bootloader.ld" $obj -L/ldscripts -L/framework-arduinosam/variants/adafruit_feather_m0/linker_scripts/gcc -L/libs -Wl,--start-group /libs/libFrameworkArduinoVariant.a /libs/libFrameworkArduino.a -lc -lgcc -lm -Wl,--end-group >> /source/build.log

if [ $? -eq 0 ]; then
    echo Build succeeded!
else
	echo build failed, pls check log file /source/build.log for more detail
    exit $?
fi