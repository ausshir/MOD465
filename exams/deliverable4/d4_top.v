`include "../../design/defines.vh"

`include "../../design/clk_gen.v"
`include "../../design/lfsr_gen_max.v"
`include "../../design/mapper_16_qam_ref.v"
`include "../../design/upsampler_4.v"
`include "../../design/srrc_gold_rx_flt.v"
`include "../../design/srrc_prac_tx_flt.v"

`include "../../design/config_sam_delay.v"
`include "../../design/config_sym_delay.v"
`include "../../design/config_data_delay.v"
`include "../../design/downsampler_4.v"
`include "../../design/slicer_4_ask.v"
`include "../../design/ref_level_gen.v"
`include "../../design/mapper_4_ask_ref.v"

`include "../../design/err_sq_gen.v"
`include "../../design/err_dc_gen.v"

module d4_top(input clock_50,
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
                   output    DAC_WRT_B,

                   // Outputs from internal data for viewing
                   output sys_clk,
                   output sam_clk,
                   output sym_clk,
                   output sam_clk_en,
                   output sym_clk_en,
                   output [3:0] phase,

                   output reg signed [17:0] DAC_A_in, DAC_B_in,
                   output reg signed [17:0] tx_up_scaled_inphase);

    // System

    // LED Sanity Check
    always @*
        LEDR = SW;

    always @*
        LEDG[3:0] = KEY[3:0];
    always @*
        LEDG[5:4] = 2'b0;

    // Reset Switch on KEY0
    wire reset, aux_reset;
    assign reset = ~KEY[0];
    assign aux_reset = ~KEY[1];

    // ADC and DAC Setup
    reg [13:0] registered_ADC_A;
    reg [13:0] registered_ADC_B;
    //reg signed [17:0] DAC_A_in, DAC_B_in;

    assign DAC_CLK_A = sys_clk;
    assign DAC_CLK_B = sys_clk;
    assign DAC_MODE = 1'b1; //treat DACs seperately
    assign DAC_WRT_A = ~sys_clk;
    assign DAC_WRT_B = ~sys_clk;

    always @(posedge sys_clk)// convert 1s13 format to 0u14 format and send it to DAC A/B
        DAC_DA = {~DAC_A_in[17], DAC_A_in[16:4]};

    always@ (posedge sys_clk)
        DAC_DB = {~DAC_B_in[17], DAC_B_in[16:4]};

    always @*
        case(SW[4:0])
            5'b00001 : DAC_A_in = tx_chan_inphase;
            5'b00010 : DAC_A_in = tx_up_inphase;
            5'b00100 : DAC_A_in = tx_sig_inphase;
            default  : DAC_A_in = 0;
        endcase

    always @*
        DAC_B_in = DAC_A_in;

    assign ADC_CLK_A = sys_clk;
    assign ADC_CLK_B = sys_clk;

    assign ADC_OEB_A = 1'b1;
    assign ADC_OEB_B = 1'b1;

    always@ (posedge sys_clk)
        registered_ADC_A <= ADC_DA;

    always@ (posedge sys_clk)
        registered_ADC_B <= ADC_DB;

    // Defined as outputs
    // wire sys_clk, sam_clk, sym_clk, sam_clk_en, sym_clk_en;
    // wire [3:0] phase;
    clk_gen clocks(.clk_in(clock_50),
                      .reset(reset),
                      .sys_clk(sys_clk),
                      .sam_clk(sam_clk),
                      .sym_clk(sym_clk),
                      .sam_clk_ena(sam_clk_en),
                      .sym_clk_ena(sym_clk_en),
                      .clk_phase(phase));

    wire [3:0] tx_data;
    wire [21:0] seq_out;
    wire cycle_out_once, cycle_out_periodic, cycle_out_periodic_ahead, cycle_out_periodic_behind;
    wire [`LFSR_LEN-1:0] lfsr_counter;
    lfsr_gen_max lfsr(.clk(sys_clk),
                         .reset(reset),
                         .clk_en(sam_clk_en),
                         .seq_out(seq_out),
                         .sym_out(tx_data),
                         .cycle_out_once(cycle_out_once),
                         .cycle_out_periodic(cycle_out_periodic),
                         .cycle_out_periodic_ahead(cycle_out_periodic_ahead),
                         .cycle_out_periodic_behind(cycle_out_periodic_behind),
                         .lfsr_counter(lfsr_counter));

    // TX Modules
    wire signed [17:0] tx_sig_inphase, tx_sig_quadrature;
    mapper_16_qam_ref mapper_tx(.clk(sys_clk),
                                   .clk_en(sam_clk_en),
                                   .data(tx_data),
                                   .ref_level(`SYMBOL_REF),
                                   .sig_inph(tx_sig_inphase),
                                   .sig_quad(tx_sig_quadrature));

    wire signed [17:0] tx_up_inphase;
    upsampler_4 upsampler_tx(.clk(sys_clk),
                                .sam_clk_en(sam_clk_en),
                                .sym_clk_en(sym_clk_en),
                                .reset(reset),
                                .phase4(phase[3:2]),
                                .data_in(tx_sig_inphase),
                                .data_out(tx_up_inphase));

    // SIGNAL CHAIN - Matched Filters

    //reg [17:0] tx_up_scaled_inphase;
    always @*
        case(SW[17:16])
            2'b01: tx_up_scaled_inphase = {tx_up_inphase[17], tx_up_inphase[17:1]};
            2'b10: tx_up_scaled_inphase = {tx_up_inphase[17], tx_up_inphase[17], tx_up_inphase[17:2]};
            2'b11: tx_up_scaled_inphase = {tx_up_inphase[17],tx_up_inphase[17], tx_up_inphase[17], tx_up_inphase[17:3]};
            default: tx_up_scaled_inphase = {tx_up_inphase[17:0]};
        endcase

    wire signed [17:0] tx_chan_inphase;
    srrc_prac_tx_flt gold_tx(.clk(sys_clk),
                             .sam_clk_en(sam_clk_en),
                             .sym_clk_en(sym_clk_en),
                             .reset(reset),
                             .in(tx_up_scaled_inphase),
                             .out(tx_chan_inphase));

    /*
	 wire signed [17:0] rx_up_inphase;
    srrc_gold_rx_flt gold_rx(.clk(sys_clk),
                                .fastclk(clock_50),
                                .sam_clk_en(sam_clk_en),
                                .sym_clk_en(sym_clk_en),
                                .reset(reset),
                                .in(tx_chan_inphase),
                                .out(rx_up_inphase));

    // RX Modules
    wire signed [17:0] rx_up_sync_inphase;
    config_sam_delay config_sam_del(.clk(sys_clk),
                                       .sam_clk_en(sam_clk_en),
                                       .sym_clk_en(sym_clk_en),
                                       .reset(reset),
                                       .delay(2'd0),
                                       .in(rx_up_inphase),
                                       .out(rx_up_sync_inphase));

    wire signed [17:0] tx_sig_sync_inphase;
    config_sym_delay config_sym_del(.clk(sys_clk),
                                      .sam_clk_en(sam_clk_en),
                                      .sym_clk_en(sym_clk_en),
                                      .reset(reset),
                                      .delay(8'd52),
                                      .in(tx_sig_inphase),
                                      .out(tx_sig_sync_inphase));

    wire [1:0] tx_data_delay;
    config_data_delay config_data_del(.clk(sys_clk),
                                         .sam_clk_en(sam_clk_en),
                                         .sym_clk_en(sym_clk_en),
                                         .reset(reset),
                                         .delay(8'd52),
                                         .in(tx_data[1:0]),
                                         .out(tx_data_delay));

    wire signed [17:0] rx_inphase;
    downsampler_4 downsample(.clk(sys_clk),
                                .sym_clk_en(sym_clk_en),
                                .reset(reset),
                                .in(rx_up_sync_inphase),
                                .out(rx_inphase));



    // Data Decoding
    wire signed [17:0] rx_ref_level, rx_avg_power;
    ref_level_gen ref_level_rx(.clk(sys_clk),
                               .clk_en(sym_clk_en),
                               .reset(reset),
                               .hold(cycle_out_periodic),
                               .clear(cycle_out_periodic_behind),
                               .dec_var(rx_inphase),
                               .ref_level(rx_ref_level),
                               .avg_power(rx_avg_power));

    wire [1:0] rx_data;
    slicer_4_ask slicer(.clk(sys_clk),
                           .clk_en(sym_clk_en),
                           .in(rx_inphase),
                           .ref_level(rx_ref_level),
                           .sym_out(rx_data));

    wire signed [17:0] rx_sig_mapped;
    wire signed [17:0] symbol_p2, symbol_p1, symbol_n1, symbol_n2;
    mapper_4_ask_ref mapper_rx(.clk(sys_clk),
                                  .clk_en(sym_clk_en),
                                  .data(rx_data),
                                  .ref_level(rx_ref_level),
                                  .sig_out(rx_sig_mapped),
                                  .SYMBOL_P2(symbol_p2),
                                  .SYMBOL_P1(symbol_p1),
                                  .SYMBOL_N1(symbol_n1),
                                  .SYMBOL_N2(symbol_n2));

    // Performance Evaluation
    reg signed [17:0] err_diff;
    always @*
        err_diff = rx_inphase - rx_sig_mapped;

    wire signed [17:0] acc_sq_err_out;
    wire signed [17+`LFSR_LEN:0] acc_out_full;
    err_sq_gen err_sq(.clk(sys_clk),
                         .clk_en(sym_clk_en),
                         .reset(reset),
                         .hold(cycle_out_periodic),
                         .err(err_diff),
                         .acc_sq_err_out(acc_sq_err_out),
                         .acc_out_full(acc_out_full));

    wire [17:0] acc_dc_err_out_inphase;
    wire [`LFSR_LEN + 17:0] acc_out_full_dc_inphase;
    err_dc_gen err_dc_gen(.clk(sys_clk),
                             .clk_en(sym_clk_en),
                             .reset(reset),
                             .hold(cycle_out_periodic),
                             .err(err_diff),
                             .acc_dc_err_out(acc_dc_err_out_inphase),
                             .acc_out_full(acc_out_full_dc_inphase));

    */

endmodule
