ENTRY(_start)

/*
 * AM335x On-Chip SRAM
 * 0x402F0000 – 0x402FFFFF (64 KB)
 * Reserve lower area for ROM
 */
MEMORY
{
    OCM (rwx) : ORIGIN = 0x402F1000, LENGTH = 48K
}

/* ---------------- Stack symbols ---------------- */
__stack_top__    = ORIGIN(OCM) + LENGTH(OCM);
__stack_bottom__ = __stack_top__ - 8K;

SECTIONS
{
    . = ORIGIN(OCM);

    /* ---------------- Vector table ---------------- */
    .vectors : {
        . = ALIGN(32);
        __vectors_start__ = .;
        KEEP(*(.vectors))
        __vectors_end__ = .;
    } > OCM

    /* ---------------- Code & RO data ---------------- */
    .text : {
        . = ALIGN(4);
        *(.text*)
        *(.rodata*)
    } > OCM

    /* ---------------- Initialized data ---------------- */
    .data : {
        . = ALIGN(4);
        __data_start__ = .;
        *(.data*)
        __data_end__ = .;
    } > OCM

    /* ---------------- BSS ---------------- */
    .bss (NOLOAD) : {
        . = ALIGN(8);
        __bss_start__ = .;
        *(.bss*)
        *(COMMON)
        __bss_end__ = .;
    } > OCM

    /* ---------------- Heap ---------------- */
    .heap (NOLOAD) : {
        . = ALIGN(8);
        __heap_start__ = .;
        . = . + 4K;
        __heap_end__ = .;
    } > OCM

    __image_end__ = .;
}
