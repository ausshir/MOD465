(*keep*) wire signed [17:0] inphase_out, quadrature_out;

`ifdef CHANNEL_BLACKBOX
// MER Device from Lab Preamble
//     Note1: that there are two devices and they have the same module name
//        Make sure to remove the unused one from the project when compiling
//     Note2: Active low reset
MER_device bbx_mer_A(.clk(sys_clk),
                     .reset(~aux_reset),
                     .sym_en(sym_clk_ena),
                     .sam_en(sam_clk_ena),
                     .I_in(signal_inphase),
                     .Q_in(signal_quadrature),
                     .I_out(inphase_out),
                     .Q_out(quadrature_out));
`endif




`ifdef CHANNEL_MODEL
wire signed [17:0] mer_device_error_inphase, mer_device_clean_inphase;
wire signed [17:0] mer_device_error_quadrature, mer_device_clean_quadrature;
DUT_for_MER_measurement mer_device(.clk(sys_clk),
                                   .clk_en(sym_clk_ena),
                                   .reset(~aux_reset),
                                   .in_data(signal_inphase),
                                   .decision_variable(inphase_out),
                                   .errorless_decision_variable(mer_device_clean_inphase),
                                   .error(mer_device_error_inphase));

wire signed [17:0] mer_device_error, mer_device_clean;
DUT_for_MER_measurement mer_device(.clk(sys_clk),
                                  .clk_en(sym_clk_ena),
                                  .reset(~aux_reset),
                                  .in_data(signal_quadrature),
                                  .decision_variable(quadrature_out),
                                  .errorless_decision_variable(mer_device_clean_quadrature),
                                  .error(mer_device_error_quadrature));
`endif


`ifdef CHANNEL_GOLD

(*keep*) wire signed [17:0] channel_inphase, channel_quadrature;
srrc_gold_tx_flt tx_flt_inphase(.clk(sys_clk), .fastclk(clock_50), .sam_clk_en(sam_clk_ena), .sym_clk_en(sym_clk_ena), .reset(reset), .in(signal_inphase), .out(channel_inphase));
//srrc_gold_rx_flt rx_flt_inphase(.clk(sys_clk), .fastclk(clock_50), .sam_clk_en(sam_clk_ena), .sym_clk_en(sym_clk_ena), .reset(reset), .in(channel_inphase), .out(inphase_out));
assign inphase_out = channel_inphase;

//srrc_gold_tx_flt tx_flt_quadrature(.clk(sys_clk), .fastclk(clock_50), .sam_clk_en(sam_clk_ena), .sym_clk_en(sym_clk_ena), .reset(reset), .in(signal_quadrature), .out(channel_quadrature));
//srrc_gold_rx_flt rx_flt_quadrature(.clk(sys_clk), .fastclk(clock_50), .sam_clk_en(sam_clk_ena), .sym_clk_en(sym_clk_ena), .reset(reset), .in(channel_quadrature), .out(quadrature_out));
assign channel_quadrature = signal_quadrature;
assign quadrature_out = channel_quadrature;

`endif


`ifdef CHANNEL_NONE
assign inphase_out = signal_inphase;
assign quadrature_out = signal_quadrature;
`endif
