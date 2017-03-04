module dac_sanity_top(input clock_50,
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
                   output sym_clk_ena,
                   output [3:0] clk_phase);

    wire reset;
    assign reset = ~KEY[0];

    // LED Sanity Check
    always @*
        if(reset)
            LEDR = 0;
        else
            LEDR = SW;

    always @*
        if(reset)
            LEDG[3:0] = 0;
        else
            LEDG[3:0] = KEY[3:0];

    `include "dac_adc_setup.vh"

    clk_gen clk_gen_mod(.clk_in(clock_50),
                        .reset(reset),
                        .sys_clk(sys_clk),
                        .sam_clk(sam_clk),
                        .sym_clk(sym_clk),
                        .sam_clk_ena(sam_clk_ena),
                        .sym_clk_ena(sym_clk_ena),
                        .clk_phase(clk_phase));

    (*keep*) wire [3:0] data_stream_tx;
    (*keep*) wire [21:0] lfsr_sequence;
    (*keep*) wire lfsr_cycle_out, lfsr_cycle_out_periodic, lfsr_cycle_out_periodic_ahead, lfsr_cycle_out_periodic_behind;
    (*keep*) wire [21:0] lfsr_counter;
    lfsr_gen_max lfsr_data_mod(.clk(sys_clk),
                              .clk_en(sym_clk_ena),
                              .reset(reset),
                              .seq_out(lfsr_sequence),
                              .sym_out(data_stream_tx),
                              .cycle_out_once(lfsr_cycle_out),
                              .cycle_out_periodic(lfsr_cycle_out_periodic),
                              .cycle_out_periodic_ahead(lfsr_cycle_out_periodic_ahead),
                              .cycle_out_periodic_behind(lfsr_cycle_out_periodic_behind),
                              .lfsr_counter(lfsr_counter));

    (*keep*) wire signed [17:0] mapped_inphase, mapped_quadrature;
    mapper_16_qam_ref mapper_16_qam(.clk(sys_clk),
                                    .clk_en(sym_clk_ena),
                                    .data(data_stream_tx),
                                    .ref_level(18'd87381),
                                    .sig_inph(mapped_inphase),
                                    .sig_quad(mapped_quadrature));

    (*keep*) wire signed [17:0] signal_inphase, signal_quadrature;
    upsampler_4 upsampler_4_inphase(.clk(sys_clk),
                                    .sam_clk_en(sam_clk_ena),
                                    .sym_clk_en(sym_clk_ena),
                                    .phase4(clk_phase[3:2]),
                                    .reset(reset),
                                    .data_in(mapped_inphase),
                                    .data_out(signal_inphase));



    // INSTANTIAION OF LOUIS' CODE


    wire [`LFSR_LEN-1:0] LFSR;
    reg [`LFSR_LEN-1:0] LFSR_reg;
    always @ *
      LFSR_reg = LFSR;

    wire sys_clk_louis, sam_clk_louis, sym_clk_louis, sam_clk_ena_louis, sym_clk_ena_louis;
    louis_clock louis_clock_gen(
      .clock_50(clock_50),
      .reset(1'b1),
      .sys_clk(sys_clk_louis),
      .sam_clk(sam_clk_louis),
      .sym_clk(sym_clk_louis),
      .clk_phase(),
      .sam_clk_ena(sam_clk_ena_louis),
      .sym_clk_ena(sym_clk_ena_louis)
    );

    louis_lfsr_22 louis_lfsr_mod(.sys_clk(sys_clk),
                                 .clk_ena(sym_clk_ena),
                                 .reset(~reset),
                                 .sig_in(LFSR_reg),
                                 .reset_value({{`LFSR_LEN}{1'b0}}),
                                 .sig_out(LFSR));

    wire signed [17:0] louis_mapped_inphase;
    wire signed [17:0] louis_signal_inphase;
    louis_mapper louis_mapper_mod(.sig_in({LFSR[15], LFSR[0]}),
                                 .reference_level(`SYMBOL_REF),
                                 .sig_out(louis_mapped_inphase));

    assign louis_signal_inphase = louis_mapped_inphase;

    // And some funny combos
    wire signed [17:0] combo_mapped_inphase;
    louis_mapper combo_mapper_mod(.sig_in(data_stream_tx),
                                 .reference_level(`SYMBOL_REF),
                                 .sig_out(combo_mapped_inphase));

     (*keep*) wire signed [17:0] combo2_mapped_inphase, combo2_mapped_quadrature;
     mapper_16_qam_ref combo_mapper_16_qam(.clk(sys_clk),
                                            .clk_en(sym_clk_ena),
                                            .data(data_stream_tx),
                                            .ref_level(`SYMBOL_REF),
                                            .sig_inph(combo2_mapped_inphase),
                                            .sig_quad(combo2_mapped_quadrature));

    (*keep*) wire signed [17:0] combo3_mapped_inphase;
    mapper_4_ask_ref mapper_4_mod(.data(data_stream_tx),
                                  .ref_level(`SYMBOL_REF),
                                  .sig_out(combo3_mapped_inphase));


endmodule
