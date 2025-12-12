    .section .vectors, "ax"
    .global _start
_start:
    b reset

    .text
reset:
    /* Disable watchdog */
    ldr r0, =0x44E35048        /* WDT_WSPR */
    ldr r1, =0xAAAA
    str r1, [r0]
    ldr r1, =0x5555
    str r1, [r0]

    /* Clear BSS */
    ldr r0, =__bss_start__
    ldr r1, =__bss_end__
zero_bss:
    cmp r0, r1
    bge bss_done
    mov r2, #0
    str r2, [r0], #4
    b zero_bss
bss_done:

    /* Jump to C main */
    bl main

hang:
    b hang
