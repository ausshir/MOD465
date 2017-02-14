module d2_exam_top(input clock_50,
                   input [17:0] SW,
                   input [3:0] KEY,
                   input [13:0]ADC_DA,
                   input [13:0]ADC_DB,
                   output reg [7:0] LEDG,
                   output reg [17:0] LEDR,
                   output reg[13:0]DAC_DA,
                   output reg [13:0]DAC_DB,
                   output    ADC_CLK_A,
                   output    ADC_CLK_B,
                   output    ADC_OEB_A,
                   output    ADC_OEB_B,
                   output    DAC_CLK_A,
                   output    DAC_CLK_B,
                   output    DAC_MODE,
                   output    DAC_WRT_A,
                   output    DAC_WRT_B

                   // Outputs from internal data
                   );



    // LED Sanity Check
    always @ *
        LEDR = SW;

    always @ *
        LEDG[3:0] = KEY[3:0];

    // Reset Switch on KEY0
    wire reset;
    assign reset = ~KEY[0];

    // ADC and DAC Setup
    (* noprune *)reg [13:0] registered_ADC_A;
    (* noprune *)reg [13:0] registered_ADC_B;
    (* noprune *) reg signed [17:0] PRE_DAC;
    (* keep *) wire [13:0] DAC_OUT;


    assign DAC_CLK_A = sys_clk;
    assign DAC_CLK_B = sys_clk;
    assign DAC_MODE = 1'b1; //treat DACs seperately
    assign DAC_WRT_A = ~sys_clk;
    assign DAC_WRT_B = ~sys_clk;

    always@ (posedge sys_clk)// make DAC A echo ADC A
        DAC_DA = registered_ADC_A[13:0];

    always@ (posedge sys_clk)
        DAC_DB = DAC_OUT;

    assign ADC_CLK_A = sys_clk;
    assign ADC_CLK_B = sys_clk;

    assign ADC_OEB_A = 1'b1;
    assign ADC_OEB_B = 1'b1;

    always@ (posedge sys_clk)
        registered_ADC_A <= ADC_DA;

    always@ (posedge sys_clk)
        registered_ADC_B <= ADC_DB;


    // MER Device from Lab Preamble
    //     Note1: that there are two devices and they have the same module name
    //        Make sure to remove the unused one from the project when compiling
    //     Note2: Active low reset
    wire signed [17:0] inphase_out, quadrature_out;
    MER_device bbx_mer15(.clk(sys_clk),
                         .reset(~reset),
                         .sym_en(sym_clk_ena),
                         .sam_en(sam_clk_ena),
                         .I_in(inphase_in),
                         .Q_in(quadrature_in),
                         .I_out(inphase_out),
                         .Q_out(quadrature_out));

    // Clock Generator module
    //     Takes in the system clock and generates 1/2, 1/8, 1/32 clock periods
    //     Note1: the enables occur just before the clock edges to be clocked on sys_clk to help keep
    //          clock domains synchronized

    wire sys_clk, sam_clk, sym_clk;
    wire sam_clk_ena, sym_clk_ena;
    wire [3:0] clk_phase;
    clk_gen clk_gen_mod(.clk_in(clock_50),
                        .reset(reset),
                        .sys_clk(sys_clk),
                        .sam_clk(sam_clk),
                        .sym_clk(sym_clk),
                        .sam_clk_ena(sam_clk_ena),
                        .sym_clk_ena(sym_clk_ena),
                        .clk_phase(clk_phase));

    // 22-bit LFSR for generating random data to evaluate performance
    wire [3:0] data_stream_in;
	 wire [22:0] lfsr_sequence;
    lfsr_22_max lfsr_data_mod(.clk(sys_clk),
                              .clk_en(sym_clk_ena),
                              .reset(reset),
                              .seq_out(lfsr_sequence),
                              .sym_out(data_stream_in));

    // 16-QAM Mapper using parameters
    wire signed [17:0] inphase_in, quadrature_in;
    mapper_16_qam mapper_16_qam_mod(.clk(sys_clk),
                                    .clk_en(sym_clk_ena),
                                    .data(data_stream_in),
                                    .in_phs_sig(inphase_in),
                                    .quad_sig(quadrature_in));

    // Reference level generation for calibrating slicing
    //      Needed due to unknown channel attenuation
    wire signed [17:0] ref_level, avg_power;
    ref_level_gen ref_level_gen_mod(.clk(sys_clk),
                                    .clk_en(sym_clk_ena),
                                    .reset(reset),
                                    .dec_var(inphase_out),
                                    .ref_level(ref_level),
                                    .avg_power(avg_power));

    // 4-ASK Slicer to collect only the inphase stream
    wire [1:0] data_stream_out;
    slicer_4_ask slicer_4_ask_mod(.clk(sys_clk),
                                  .clk_en(sym_clk_ena),
                                  .in_phs_sig(inphase_out),
                                  .ref_level(ref_level),
                                  .sym_out(data_stream_out));



    // Signal Verification Modules
    // Re-Mapper to 4-ASK on inphase using reference level in order to compare results
    wire signed [17:0] inphase_out_mapped;
    wire signed [17:0] diff_err;
    mapper_4_ask_ref mapper_4_ask_mod(.clk(sys_clk),
                                    .clk_en(sym_clk_ena),
                                    .data(data_stream_out),
                                    .ref_level(ref_level),
                                    .in_phs_sig(inphase_out_mapped));

    assign diff_err = inphase_out - inphase_out_mapped;

    // Squared and DC error calculation for MER
    wire [38:0] acc_sq_err_out;
    err_sq_gen err_sq_gen_mod(.clk(sys_clk),
                              .clk_en(sym_clk_ena),
                              .reset(reset),
                              .err(diff_err),
                              .acc_sq_err_out(acc_sq_err_out));
    wire [17:0] dc_err;
    wire [38:0] acc_dc_err_out;
    err_dc_gen err_dc_gen_mod(.clk(sys_clk),
                              .clk_en(sym_clk_ena),
                              .reset(reset),
                              .err(diff_err),
                              .acc_dc_err_out(acc_dc_err_out));

    // Symbol error indicator
    //  Note1: The input symbol must be delayed by N clock cycles to synchronize
    //      Currently N=4;
    reg [3:0] sym_in_delay[`SYM_DELAY:0];
    integer n;
    always @(posedge sys_clk)
        sym_in_delay[0] = data_stream_in[1:0];

    always @(posedge sys_clk)
        for(n = 0; n < (`SYM_DELAY-1); n = n+1)
            sym_in_delay[n+1] = sym_in_delay[n];

    reg sym_correct, sym_error;
    always @(posedge sys_clk) begin
        sym_correct <= data_stream_out == sym_in_delay[3];
        sym_error   <= data_stream_out != sym_in_delay[3];
    end
	 
	 always @* begin
	     LEDG[7] = sym_correct;
	     LEDG[6] = sym_error;
    end







endmodule