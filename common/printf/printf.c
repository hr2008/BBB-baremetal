#include <stdarg.h>
#include <stdint.h>
#include "uart.h"

void print_hex(uint32_t val)
{
    char hex[] = "0123456789ABCDEF";
    for (int i = 28; i >= 0; i -= 4)
        uart_putc(hex[(val >> i) & 0xF]);
}

void print_dec(int val)
{
    char buf[12];
    int i = 0;

    if (val == 0) {
        uart_putc('0');
        return;
    }

    if (val < 0) {
        uart_putc('-');
        val = -val;
    }

    while (val) {
        buf[i++] = '0' + (val % 10);
        val /= 10;
    }

    while (i--)
        uart_putc(buf[i]);
}

void printf(const char *fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);

    while (*fmt) {
        if (*fmt != '%') {
            uart_putc(*fmt++);
            continue;
        }

        fmt++;
        switch (*fmt++) {
        case 's':
            uart_puts(va_arg(ap, char *));
            break;
        case 'c':
            uart_putc((char)va_arg(ap, int));
            break;
        case 'x':
            print_hex(va_arg(ap, uint32_t));
            break;
        case 'd':
            print_dec(va_arg(ap, int));
            break;
        default:
            uart_putc('?');
            break;
        }
    }

    va_end(ap);
}
