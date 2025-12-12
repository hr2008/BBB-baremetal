ENTRY(_start)

MEMORY
{
    OCM (rwx) : ORIGIN = 0x402F0400, LENGTH = 64K
}

SECTIONS
{
    . = ORIGIN(OCM);

    /* Code + rodata */
    .text : {
        KEEP(*(.vectors))
        *(.text*)
        *(.rodata*)
    } > OCM


    /* Initialized data */
    .data : {
        __data_start__ = .;
        *(.data*)
        __data_end__ = .;
    } > OCM AT > OCM

    /* Load address for .data (same as VMA here, but explicit) */
    __data_load__ = LOADADDR(.data);

    /* BSS */
    .bss (NOLOAD) : {
        __bss_start__ = .;
        *(.bss*)
        *(COMMON)
        __bss_end__ = .;
    } > OCM

    /* Stack */
    .stack (NOLOAD) : {
        __stack_bottom__ = .;
        . = . + 8K;
        __stack_top__ = .;
    } > OCM
}
