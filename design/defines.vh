`ifndef _DEFINES_V
`define _DEFINES_V

    parameter SYMBOL_P1 = 18'sd 49151; //0.375 with 131071 max +FS
    parameter SYMBOL_P2 = 18'sd 16383; //0.125
    parameter SYMBOL_N1 =-18'sd 16384; //-0.125
    parameter SYMBOL_N2 =-18'sd 49151; //-0.375 with -131072 max -FS

`endif
