#include <stdint.h>
#include "uart.h"
void printf(const char *fmt, ...);

int main(void)
{
uart_init();
while (1) {
    uart_putc('U');
    for (volatile int i = 0; i < 1000000; i++);
    uart_puts_raw("Hello\n");
}
}
