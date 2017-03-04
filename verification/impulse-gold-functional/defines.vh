`ifndef _DEFINES_VH
`define _DEFINES_VH

    `define SYMBOL_P1  18'sd 24576 //0.1875 with 131071 max +FS
    `define SYMBOL_P2  18'sd 8192 //0.0625
    `define SYMBOL_N1 -18'sd 8192 //-0.0625
    `define SYMBOL_N2 -18'sd 24576 //-0.1875 with -131072 max -FS


    `define SYMBOL_P1_FACTOR 0.5
    `define SYMBOL_P2_FACTOR 0.167
    `define SYMBOL_N1_FACTOR -0.166
    `define SYMBOL_N2_FACTOR -0.5

    `define LFSR_SEED 1
    `define LFSR_LEN 16'd22

    `define INPHASE 1:0
    `define QUADRATURE 3:2

    `define REF_POWER 18'sd 81919 //1.25 in 1s17 (0.625 of FS 131071)
    `define SYM_DELAY 5

    //`define QUICK_COMPILE

`endif
