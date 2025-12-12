CROSS   = arm-none-eabi
CC      = $(CROSS)-gcc
LD      = $(CROSS)-ld
OBJCOPY = $(CROSS)-objcopy

CFLAGS  = -mcpu=cortex-a8 -marm -O2 -nostdlib -nostartfiles -ffreestanding

all: blink_uart.bin

crt0.o: crt0.S
	$(CC) $(CFLAGS) -c $< -o $@

main.o: main.c
	$(CC) $(CFLAGS) -c $< -o $@

blink.elf: crt0.o main.o linker.ld
	$(LD) -T linker.ld crt0.o main.o -o $@

blink.bin: blink.elf
	$(OBJCOPY) -O binary $< $@

# UART boot header:
# offset 0: 0x00000000
# offset 4: image size
uart_header.bin: blink.bin
	printf "\x00\x00\x00\x00" > uart_header.bin
	image_size=$$(stat -c%s blink.bin); \
	printf "$$(printf '\\\\x%02x\\\\x%02x\\\\x%02x\\\\x%02x' \
	             $$((image_size & 0xff)) \
	             $$(((image_size>>8) & 0xff)) \
	             $$(((image_size>>16) & 0xff)) \
	             $$(((image_size>>24) & 0xff)) )" >> uart_header.bin

blink_uart.bin: blink.bin uart_header.bin
	cat uart_header.bin blink.bin > blink_uart.bin

clean:
	rm -f *.o *.elf *.bin
