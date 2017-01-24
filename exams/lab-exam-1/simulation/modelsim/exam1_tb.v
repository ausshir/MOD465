`ifndef _IMPUSE_TB_V_
`define _IMPULSE_TB_V_

`timescale 10ns/1ns
//`include "../../design/srrc_tx_flt.v"

module exam1_tb();

    // Clock Generation @ 20ns/50MHz
    reg clk_tb;
    initial begin: CLK_GEN
        clk_tb = 0;
        forever begin
            #10 clk_tb = ~clk_tb;
        end
    end

    // Reset Generation @ 500ns
    reg reset;
    initial begin: SYS_RESET
        reset = 0;
        #500 reset = 1;
        #100 reset = 0;
    end

    // Instantiate SUT
    lab_exam_1 sut(.clock_50(clk_tb), .KEY({1'b0, 1'b0, 1'b0, reset}));

endmodule
`endif
