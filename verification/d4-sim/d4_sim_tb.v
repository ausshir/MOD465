`ifndef _D4_SIM_V_
`define _D4_SIM_V_

`timescale 1ns/1ps

`include "../../exams/deliverable4/simulation/modelsim/d4_top.vo"

module d4_sim_tb();

initial begin
    $sdf_annotate("../../exams/deliverable4/simulation/modelsim/d4_top_v.sdo", d4_sim_tb.sut);
end

// Clock Generation @ 10ns/50MHz
reg clk_tb;
initial begin: CLK_GEN
    clk_tb = 0;
    forever begin
        #10000 clk_tb = ~clk_tb;
    end
end

// Reset Generation @ 500ns
reg reset;
initial begin: SYS_RESET
    reset = 0;
    #500000 reset = 1;
    #100000 reset = 0;
end

wire sam_clk;
wire sym_clk;

d4_top sut(.clock_50(clk_tb), .KEY({~reset, 1'b0, 1'b0, 1'b0}), .sam_clk(sam_clk), .sym_clk(sym_clk));

endmodule
`endif
