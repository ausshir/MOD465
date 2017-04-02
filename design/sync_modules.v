`ifndef _SYNC_MODULES_V_
`define _SYNC_MODULES_V_

`ifndef _DEFINES_VH
    `include "defines.vh"
`endif

module sync_modules(input sys_clk,
                    input sam_clk_en,
                    input sym_clk_en,
                    input reset,
                    input signed [17:0] rx_in,
                    output signed [17:0] rx_sync,
                    input signed [17:0] tx_in,
                    output signed [17:0] tx_delay,
                    input [1:0] data_in,
                    output [1:0] data_delay);

    config_sam_delay config_sam_del_tb(.clk(sys_clk),
                                       .sam_clk_en(sam_clk_en),
                                       .sym_clk_en(sym_clk_en),
                                       .reset(reset),
                                       .delay(2'd2), // For gold standard delay=2
                                       .in(rx_in),
                                       .out(rx_sync));

    config_sym_delay config_sym_del_tb(.clk(sys_clk),
                                      .sam_clk_en(sam_clk_en),
                                      .sym_clk_en(sym_clk_en),
                                      .reset(reset),
                                      .delay(8'd38), // For gold standard delay=38
                                      .in(tx_in),
                                      .out(tx_delay));

    config_data_delay config_data_del_tb(.clk(sys_clk),
                                         .sam_clk_en(sam_clk_en),
                                         .sym_clk_en(sym_clk_en),
                                         .reset(reset),
                                         .delay(8'd38),
                                         .in(data_in),
                                         .out(data_delay));

endmodule
`endif
