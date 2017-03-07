`ifndef _DEFINES_VH
`define _DEFINES_VH

    //`define SYMBOL_P1  18'sd 24576 //0.1875 with 131071 max +FS
    //`define SYMBOL_P2  18'sd 8192 //0.0625
    //`define SYMBOL_N1 -18'sd 8192 //-0.0625
    //`define SYMBOL_N2 -18'sd 24576 //-0.1875 with -131072 max -FS

    //`define SYMBOL_P1  18'sd 49151 //0.375 with 131071 max +FS
    //`define SYMBOL_P2  18'sd 16383 //0.125
    //`define SYMBOL_N1 -18'sd 16384 //-0.125
    //`define SYMBOL_N2 -18'sd 49151 //-0.375 with -131072 max -FS

    //`define SYMBOL_P1  18'sd 65536 //0.5 with 131071 max +FS
    //`define SYMBOL_P2  18'sd 21845 //0.167
    //`define SYMBOL_N1 -18'sd 21845 //-0.166
    //`define SYMBOL_N2 -18'sd 65536 //-0.5 with -131072 max -FS

    `define SYMBOL_P1  18'sd 131071 //1 with 131071 max +FS
    `define SYMBOL_P2  18'sd 43690 //0.33333
    `define SYMBOL_N1 -18'sd 43690 //-0.33333
    `define SYMBOL_N2 -18'sd 131071 //-1 with -131072 max -FS
    `define SYMBOL_REF 18'd87381

    `define LFSR_SEED 1
    `define LFSR_LEN 16'd9

    `define INPHASE 1:0
    `define QUADRATURE 3:2

    `define REF_POWER 18'sd 81919 //1.25 in 1s17 (0.625 of FS 131071)
    `define SYM_DELAY 5

    // Enable QUICK_COMPILE in order to diable compiling giant LUTs
    `define QUICK_COMPILE

    // Enable one of these to model the channel as desired
    //`define CHANNEL_BLACKBOX
    //`define CHANNEL_MODEL
    //`define CHANNEL_NONE
    `define CHANNEL_GOLD

`endif
