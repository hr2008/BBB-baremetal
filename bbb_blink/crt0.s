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

    /* Set stack pointer to top of SRAM */
    ldr sp, =__stack_top__

    /* Copy .data section */
    ldr r0, =__data_load__    /* source */
    ldr r1, =__data_start__   /* destination */
    ldr r2, =__data_end__     /* end */
copy_data:
    cmp r1, r2
    bge data_done
    ldr r3, [r0], #4
    str r3, [r1], #4
    b copy_data
data_done:


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
