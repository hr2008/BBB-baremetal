# -------------------------------------------------
# Toolchain
# -------------------------------------------------
CROSS   = arm-none-eabi
CC      = $(CROSS)-gcc
LD      = $(CROSS)-ld
OBJCOPY = $(CROSS)-objcopy

# -------------------------------------------------
# Target
# -------------------------------------------------
TARGET  = blink_uart

# -------------------------------------------------
# Flags
# -------------------------------------------------
CFLAGS  = -mcpu=cortex-a8 -marm -O2 \
          -ffreestanding -nostdlib -nostartfiles

LDFLAGS = -T linker.ld

# -------------------------------------------------
# Source discovery (recursive)
# -------------------------------------------------
C_SRCS := $(shell find . -name '*.c')
S_SRCS := $(shell find . -name '*.s')
OBJS   := $(C_SRCS:.c=.o) $(S_SRCS:.s=.o)

# -------------------------------------------------
# Auto include directories
#   - finds all directories that contain header files
# -------------------------------------------------
INC_DIRS := $(sort $(dir $(shell find . -name '*.h')))
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

# -------------------------------------------------
# Default target
# -------------------------------------------------
all: clean $(TARGET).bin

# -------------------------------------------------
# Compile rules
# -------------------------------------------------
%.o: %.c
	$(CC) $(CFLAGS) $(INC_FLAGS) -c $< -o $@

%.o: %.s
	$(CC) $(CFLAGS) $(INC_FLAGS) -c $< -o $@

# -------------------------------------------------
# Link
# -------------------------------------------------
$(TARGET).elf: $(OBJS) linker.ld
	$(LD) $(LDFLAGS) $(OBJS) -o $@

# -------------------------------------------------
# ELF -> raw binary
# -------------------------------------------------
$(TARGET).raw: $(TARGET).elf
	$(OBJCOPY) -O binary $< $@

# -------------------------------------------------
# UART ROM header
# -------------------------------------------------
uart_header.bin: $(TARGET).raw
	@printf "\x00\x00\x00\x00" > $@
	@image_size=$$(stat -c%s $(TARGET).raw); \
	printf "$$(printf '\\\\x%02x\\\\x%02x\\\\x%02x\\\\x%02x' \
	             $$((image_size & 0xff)) \
	             $$(((image_size >> 8) & 0xff)) \
	             $$(((image_size >> 16) & 0xff)) \
	             $$(((image_size >> 24) & 0xff)) )" >> $@

# -------------------------------------------------
# Final UART boot image
# -------------------------------------------------
$(TARGET).bin: uart_header.bin $(TARGET).raw
	cat uart_header.bin $(TARGET).raw > $@

# -------------------------------------------------
# Cleanup
# -------------------------------------------------
clean:
	rm -f $(OBJS) *.elf *.raw *.bin uart_header.bin

.PHONY: all clean
