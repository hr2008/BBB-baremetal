#include <stdint.h>

#define CM_PER_BASE     0x44E00000
#define CM_PER_GPIO1_CLKCTRL (CM_PER_BASE + 0xAC)

#define GPIO1_BASE      0x4804C000
#define GPIO_OE         (GPIO1_BASE + 0x134)
#define GPIO_SETDATAOUT (GPIO1_BASE + 0x194)
#define GPIO_CLEARDATAOUT (GPIO1_BASE + 0x190)

#define USR0_PIN        (1 << 21)
#define USR1_PIN        (1 << 22)
#define USR2_PIN        (1 << 23)
#define USR3_PIN        (1 << 24)

static unsigned delayVal = 1000000;

static void delay(volatile unsigned count) {
    while (count--) ;
}

int main(void)
{
    /* Enable GPIO1 clock */
    *(volatile uint32_t*)CM_PER_GPIO1_CLKCTRL = 0x2;
    while ((*(volatile uint32_t*)CM_PER_GPIO1_CLKCTRL & 0x3) != 0x2);

    /* Set all user leds as output */
    volatile uint32_t *oe = (volatile uint32_t*)GPIO_OE;
    *oe &= ~USR0_PIN;
    *oe &= ~USR1_PIN;
    *oe &= ~USR2_PIN;
    *oe &= ~USR3_PIN;

    while (1) {
        *(volatile uint32_t*)GPIO_SETDATAOUT = USR0_PIN;
        *(volatile uint32_t*)GPIO_SETDATAOUT = USR2_PIN;
        *(volatile uint32_t*)GPIO_CLEARDATAOUT = USR1_PIN;
        *(volatile uint32_t*)GPIO_CLEARDATAOUT = USR3_PIN;
        delay(delayVal);

        *(volatile uint32_t*)GPIO_SETDATAOUT = USR1_PIN;
        *(volatile uint32_t*)GPIO_SETDATAOUT = USR3_PIN;
        *(volatile uint32_t*)GPIO_CLEARDATAOUT = USR0_PIN;
        *(volatile uint32_t*)GPIO_CLEARDATAOUT = USR2_PIN;
        delay(delayVal);
    }
}

void default_handler()
{
    *(volatile uint32_t*)GPIO_SETDATAOUT = USR0_PIN;
    *(volatile uint32_t*)GPIO_SETDATAOUT = USR2_PIN;
    *(volatile uint32_t*)GPIO_SETDATAOUT = USR1_PIN;
    *(volatile uint32_t*)GPIO_SETDATAOUT = USR3_PIN;

}
