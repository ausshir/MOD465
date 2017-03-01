/**************************************************************************/
//
// INPHASE MAPPING AND CALCULATIONS
//
/**************************************************************************/

// Reference level generation for calibrating slicing
//      Needed due to unknown channel attenuation
(*keep*) wire signed [17:0] ref_level_inphase, avg_power_inphase;
(*noprune*) reg signed [17:0] ref_level_reg_inphase;
(*noprune*) reg signed [17:0] avg_power_out_inphase;
ref_level_gen ref_level_gen_mod_inphase(.clk(sys_clk),
                                .clk_en(sym_clk_ena),
                                .reset(reset),
                                .hold(lfsr_cycle_out_periodic),
                                .clear(lfsr_cycle_out_periodic_behind),
                                .dec_var(inphase_out),
                                .ref_level(ref_level_inphase),
                                .avg_power(avg_power_inphase));

always @(posedge sys_clk)
    avg_power_out_inphase = avg_power_inphase;

always @(posedge sys_clk)
    ref_level_reg_inphase = ref_level_inphase;


// 4-ASK Slicer to collect only the inphase stream
(*keep*) wire [1:0] data_stream_out_inphase;
slicer_4_ask slicer_4_ask_mod_inphase(.clk(sys_clk),
                              .clk_en(sym_clk_ena),
                              .in_phs_sig(inphase_out),
                              .ref_level(ref_level_inphase),
                              .sym_out(data_stream_out_inphase));

// Signal Verification Modules
// Re-Mapper to 4-ASK on inphase using reference level in order to compare results
(*keep*) wire signed [17:0] inphase_out_mapped;
(*noprune*) reg signed [17:0] inphase_out_del;
(*keep*) wire signed [17:0] diff_err_inphase;
(*keep*) wire signed [17:0] SYMBOL_P2_ref_inphase, SYMBOL_P1_ref_inphase, SYMBOL_N1_ref_inphase, SYMBOL_N2_ref_inphase;
(*noprune*) reg signed [17:0] SYMBOL_P2_reg_inphase, SYMBOL_P1_reg_inphase, SYMBOL_N1_reg_inphase, SYMBOL_N2_reg_inphase;
mapper_4_ask_ref mapper_4_ask_mod_inphase(.clk(sys_clk),
                                .clk_en(sym_clk_ena),
                                .data(data_stream_out_inphase),
                                .ref_level(ref_level_inphase),
                                .in_phs_sig(inphase_out_mapped),
                                .SYMBOL_P2(SYMBOL_P2_ref_inphase),
                                .SYMBOL_P1(SYMBOL_P1_ref_inphase),
                                .SYMBOL_N1(SYMBOL_N1_ref_inphase),
                                .SYMBOL_N2(SYMBOL_N2_ref_inphase));

always @(posedge sys_clk) begin
    SYMBOL_P2_reg_inphase <= SYMBOL_P2_ref_inphase;
    SYMBOL_P1_reg_inphase <= SYMBOL_P1_ref_inphase;
    SYMBOL_N1_reg_inphase <= SYMBOL_N1_ref_inphase;
    SYMBOL_N2_reg_inphase <= SYMBOL_N2_ref_inphase;
end


// Calculation of error (note that the mapper introduces 1 clock of delay)
always @(posedge sys_clk)
    inphase_out_del = inphase_out;
assign diff_err_inphase = inphase_out_del - inphase_out_mapped;

// Squared and DC error calculation for MER
(*keep*) wire [17:0] acc_sq_err_out_inphase;
(*keep*) wire [`LFSR_LEN + 17:0] acc_out_full_sq_inphase;
(*noprune*) reg [17:0] acc_sq_err_out_reg_inphase;
(*noprune*) reg [`LFSR_LEN + 17:0] acc_out_reg_full_sq_inphase;
err_sq_gen err_sq_gen_mod_inphase(.clk(sys_clk),
                          .clk_en(sym_clk_ena),
                          .reset(reset),
                          .hold(lfsr_cycle_out_periodic),
                          .err(diff_err_inphase),
                          .acc_sq_err_out(acc_sq_err_out_inphase),
                          .acc_out_full(acc_out_full_sq_inphase));

(*keep*) wire [17:0] acc_dc_err_out_inphase;
(*keep*) wire [`LFSR_LEN + 17:0] acc_out_full_dc_inphase;
(*noprune*) reg [17:0] acc_dc_err_out_reg_inphase;
(*noprune*) reg [`LFSR_LEN + 17:0] acc_out_reg_full_dc_inphase;
err_dc_gen err_dc_gen_mod_inphase(.clk(sys_clk),
                          .clk_en(sym_clk_ena),
                          .reset(reset),
                          .hold(lfsr_cycle_out_periodic),
                          .err(diff_err_inphase),
                          .acc_dc_err_out(acc_dc_err_out_inphase),
                          .acc_out_full(acc_out_full_dc_inphase));


always @(posedge sys_clk) begin
    acc_sq_err_out_reg_inphase <= acc_sq_err_out_inphase;
    acc_dc_err_out_reg_inphase <= acc_dc_err_out_inphase;
	 acc_out_reg_full_sq_inphase <= acc_out_full_sq_inphase;
    acc_out_reg_full_dc_inphase <= acc_out_full_dc_inphase;
end

reg [`INPHASE] sym_delay_1_inphase, sym_delay_2_inphase, sym_delay_3_inphase;
always @(posedge sys_clk)
    if(sym_clk_ena)
        sym_delay_1_inphase = data_stream_in[`INPHASE];

always @(posedge sys_clk)
    if(sym_clk_ena)
        sym_delay_2_inphase = sym_delay_1_inphase;

always @(posedge sys_clk)
    if(sym_clk_ena)
        sym_delay_3_inphase = sym_delay_2_inphase;

(*noprune*) reg sym_correct_inphase;
always @(posedge sys_clk) begin
    if(sym_clk_ena)
        sym_correct_inphase <= data_stream_out_inphase == sym_delay_3_inphase;
end

always @* begin
    LEDG[7] <= sym_correct_inphase;
end

(*keep*) wire signed [6:0] approx_mer_inphase;
(*noprune*) reg signed [6:0] approx_mer_reg_inphase;
mer_calc_lut mer_calc_inphase(.clk(sys_clk),
                              .clk_en(sym_clk_ena),
                              .reset(reset),
                              .mapper_power(avg_power_out_inphase),
                              .error_power(acc_sq_err_out_inphase),
                              .approx_mer(approx_mer_inphase));

always@(posedge sys_clk)
    approx_mer_reg_inphase = approx_mer_inphase;
