
# list of source files
SRCS =  \
  Source/main.c \
  Source/stm32f0_discovery.c \
  Source/stm32f0xx_it.c \
  Source/system_stm32f0xx.c \
  startup/startup_stm32f0xx.S \
  Source/FreeRTOS/Source/croutine.c \
  Source/FreeRTOS/Source/event_groups.c \
  Source/FreeRTOS/Source/list.c \
  Source/FreeRTOS/Source/queue.c \
  Source/FreeRTOS/Source/tasks.c \
  Source/FreeRTOS/Source/timers.c \
  Source/FreeRTOS/Source/portable/GCC/ARM_CM0/port.c \
  Source/FreeRTOS/Source/portable/MemMang/heap_1.c

# target binary name
TARGET_NAME = main

# Location of the STM32F0xx Standard Peripheral Library
STM_LIB=Source/Library

# Location of the linker scripts
LDSCRIPT_INC=startup

CC=arm-none-eabi-gcc
OBJCOPY=arm-none-eabi-objcopy
OBJDUMP=arm-none-eabi-objdump
SIZE=arm-none-eabi-size

CFLAGS  = -Wall -g -std=c99 -Os
CFLAGS += -mlittle-endian -mcpu=cortex-m0  -march=armv6-m -mthumb
CFLAGS += -ffunction-sections -fdata-sections
CFLAGS += -Wl,--gc-sections -Wl,-Map=$(TARGET_NAME).map
CFLAGS += -DUSE_STDPERIPH_DRIVER

vpath %.a $(STM_LIB)

ROOT=$(shell pwd)

CFLAGS += -I Source \
	  -I $(STM_LIB)/CMSIS/Device/ST/STM32F0xx/Include \
	  -I $(STM_LIB)/CMSIS/Include \
	  -I $(STM_LIB)/STM32F0xx_StdPeriph_Driver/inc \
	  -I Source/FreeRTOS/Source/include \
	  -I Source/FreeRTOS/Source/portable/GCC/ARM_CM0

OBJS = $(SRCS:.c=.o)

.PHONY: lib proj

all: lib proj

lib:
	$(MAKE) -C $(STM_LIB)

proj: 	$(TARGET_NAME).elf

$(TARGET_NAME).elf: $(SRCS)
	$(CC) $(CFLAGS) $^ -o $@ -L$(STM_LIB) -lstm32f0 -L$(LDSCRIPT_INC) -Tstm32f0.ld
	$(OBJCOPY) -O ihex $(TARGET_NAME).elf $(TARGET_NAME).hex
	$(OBJCOPY) -O binary $(TARGET_NAME).elf $(TARGET_NAME).bin
	$(OBJDUMP) -St $(TARGET_NAME).elf >$(TARGET_NAME).lst
	$(SIZE) $(TARGET_NAME).elf
	
clean:
	find ./ -name '*~' | xargs rm -f	
	rm -f *.o
	rm -f $(TARGET_NAME).elf
	rm -f $(TARGET_NAME).hex
	rm -f $(TARGET_NAME).bin
	rm -f $(TARGET_NAME).map
	rm -f $(TARGET_NAME).lst

cleanlib: clean
	$(MAKE) -C $(STM_LIB) clean

