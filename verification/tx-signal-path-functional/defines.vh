`ifndef _DEFINES_VH
`define _DEFINES_VH

    `define SYMBOL_P1  18'sd 131071 //0.1875 with 131071 max +FS
    `define SYMBOL_P2  18'sd 43690 //0.0625
    `define SYMBOL_N1 -18'sd 43690 //-0.0625
    `define SYMBOL_N2 -18'sd 131071 //-0.1875 with -131072 max -FS

    `define LFSR_SEED 1
    `define LFSR_LEN 16'd5

    `define REF_POWER 18'sd 81919 //1.25 in 1s17 (0.625 of FS 131071)
    `define SYM_DELAY 4

`endif
