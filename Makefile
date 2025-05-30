# SPDX-License-Identifier: MIT
#
# Copyright (c) 2025-2025 Spencer J Coward
#
# Spencer J. Coward <spencerjcoward@gmail.com>
#

# Compiler and tools
CC = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy
OBJDUMP = arm-none-eabi-objdump

# Project name
TARGET = firmware

# Source files
SRC = start.c main.c

# Include directories
INCLUDES = -I./include

# Compiler flags
CFLAGS = -g -mcpu=cortex-m0plus -mthumb -nostartfiles -Wall $(INCLUDES)

# SJC no crt0
# CFLAGS += -nostartfiles

# Linker script
LINKER_SCRIPT = mspm0c1104.ld

# Output files
ELF = $(TARGET).elf
BIN = $(TARGET).bin
HEX = $(TARGET).hex
MAP = $(TARGET).map

# Build rules
all: $(ELF)

bin: $(BIN) $(ELF)

hex: $(HEX) $(ELF)


$(ELF): $(SRC)
	$(CC) $(CFLAGS) -T $(LINKER_SCRIPT) -o $@ $^ -Wl,-Map=$(MAP) -lc
# $(CC) $(CFLAGS) -T $(LINKER_SCRIPT) -o $@ $^ -Wl,-Map=$(MAP)

$(BIN): $(ELF)
	$(OBJCOPY) -O binary $< $@

$(HEX): $(ELF)
	$(OBJCOPY) -O ihex $< $@

clean:
	rm -f $(ELF) $(BIN) $(HEX) $(MAP)

.PHONY: all clean bin hex