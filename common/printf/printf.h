#pragma once
#include <stdarg.h>
#include <stdint.h>
#include "uart.h"

void print_hex(uint32_t val);

void print_dec(int val);

void printf(const char *fmt, ...);