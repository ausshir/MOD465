`ifndef _CLK_TB_V_
`define _CLK_TB_V_

`timescale 1ns/1ns


`include "../../design/clk_gen.v"
`include "../../design/lfsr_gen_max.v"
`include "../../design/mapper_16_qam.v"
`include "../../design/err_dc_gen.v"
`include "../../design/err_sq_gen.v"
`include "defines.vh"

module error_tb();

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
    wire [17:0] ref_level;
    wire [17:0] avg_power;
    wire [`LFSR_LEN-1:0] lfsr_counter;
    wire cycle_out;
    wire cycle_out_periodic;
    wire signed [17:0] acc_dc_err_out, acc_sq_err_out;

    // Test the symbol synchronization
    reg [`INPHASE] sym_in_delay[`SYM_DELAY:0];
    wire [`INPHASE] sym_delayed;
    integer n;
    always @(posedge clk_25)
        if(clk_15625_en)
            sym_in_delay[0] = sym_out[1:0];

    always @(posedge clk_25)
        if(clk_15625_en) begin
            for(n=`SYM_DELAY; n>0; n=n-1) begin
                if(n==0)
                    sym_in_delay[0] <= sym_out[1:0];
                else
                    sym_in_delay[n] <= sym_in_delay[n-1];
            end
        end

    assign sym_delayed = sym_in_delay[`SYM_DELAY];

    // Instantiate SUT
    clk_gen sut(clk_tb, reset, clk_25, clk_625, clk_15625, clk_625_en, clk_15625_en, phase);
    lfsr_gen_max lfsr(clk_25, clk_15625_en, reset, seq_out, sym_out, cycle_out, cycle_out_periodic, lfsr_counter);
    mapper_16_qam mapper(clk_25, clk_15625_en, sym_out, in_phs_sig, quad_sig);

    err_dc_gen err_dc(clk_25,
                      clk_15625_en,
                      reset,
                      cycle_out_periodic,
                      in_phs_sig,
                      acc_dc_err_out);

    err_sq_gen err_sq(clk_25,
                      clk_15625_en,
                      reset,
                      cycle_out_periodic,
                      in_phs_sig,
                      acc_sq_err_out);




endmodule
`endif
