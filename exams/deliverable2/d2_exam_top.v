// Enable one of these to model the channel
`define CHANNEL_BLACKBOX
//`define CHANNEL_MODEL
//`define CHANNEL_NONE

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
                   output    DAC_WRT_B,

                   // Outputs from internal data for viewing
                   output sys_clk,
                   output sam_clk,
                   output sym_clk,
                   output sam_clk_ena,
                   output sym_clk_ena);

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
    (* noprune *) reg [13:0] registered_ADC_A;
    (* noprune *) reg [13:0] registered_ADC_B;
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

    // Clock Generator module
    //     Takes in the system clock and generates 1/2, 1/8, 1/32 clock periods
    //     Note1: the enables occur just before the clock edges to be clocked on sys_clk to help keep
    //          clock domains synchronized

    (*keep*) wire [3:0] clk_phase;
    clk_gen clk_gen_mod(.clk_in(clock_50),
                        .reset(reset),
                        .sys_clk(sys_clk),
                        .sam_clk(sam_clk),
                        .sym_clk(sym_clk),
                        .sam_clk_ena(sam_clk_ena),
                        .sym_clk_ena(sym_clk_ena),
                        .clk_phase(clk_phase));

    // 22-bit LFSR for generating random data to evaluate performance
    (*keep*) wire [3:0] data_stream_in;
    (*keep*) wire [21:0] lfsr_sequence;
    (*keep*) wire lfsr_cycle_out, lfsr_cycle_out_periodic, lfsr_cycle_out_periodic_ahead, lfsr_cycle_out_periodic_behind;
    (*keep*) wire [21:0] lfsr_counter;
    (*noprune*) reg [21:0] lfsr_counter_out;
    (*noprune*) reg lfsr_cycle_out_periodic_ahead_reg; // TEMPORARY
    lfsr_gen_max lfsr_data_mod(.clk(sys_clk),
                              .clk_en(sym_clk_ena),
                              .reset(reset),
                              .seq_out(lfsr_sequence),
                              .sym_out(data_stream_in),
                              .cycle_out_once(lfsr_cycle_out),
                              .cycle_out_periodic(lfsr_cycle_out_periodic),
                              .cycle_out_periodic_ahead(lfsr_cycle_out_periodic_ahead),
                              .cycle_out_periodic_behind(lfsr_cycle_out_periodic_behind),
                              .lfsr_counter(lfsr_counter));

    always @(posedge sys_clk) begin
        lfsr_counter_out <= lfsr_counter;
        lfsr_cycle_out_periodic_ahead_reg <= lfsr_cycle_out_periodic_ahead;
    end

    // 16-QAM Mapper using parameters
    (*keep*) wire signed [17:0] inphase_in, quadrature_in;
    mapper_16_qam mapper_16_qam_mod(.clk(sys_clk),
                                    .clk_en(sym_clk_ena),
                                    .data(data_stream_in),
                                    .in_phs_sig(inphase_in),
                                    .quad_sig(quadrature_in));


    /**************************************************************************/
    //
    // CHANNEL MODELS
    //
    /**************************************************************************/
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
                         .I_in(inphase_in),
                         .Q_in(quadrature_in),
                         .I_out(inphase_out),
                         .Q_out(quadrature_out));
    `endif

    `ifdef CHANNEL_MODEL
    wire signed [17:0] mer_device_error_inphase, mer_device_clean_inphase;
    wire signed [17:0] mer_device_error_quadrature, mer_device_clean_quadrature;
    DUT_for_MER_measurement mer_device(.clk(sys_clk),
                                       .clk_en(sym_clk_ena),
                                       .reset(~aux_reset),
                                       .in_data(inphase_in),
                                       .decision_variable(inphase_out),
                                       .errorless_decision_variable(mer_device_clean_inphase),
                                       .error(mer_device_error_inphase));

   wire signed [17:0] mer_device_error, mer_device_clean;
   DUT_for_MER_measurement mer_device(.clk(sys_clk),
                                      .clk_en(sym_clk_ena),
                                      .reset(~aux_reset),
                                      .in_data(quadrature_in),
                                      .decision_variable(quadrature_out),
                                      .errorless_decision_variable(mer_device_clean_quadrature),
                                      .error(mer_device_error_quadrature));
    `endif

    `ifdef CHANNEL_NONE
    assign inphase_out = inphase_in;
    assign quadrature_out = quadrature_in;
    `endif

    /**************************************************************************/
    //
    // INPHASE MAPPING AND CALCULATIONS
    //
    /**************************************************************************/

    `include "d2_exam_inphase.vh"

    /**************************************************************************/
    //
    // QUADRATURE MAPPING AND CALCULATIONS
    //
    /**************************************************************************/

    `include "d2_exam_quadrature.vh"

endmodule
