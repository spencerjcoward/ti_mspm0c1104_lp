// SPDX-License-Identifier: MIT
/*
 *  Copyright (c) 2025-2025 Spencer J Coward
 *
 *  Spencer J. Coward <spencerjcoward@gmail.com>
 */

MEMORY
{
  flash (rx) : ORIGIN = 0x00000000, LENGTH = 16K
  ram (rwx) : ORIGIN = 0x20000000, LENGTH = 1K
}

_eram = ORIGIN(ram) + LENGTH(ram);
_stack = _eram; /* Stack starts at end of RAM and grows downwards */

SECTIONS
{
  .text : ALIGN(4)
  {
    KEEP(*(.ivt)) /* Interrupt vector table */
    *(.text*)
    . = ALIGN(4);
    _etext = .;
  } > flash

  .init_array : ALIGN(4)
  {
    __init_array_start = .;
    KEEP(*(.init_array*))
    __init_array_end = .;
    . = ALIGN(4);
  } > flash

  /* Initial (constant) values for data is placed in flash after the program code */
  _idata = LOADADDR(.data);

  .data : ALIGN(4)
  {
    _data = .;
    _la_data = .;
    *(.data*)
    . = ALIGN(4);
    _edata = .;
  } > ram AT > flash

  .bss : ALIGN(4)
  {
    __bss_start__ = .;
    *(.bss*)
    . = ALIGN(4);
    __bss_end__ = .;
    PROVIDE(_end = .);
  } > ram
}