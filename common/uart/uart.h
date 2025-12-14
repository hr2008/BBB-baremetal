#pragma once
#include <stdint.h>


#define UART_THR          0x00  /* Transmit Holding */
#define UART_LSR          0x14  /* Line Status */
#define UART_LSR_THRE     (1 << 5)

void uart_init(void);
void uart_putc(char c);
void uart_puts(const char *s);
void uart_puts_raw(const char *s);


