CC:=/gcc-arm-none-eabi-6_2-2016q4/bin/arm-none-eabi-gcc
CXX:=/gcc-arm-none-eabi-6_2-2016q4/bin/arm-none-eabi-g++
AR:=/gcc-arm-none-eabi-6_2-2016q4/bin/arm-none-eabi-ar

CFLAGS:=-fno-rtti -fno-exceptions -std=gnu++11 -fno-threadsafe-statics -g -Os -ffunction-sections -fdata-sections -Wall -mthumb -mcpu=cortex-m0plus -nostdlib --param max-inline-insns-single=500 -DF_CPU=48000000L -DUSBCON -DPLATFORMIO=30201 -DARDUINO_SAMD_FEATHER_M0 -DARDUINO_ARCH_SAMD -D__SAMD21G18A__ -DARDUINO=10608 -DUSB_VID=0x239A -DUSB_PID=0x800B  -I/framework-arduinosam/cores/adafruit_feather_m0 -I/framework-arduinosam/system/CMSIS/CMSIS/Include -I/framework-arduinosam/system/libsam -I/framework-arduinosam/system/libsam/include -I/framework-arduinosam/system/CMSIS/Device/ATMEL -I/framework-arduinosam/system/CMSIS/Device/ATMEL/d21g18a/include -I/framework-arduinosam/variants/adafruit_feather_m0 "-DUSB_PRODUCT=\"Adafruit Feather M0\"" -DUSB_MANUFACTURER=\"Adafruit\"
CXXFLAGS:=-fno-rtti -fno-exceptions -std=gnu++11 -fno-threadsafe-statics -g -Os -ffunction-sections -fdata-sections -Wall -mthumb -mcpu=cortex-m0plus -nostdlib --param max-inline-insns-single=500 -DF_CPU=48000000L -DUSBCON -DPLATFORMIO=30201 -DARDUINO_SAMD_FEATHER_M0 -DARDUINO_ARCH_SAMD -D__SAMD21G18A__ -DARDUINO=10608 -DUSB_VID=0x239A -DUSB_PID=0x800B	-I/framework-arduinosam/cores/adafruit_feather_m0 -I/framework-arduinosam/system/CMSIS/CMSIS/Include -I/framework-arduinosam/system/libsam -I/framework-arduinosam/system/libsam/include -I/framework-arduinosam/system/CMSIS/Device/ATMEL -I/framework-arduinosam/system/CMSIS/Device/ATMEL/d21g18a/include -I/framework-arduinosam/variants/adafruit_feather_m0 "-DUSB_PRODUCT=\"Adafruit Feather M0\"" -DUSB_MANUFACTURER=\"Adafruit\"

ODIR=/libs/FrameworkArduino
SDIR=/framework-arduinosam/cores/adafruit_feather_m0

CPPSRCS=$(wildcard $(SDIR)/*.cpp)
CSRCS=$(wildcard $(SDIR)/*.c)
CPPUSBSRCS=$(wildcard $(SDIR)/USB/*.cpp)
CUSBSRCS=$(wildcard $(SDIR)/USB/*.c)
CAVRSRCS=$(wildcard $(SDIR)/avr/*.c)

CPPSRCSOBJS=$(notdir $(CPPSRCS:%.cpp=%))
CSRCSOBJS=$(notdir $(CSRCS:%.c=%))
CPPUSBSRCSOBJS=$(notdir $(CPPUSBSRCS:%.cpp=%))
CUSBSRCSOBJS=$(notdir $(CUSBSRCS:%.c=%))
CAVRSRCSOBJS=$(notdir $(CAVRSRCS:%.c=%))

OBJS=$(wildcard $(ODIR)/*.o $(ODIR)/USB/*.o $(ODIR)/avr/*.o)

all: variant cpp c cppusb cusb cavr ar

variant:
	$(CXX) -o /libs/FrameworkArduinoVariant/variant.o -c /framework-arduinosam/variants/adafruit_feather_m0/variant.cpp $(CXXFLAGS)

cpp:
	for obj in $(CPPSRCSOBJS); do \
	echo build $$obj;				\
	$(CXX) -o $(ODIR)/$$obj.o -c $(SDIR)/$$obj.cpp $(CXXFLAGS); \
	done

c:
	for obj in $(CSRCSOBJS); do \
	echo build $$obj;				\
	$(CC) -o $(ODIR)/$$obj.o -c $(SDIR)/$$obj.c $(CFLAGS); \
	done

cppusb:
	for obj in $(CPPUSBSRCSOBJS); do \
	echo build $$obj;				\
	$(CXX) -o $(ODIR)/USB/$$obj.o -c $(SDIR)/USB/$$obj.cpp $(CXXFLAGS); \
	done

cusb:
	for obj in $(CUSBSRCSOBJS); do \
	echo build $$obj;				\
	$(CC) -o $(ODIR)/USB/$$obj.o -c $(SDIR)/USB/$$obj.c $(CFLAGS); \
	done

cavr:
	for obj in $(CAVRSRCSOBJS); do \
	echo build $$obj;				\
	$(CC) -o $(ODIR)/avr/$$obj.o -c $(SDIR)/avr/$$obj.c $(CFLAGS); \
	done

ar:
	$(AR) rcs /libs/libFrameworkArduinoVariant.a /libs/FrameworkArduinoVariant/variant.o
	$(AR) rcs /libs/libFrameworkArduino.a $(OBJS)

firmware:
	$(CC) -o /libs/firmware.elf	 -Os -Wl,--gc-sections,--relax -mthumb -mcpu=cortex-m0plus -Wl,--check-sections -Wl,--unresolved-symbols=report-all -Wl,--warn-common -Wl,--warn-section-align --specs=nosys.specs --specs=nano.specs -Wl,-T"flash_with_bootloader.ld" /home/app.ino.o -L/ldscripts -L/framework-arduinosam/variants/adafruit_feather_m0/linker_scripts/gcc -L/libs -Wl,--start-group /libs/libFrameworkArduinoVariant.a /libs/libFrameworkArduino.a -lc -lgcc -lm -Wl,--end-group


.PHONY: clean
clean:
	rm	$(ODIR)/*.o
	rm	$(ODIR)/USB/*.o
	rm	$(ODIR)/avr/*.o