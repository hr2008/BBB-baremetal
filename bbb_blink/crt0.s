.syntax unified
.cpu cortex-a8
.global _start

/* --------------------------------------------------
 * Vector table
 * -------------------------------------------------- */
.section .vectors, "ax"
.align 5
_vectors_start:
_start:
    b reset              /* Reset */
    b .                  /* Undefined */
    b .                  /* SVC */
    b .                  /* Prefetch abort */
    b .                  /* Data abort */
    b .                  /* Reserved */
    b .                  /* IRQ */
    b .                  /* FIQ */

/* --------------------------------------------------
 * Reset handler
 * -------------------------------------------------- */
.section .text
reset:
    /* Enter SVC mode, disable IRQ & FIQ */
    cpsid if
    mrs r0, cpsr
    bic r0, r0, #0x1F
    orr r0, r0, #0x13     /* SVC mode */
    msr cpsr_c, r0

    /* Disable watchdog (AM335x requires polling) */
    ldr r0, =0x44E35048   /* WDT_WSPR */
    ldr r1, =0xAAAA
    str r1, [r0]
wdt_wait1:
    ldr r2, =0x44E35034   /* WDT_WWPS */
    ldr r3, [r2]
    tst r3, #0x10
    bne wdt_wait1

    ldr r1, =0x5555
    str r1, [r0]
wdt_wait2:
    ldr r3, [r2]
    tst r3, #0x10
    bne wdt_wait2

    /* Set stack pointer */
    ldr sp, =__stack_top__

    /* Zero BSS */
    ldr r0, =__bss_start__
    ldr r1, =__bss_end__
zero_bss:
    cmp r0, r1
    bge bss_done
    mov r2, #0
    str r2, [r0], #4
    b zero_bss
bss_done:

    /* Set vector base register */
    ldr r0, =_vectors_start
    mcr p15, 0, r0, c12, c0, 0   /* VBAR */
    isb

    /* Jump to C */
    bl main

hang:
    b hang
