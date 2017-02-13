`ifndef _CLK_TB_V_
`define _CLK_TB_V_

`timescale 1ns/1ns

`include "../../design/clk_gen.v"
`include "../../design/lfsr_22_max.v"
`include "../../design/mapper_16_qam.v"

module clk_tb();

    // Clock Generation @ 10ns/50MHz
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

    wire clk_25, clk_625, clk_15625, clk_625_en, clk_15625_en;
    wire [3:0] phase;

    wire [3:0] sym_out;
    wire [21:0] seq_out;
    wire [17:0] in_phs_sig;
    wire [17:0] quad_sig;

    // Instantiate SUT
    clk_gen sut(clk_tb, reset, clk_25, clk_625, clk_15625, clk_625_en, clk_15625_en, phase);
    lfsr_22_max lfsr(clk_25, clk_15625_en, reset, seq_out, sym_out);
    mapper_16_qam mapper(clk_25, clk_15625_en, sym_out, in_phs_sig, quad_sig);

endmodule
`endif
