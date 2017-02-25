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
                    output sym_clk_ena,
                   output wire signed [17:0] acc_dc_err_out,
                   output wire signed [17:0] acc_sq_err_out,
                   output wire signed [17+`LFSR_LEN:0] acc_out_full_dc,
                   output wire signed [17+`LFSR_LEN:0] acc_out_full_sq
                   );



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


    // MER Device from Lab Preamble
    //     Note1: that there are two devices and they have the same module name
    //        Make sure to remove the unused one from the project when compiling
    //     Note2: Active low reset

    (*keep*) wire signed [17:0] inphase_out, quadrature_out;
    MER_device bbx_mer15(.clk(sys_clk),
                         .reset(~reset),
                         .sym_en(sym_clk_ena),
                         .sam_en(sam_clk_ena),
                         .I_in(inphase_in),
                         .Q_in(quadrature_in),
                        .I_out(inphase_out),
                         .Q_out(quadrature_out));

    //wire signed [17:0] mer_device_error, mer_device_clean;
    //DUT_for_MER_measurement mer_device(.clk(sys_clk),
    //                                   .clk_en(sym_clk_ena),
    //                                   .reset(~reset),
    //                                   .in_data(inphase_in),
    //                                   .decision_variable(inphase_out),
    //                                   .errorless_decision_variable(mer_device_clean),
    //                                   .error(mer_device_error));

    //assign inphase_out = inphase_in;
    //assign quadrature_out = quadrature_in;

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

    always @(posedge sys_clk)
        lfsr_counter_out = lfsr_counter;

    // 16-QAM Mapper using parameters
    (*keep*) wire signed [17:0] inphase_in, quadrature_in;
    mapper_16_qam mapper_16_qam_mod(.clk(sys_clk),
                                    .clk_en(sym_clk_ena),
                                    .data(data_stream_in),
                                    .in_phs_sig(inphase_in),
                                    .quad_sig(quadrature_in));

    // Reference level generation for calibrating slicing
    //      Needed due to unknown channel attenuation
    (*keep*) wire signed [17:0] ref_level, avg_power;
    (*noprune*) reg [17:0] avg_power_out;
    ref_level_gen ref_level_gen_mod(.clk(sys_clk),
                                    .clk_en(sym_clk_ena),
                                    .reset(aux_reset),
                                    .hold(lfsr_cycle_out_periodic),
                                    .clear(lfsr_cycle_out_periodic_behind),
                                    .dec_var(inphase_out),
                                    .ref_level(ref_level),
                                    .avg_power(avg_power));

    // TODO: Output this onto a display & signaltap
    always @(posedge sys_clk)
        avg_power_out = avg_power;


    // 4-ASK Slicer to collect only the inphase stream
    (*keep*) wire [1:0] data_stream_out;
    slicer_4_ask slicer_4_ask_mod(.clk(sys_clk),
                                  .clk_en(sym_clk_ena),
                                  .in_phs_sig(inphase_out),
                                  .ref_level(ref_level),
                                  .sym_out(data_stream_out));

    // Signal Verification Modules
    // Re-Mapper to 4-ASK on inphase using reference level in order to compare results
    (*keep*) wire signed [17:0] inphase_out_mapped;
    (*noprune*) reg signed [17:0] inphase_out_del;
    (*keep*) wire signed [17:0] diff_err;
    mapper_4_ask_ref mapper_4_ask_mod(.clk(sys_clk),
                                    .clk_en(sym_clk_ena),
                                    .data(data_stream_out),
                                    .ref_level(ref_level),
                                    .in_phs_sig(inphase_out_mapped));


    // Calculation of error (note that the mapper introduces 1 clock of delay)
    always @(posedge sys_clk)
        inphase_out_del = inphase_out;
    assign diff_err = inphase_out_del - inphase_out_mapped;

    // Squared and DC error calculation for MER
    // Currently defined as outputs...
    //(*keep*) wire [17:0] acc_sq_err_out;
    //(*noprune*) reg [17:0] acc_sq_err_out_reg;
    err_sq_gen err_sq_gen_mod(.clk(sys_clk),
                              .clk_en(sym_clk_ena),
                              .reset(reset),
                              .hold(lfsr_cycle_out_periodic),
                              .err(diff_err),
                              .acc_sq_err_out(acc_sq_err_out),
                              .acc_out_full(acc_out_full_sq)
);
    //(*keep*) wire [17:0] acc_dc_err_out;
    //(*noprune*) reg [17:0] acc_dc_err_out_reg;
    err_dc_gen err_dc_gen_mod(.clk(sys_clk),
                              .clk_en(sym_clk_ena),
                              .reset(reset),
                              .hold(lfsr_cycle_out_periodic),
                              .err(diff_err),
                              .acc_dc_err_out(acc_dc_err_out),
                              .acc_out_full(acc_out_full_dc)
);
    //always @(posedge sys_clk) begin
    //    acc_sq_err_out_reg = acc_sq_err_out;
    //    acc_dc_err_out_reg = acc_dc_err_out;
    //end

    // I HAVE ABSOLUTELY NO IDEA WHY THIS DOESN'T WORK DX
    // Symbol error indicator
    //  Note1: The input symbol must be delayed by a # clock cycles to synchronize
    // Test the symbol synchronization
    //(*noprune*) reg [`INPHASE] sym_delay_reg[`SYM_DELAY:0];
    //(*keep*) wire [`INPHASE] sym_delayed;
    //integer n;
    //always @(posedge sys_clk)
    //    if(sym_clk_ena)
    //        for(n=`SYM_DELAY; n>0; n=n-1) begin
    //            if(n==0)
    //                sym_delay_reg[0] <= data_stream_in[`INPHASE];
    //            else
    //                sym_delay_reg[n] <= sym_delay_reg[n-1];
    //        end
    //assign sym_delayed = sym_delay_reg[`SYM_DELAY];

    reg [`INPHASE] sym_delay_1, sym_delay_2, sym_delay_3, sym_delay_4, sym_delay_5;
    always @(posedge sys_clk)
        if(sym_clk_ena)
            sym_delay_1 = data_stream_in[`INPHASE];

    always @(posedge sys_clk)
        if(sym_clk_ena)
            sym_delay_2 = sym_delay_1;

    always @(posedge sys_clk)
        if(sym_clk_ena)
            sym_delay_3 = sym_delay_2;

    always @(posedge sys_clk)
        if(sym_clk_ena)
            sym_delay_4 = sym_delay_3;

    always @(posedge sys_clk)
        if(sym_clk_ena)
            sym_delay_5 = sym_delay_4;

    (*noprune*) reg sym_correct;
    (*keep*) wire sym_error;
    always @(posedge sys_clk) begin
        if(sym_clk_ena)
            sym_correct <= data_stream_out == sym_delay_3;
    end

    assign sym_error = ~sym_correct;

    always @* begin
        LEDG[7] <= sym_correct;
        LEDG[6] <= sym_error;
    end

endmodule
