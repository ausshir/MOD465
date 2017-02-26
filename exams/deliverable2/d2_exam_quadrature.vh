/**************************************************************************/
//
// QUADRATURE MAPPING AND CALCULATIONS
//  NOTE: This file has been auto-generated from the other signal axes
//
/**************************************************************************/

// Reference level generation for calibrating slicing
//      Needed due to unknown channel attenuation
(*keep*) wire signed [17:0] ref_level_quadrature, avg_power_quadrature;
(*noprune*) reg [17:0] avg_power_out_quadrature;
ref_level_gen ref_level_gen_mod_quadrature(.clk(sys_clk),
                                .clk_en(sym_clk_ena),
                                .reset(reset),
                                .hold(lfsr_cycle_out_periodic),
                                .clear(lfsr_cycle_out_periodic_behind),
                                .dec_var(quadrature_out),
                                .ref_level(ref_level_quadrature),
                                .avg_power(avg_power_quadrature));

always @(posedge sys_clk)
    avg_power_out_quadrature = avg_power_quadrature;


// 4-ASK Slicer to collect only the quadrature stream
(*keep*) wire [1:0] data_stream_out_quadrature;
slicer_4_ask slicer_4_ask_mod_quadrature(.clk(sys_clk),
                              .clk_en(sym_clk_ena),
                              .in_phs_sig(quadrature_out),
                              .ref_level(ref_level_quadrature),
                              .sym_out(data_stream_out_quadrature));

// Signal Verification Modules
// Re-Mapper to 4-ASK on quadrature using reference level in order to compare results
(*keep*) wire signed [17:0] quadrature_out_mapped;
(*noprune*) reg signed [17:0] quadrature_out_del;
(*keep*) wire signed [17:0] diff_err_quadrature;
(*keep*) wire signed [17:0] SYMBOL_P2_ref_quadrature, SYMBOL_P1_ref_quadrature, SYMBOL_N1_ref_quadrature, SYMBOL_N2_ref_quadrature;
(*noprune*) reg signed [17:0] SYMBOL_P2_reg_quadrature, SYMBOL_P1_reg_quadrature, SYMBOL_N1_reg_quadrature, SYMBOL_N2_reg_quadrature;
mapper_4_ask_ref mapper_4_ask_mod_quadrature(.clk(sys_clk),
                                .clk_en(sym_clk_ena),
                                .data(data_stream_out_quadrature),
                                .ref_level(ref_level_quadrature),
                                .in_phs_sig(quadrature_out_mapped),
                                .SYMBOL_P2(SYMBOL_P2_ref_quadrature),
                                .SYMBOL_P1(SYMBOL_P1_ref_quadrature),
                                .SYMBOL_N1(SYMBOL_N1_ref_quadrature),
                                .SYMBOL_N2(SYMBOL_N2_ref_quadrature));

always @(posedge sys_clk) begin
    SYMBOL_P2_reg_quadrature <= SYMBOL_P2_ref_quadrature;
    SYMBOL_P1_reg_quadrature <= SYMBOL_P1_ref_quadrature;
    SYMBOL_N1_reg_quadrature <= SYMBOL_N1_ref_quadrature;
    SYMBOL_N2_reg_quadrature <= SYMBOL_N2_ref_quadrature;
end


// Calculation of error (note that the mapper introduces 1 clock of delay)
always @(posedge sys_clk)
    quadrature_out_del = quadrature_out;
assign diff_err_quadrature = quadrature_out_del - quadrature_out_mapped;

// Squared and DC error calculation for MER
(*keep*) wire [17:0] acc_sq_err_out_quadrature;
(*keep*) wire [`LFSR_LEN + 17:0] acc_out_full_sq_quadrature;
(*noprune*) reg [17:0] acc_sq_err_out_reg_quadrature;
(*noprune*) reg [`LFSR_LEN + 17:0] acc_out_reg_full_sq_quadrature;
err_sq_gen err_sq_gen_mod_quadrature(.clk(sys_clk),
                          .clk_en(sym_clk_ena),
                          .reset(reset),
                          .hold(lfsr_cycle_out_periodic),
                          .err(diff_err_quadrature),
                          .acc_sq_err_out(acc_sq_err_out_quadrature),
                          .acc_out_full(acc_out_full_sq_quadrature));

(*keep*) wire [17:0] acc_dc_err_out_quadrature;
(*keep*) wire [`LFSR_LEN + 17:0] acc_out_full_dc_quadrature;
(*noprune*) reg [17:0] acc_dc_err_out_reg_quadrature;
(*noprune*) reg [`LFSR_LEN + 17:0] acc_out_reg_full_dc_quadrature;
err_dc_gen err_dc_gen_mod_quadrature(.clk(sys_clk),
                          .clk_en(sym_clk_ena),
                          .reset(reset),
                          .hold(lfsr_cycle_out_periodic),
                          .err(diff_err_quadrature),
                          .acc_dc_err_out(acc_dc_err_out_quadrature),
                          .acc_out_full(acc_out_full_dc_quadrature));


always @(posedge sys_clk) begin
    acc_sq_err_out_reg_quadrature <= acc_sq_err_out_quadrature;
    acc_dc_err_out_reg_quadrature <= acc_dc_err_out_quadrature;
	 acc_out_reg_full_sq_quadrature <= acc_out_full_sq_quadrature;
    acc_out_reg_full_dc_quadrature <= acc_out_full_dc_quadrature;
end

reg [`QUADRATURE] sym_delay_1_quadrature, sym_delay_2_quadrature, sym_delay_3_quadrature;
always @(posedge sys_clk)
    if(sym_clk_ena)
        sym_delay_1_quadrature = data_stream_in[`QUADRATURE];

always @(posedge sys_clk)
    if(sym_clk_ena)
        sym_delay_2_quadrature = sym_delay_1_quadrature;

always @(posedge sys_clk)
    if(sym_clk_ena)
        sym_delay_3_quadrature = sym_delay_2_quadrature;

(*noprune*) reg sym_correct_quadrature;
always @(posedge sys_clk) begin
    if(sym_clk_ena)
        sym_correct_quadrature <= data_stream_out_quadrature == sym_delay_3_quadrature;
end

always @* begin
    LEDG[6] <= sym_correct_quadrature;
end

(*keep*) wire signed [6:0] approx_mer_quadrature;
(*noprune*) reg signed [6:0] approx_mer_reg_quadrature;
mer_calc_lut mer_calc_quadrature(.clk(sys_clk),
                              .clk_en(sym_clk_ena),
                              .reset(reset),
                              .mapper_power(avg_power_out_quadrature),
                              .error_power(acc_sq_err_out_quadrature),
                              .approx_mer(approx_mer_quadrature));

always@(posedge sys_clk)
    approx_mer_reg_quadrature = approx_mer_quadrature;
