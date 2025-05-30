// SPDX-License-Identifier: MIT
/*
 *  Copyright (c) 2025-2025 Spencer J Coward
 *
 *  Spencer J. Coward <spencerjcoward@gmail.com>
 */

extern int main(void);
extern void __libc_init_array(void);

// Symbols defined by the linker script
extern unsigned int _stack;
extern unsigned int _idata;
extern unsigned int _data;
extern unsigned int _edata;
extern unsigned int __bss_start__;
extern unsigned int __bss_end__;

// Global (and static local) variables initialized to non-zero value
static void copy_data(void)
{
    unsigned int *src_data_ptr = &_idata;
    unsigned int *dst_data_ptr = &_data;
    while (dst_data_ptr < &_edata)
    {
        *dst_data_ptr++ = *src_data_ptr++;
    }
}

static void clear_bss(void)
{
    unsigned int *bss_ptr = &__bss_start__;
    while (bss_ptr < &__bss_end__)
    {
        *bss_ptr++ = 0;
    }
}

// needed stub
void _init(void) {}

void isr_reset(void)
{
    copy_data();
    clear_bss();
    __libc_init_array();
    main();

    // If main returns, we should loop forever.
    while (1)
        ;
}


// This is a hardfault handler. It will currently just loop forever.
void isr_hardfault(void)
{
    while (1)
        ;
}

#define IVT_SIZE (48U)
typedef void (*isr_t)(void);
__attribute((used, section(".ivt"))) static const isr_t interrupt_vector_table[IVT_SIZE] =
    {
        (isr_t)&_stack,
        isr_reset,
        0, // isr_nmi
        isr_hardfault,
};