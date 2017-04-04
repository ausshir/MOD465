`include "../../design/defines.vh"

`include "../../design/clk_gen.v"
`include "../../design/lfsr_gen_max.v"
`include "../../design/mapper_16_qam_ref.v"
`include "../../design/upsampler_4.v"
`include "../../design/upsampler_2.v"

`include "../../design/config_sam_delay_prac.v"
`include "../../design/config_sam_delay.v"
`include "../../design/config_sym_delay.v"
`include "../../design/config_data_delay.v"
`include "../../design/downsampler_4.v"
`include "../../design/slicer_4_ask.v"
`include "../../design/ref_level_gen.v"
`include "../../design/mapper_4_ask_ref.v"
`include "../../design/tx_mixer.v"

`include "../../design/srrc_gold_rx_flt.v"
`include "../../design/srrc_gold_tx_flt.v"
`include "../../design/srrc_prac_tx_flt.v"
`include "../../design/srrc_prac_hb_flt.v"

`include "../../design/err_sq_gen.v"
`include "../../design/err_dc_gen.v"

`include "../../design/tx_modules.v"
`include "../../design/rx_perf_modules.v"
`include "../../design/sync_modules.v"

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
                   output reset,
                   output aux_reset,
                   output sys_clk,
                   output sam_clk,
                   output sym_clk,
                   output sam_clk_en,
                   output sym_clk_en,
                   output hb_clk_en,
                   output reg [1:0] rx_data_out,
                   output reg rx_data_correct,
                   output reg signed [17:0] err_diff);

    // System

    // LED Sanity Check
    always @*
        LEDR = SW;

    always @*
        LEDG[3:0] = KEY[3:0];
    always @*
        LEDG[5:4] = 2'b0;

    // Reset Switch on KEY0
    assign reset = ~KEY[0];
    assign aux_reset = ~KEY[1];

    // ADC and DAC Setup
    (*noprune*) reg [13:0] registered_ADC_A;
    (*noprune*) reg [13:0] registered_ADC_B;
    (*noprune*) reg signed [17:0] DAC_A_in, DAC_B_in;

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
            5'b00001 : DAC_A_in = tx_srrc_inph;
            5'b00010 : DAC_A_in = tx_up_hba_inph;
            5'b00011 : DAC_A_in = tx_hb_hba_inph;
            5'b00100 : DAC_A_in = tx_up_hbb_inph;
            5'b00101 : DAC_A_in = tx_hb_hbb_inph;
            5'b00110 : DAC_A_in = tx_sig_inph;
            5'b00111 : DAC_A_in = tx_channel;
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
    // (*keep*) wire sys_clk, sam_clk, sym_clk, sam_clk_en, sym_clk_en;
    (*keep*) wire [3:0] phase;
    clk_gen clocks(.clk_in(clock_50),
                      .reset(reset),
                      .sys_clk(sys_clk),
                      .sam_clk(sam_clk),
                      .sym_clk(sym_clk),
                      .sam_clk_ena(sam_clk_en),
                      .sym_clk_ena(sym_clk_en),
                      .hb_clk_ena(hb_clk_en),
                      .clk_phase(phase));

    wire [3:0] tx_data;
    wire [21:0] seq_out;
    wire cycle_out_once, cycle_out_periodic, cycle_out_periodic_ahead, cycle_out_periodic_behind;
    wire [`LFSR_LEN-1:0] lfsr_counter;
    lfsr_gen_max lfsr(.clk(sys_clk),
                       .reset(reset),
                       .sam_clk_en(sam_clk_en),
                       .sym_clk_en(sym_clk_en),
                       .seq_out(seq_out),
                       .sym_out(tx_data),
                       .cycle_out_once(cycle_out_once),
                       .cycle_out_periodic(cycle_out_periodic),
                       .cycle_out_periodic_ahead(cycle_out_periodic_ahead),
                       .cycle_out_periodic_behind(cycle_out_periodic_behind),
                       .lfsr_counter(lfsr_counter));

    // TX Modules
    wire signed [17:0] tx_out_inph, tx_srrc_inph, tx_sig_inph;
    wire signed [17:0] tx_up_hba_inph, tx_up_hbb_inph, tx_hb_hba_inph, tx_hb_hbb_inph;
    tx_modules tx_inph(.sys_clk(sys_clk),
                      .sam_clk_en(sam_clk_en),
                      .sym_clk_en(sym_clk_en),
                      .hb_clk_en(hb_clk_en),
                      .reset(reset),
                      .tx_data(tx_data[1:0]),
                      .tx_sig(tx_sig_inph),
                      .tx_srrc(tx_srrc_inph),
                      .tx_out(tx_out_inph),
                      .tx_up_hba(tx_up_hba_inph),
                      .tx_up_hbb(tx_up_hbb_inph),
                      .tx_hb_hba(tx_hb_hba_inph),
                      .tx_hb_hbb(tx_hb_hbb_inph));

    wire signed [17:0] tx_out_quad, tx_srrc_quad, tx_sig_quad;
    wire signed [17:0] tx_up_hba_quad, tx_up_hbb_quad, tx_hb_hba_quad, tx_hb_hbb_quad;
    tx_modules tx_quad(.sys_clk(sys_clk),
                        .sam_clk_en(sam_clk_en),
                        .sym_clk_en(sym_clk_en),
                        .hb_clk_en(hb_clk_en),
                        .reset(reset),
                        .tx_data(tx_data[1:0]),
                        .tx_sig(tx_sig_quad),
                        .tx_srrc(tx_srrc_quad),
                        .tx_out(tx_out_quad),
                        .tx_up_hba(tx_up_hba_quad),
                        .tx_up_hbb(tx_up_hbb_quad),
                        .tx_hb_hba(tx_hb_hba_quad),
                        .tx_hb_hbb(tx_hb_hbb_quad));

    wire signed [17:0] tx_channel;
    tx_mixer tx_mixer_tb(.clk(sys_clk),
                         .sym_clk_en(sym_clk_en),
                         .reset(reset),
                         .tx_inph(tx_out_inph),
                         .tx_quad(tx_out_quad),
                         .tx_channel(tx_channel));

endmodule
