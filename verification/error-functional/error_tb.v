`ifndef _CLK_TB_V_
`define _CLK_TB_V_

`timescale 1ns/1ns

`include "../../design/clk_gen.v"
`include "../../design/lfsr_gen_max.v"
`include "../../design/mapper_16_qam.v"
`include "../../design/err_dc_gen.v"
`include "../../design/err_sq_gen.v"
`include "../../design/ref_level_gen.v"
`include "../../reference-design/DUT_for_MER_measurement.v"
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
    wire cycle_out_periodic, cycle_out_periodic_ahead, cycle_out_periodic_behind;
    wire signed [17:0] acc_dc_err_out, acc_sq_err_out;

    // Instantiate SUT
    clk_gen sut(clk_tb, reset, clk_25, clk_625, clk_15625, clk_625_en, clk_15625_en, phase);
    lfsr_gen_max lfsr(clk_25, clk_15625_en, reset, seq_out, sym_out, cycle_out, cycle_out_periodic, cycle_out_periodic_ahead, cycle_out_periodic_behind, lfsr_counter);
    mapper_16_qam mapper(clk_25, clk_15625_en, sym_out, in_phs_sig, quad_sig);

    wire signed [17:0] mer_device_out, mer_device_error, mer_device_clean;
    wire signed [17+`LFSR_LEN:0] acc_out_full_dc, acc_out_full_sq;
    DUT_for_MER_measurement mer_device(.clk(clk_25),
                                       .clk_en(clk_15625_en),
                                       .reset(~reset),
                                       .in_data(in_phs_sig),
                                       .decision_variable(mer_device_out),
                                       .errorless_decision_variable(mer_device_clean),
                                       .error(mer_device_error));

    err_dc_gen err_dc(clk_25,
                      clk_15625_en,
                      reset,
                      cycle_out_periodic,
                      mer_device_error,
                      acc_dc_err_out,
                      acc_out_full_dc);

    err_sq_gen err_sq(clk_25,
                      clk_15625_en,
                      reset,
                      cycle_out_periodic,
                      mer_device_error,
                      acc_sq_err_out,
                      acc_out_full_sq);

    ref_level_gen ref_level_gen_mod(.clk(clk_25),
                                  .clk_en(clk_15625_en),
                                  .reset(reset),
                                  .hold(cycle_out_periodic),
                                  .clear(cycle_out_periodic_behind),
                                  .dec_var(mer_device_clean),
                                  .ref_level(ref_level),
                                  .avg_power(avg_power));





endmodule
`endif
