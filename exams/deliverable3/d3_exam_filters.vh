(*keep*) wire signed [17:0] out_inphase, out_quadrature;
(*noprune*) reg signed [17:0] signal_inphase_scaled, signal_quadrature_scaled;


always @*
    case(SW[17:14])
        4'b0001 : signal_inphase_scaled = {signal_inphase[17], signal_inphase[17:1]};
        4'b0010 : signal_inphase_scaled = {signal_inphase[17], signal_inphase[17], signal_inphase[17:2]};
        4'b0100 : signal_inphase_scaled = {signal_inphase[17], signal_inphase[17], signal_inphase[17], signal_inphase[17:3]};
        4'b1000 : signal_inphase_scaled = {signal_inphase[17], signal_inphase[17], signal_inphase[17], signal_inphase[17], signal_inphase[17:4]};
        default : signal_inphase_scaled = signal_inphase;
    endcase

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
                     .I_out(out_inphase),
                     .Q_out(out_quadrature));
`endif

`ifdef CHANNEL_MODEL
wire signed [17:0] mer_device_error_inphase, mer_device_clean_inphase;
wire signed [17:0] mer_device_error_quadrature, mer_device_clean_quadrature;
DUT_for_MER_measurement mer_device(.clk(sys_clk),
                                   .clk_en(sym_clk_ena),
                                   .reset(~aux_reset),
                                   .in_data(signal_inphase),
                                   .decision_variable(out_inphase),
                                   .errorless_decision_variable(mer_device_clean_inphase),
                                   .error(mer_device_error_inphase));

wire signed [17:0] mer_device_error, mer_device_clean;
DUT_for_MER_measurement mer_device(.clk(sys_clk),
                                  .clk_en(sym_clk_ena),
                                  .reset(~aux_reset),
                                  .in_data(signal_quadrature),
                                  .decision_variable(out_quadrature),
                                  .errorless_decision_variable(mer_device_clean_quadrature),
                                  .error(mer_device_error_quadrature));
`endif

`ifdef CHANNEL_GOLD
(*keep*) wire signed [17:0] channel_inphase_gold, channel_quadrature_gold;
(*keep*) wire signed [17:0] channel_inphase_prac, channel_quadrature_prac;
(*noprune*) reg signed [17:0] channel_inphase, channel_quadrature;

srrc_gold_rx_flt tx_flt_inphase_gold(.clk(sys_clk),
                                     .fastclk(clock_50),
                                     .sam_clk_en(sam_clk_ena),
                                     .sym_clk_en(sym_clk_ena),
                                     .reset(reset),
                                     .in(signal_inphase_scaled),
                                     .out(channel_inphase_gold)
                                     /*.phase4(clk_phase[3:2]),*/);

srrc_prac_mult_tx_flt tx_flt_inphase_prac(.clk(sys_clk),
                                          .fastclk(clock_50),
                                          .sam_clk_en(sam_clk_ena),
                                          .sym_clk_en(sym_clk_ena),
                                          .reset(reset),
                                          .in(signal_inphase_scaled),
                                          .out(channel_inphase_prac));

always @*
    case(SW[13:12])
        2'b01 : channel_inphase = channel_inphase_prac;
        default : channel_inphase = channel_inphase_gold;
    endcase

srrc_gold_rx_flt rx_flt_inphase(.clk(sys_clk),
                                .fastclk(clock_50),
                                .sam_clk_en(sam_clk_ena),
                                .sym_clk_en(sym_clk_ena),
                                .reset(reset),
                                .in(channel_inphase),
                                .out(out_inphase));

//assign out_inphase = channel_inphase;

//srrc_gold_tx_flt tx_flt_quadrature(.clk(sys_clk), .fastclk(clock_50), .sam_clk_en(sam_clk_ena), .sym_clk_en(sym_clk_ena), .reset(reset), .in(signal_quadrature), .out(channel_quadrature));
//srrc_gold_rx_flt rx_flt_quadrature(.clk(sys_clk), .fastclk(clock_50), .sam_clk_en(sam_clk_ena), .sym_clk_en(sym_clk_ena), .reset(reset), .in(channel_quadrature), .out(out_quadrature));
always @*
    channel_quadrature = 0;//signal_quadrature;
assign out_quadrature = 0;//channel_quadrature;
`endif


`ifdef CHANNEL_NONE
assign out_inphase = signal_inphase;
assign out_quadrature = signal_quadrature;
`endif
