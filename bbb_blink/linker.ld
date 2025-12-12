ENTRY(_start)

MEMORY {
    SRAM (rwx) : ORIGIN = 0x402F0400, LENGTH = 64K
}

SECTIONS {
    .text : {
        KEEP(*(.vectors))
        *(.text*)
        *(.rodata*)
    } > SRAM

    .data : {
        *(.data*)
    } > SRAM

    .bss : {
        __bss_start__ = .;
        *(.bss*)
        *(COMMON)
        __bss_end__ = .;
    } > SRAM
}
