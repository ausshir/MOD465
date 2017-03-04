// ADC and DAC Setup
(* noprune *) reg [13:0] ADC_A_reg, ADC_B_reg;
(* noprune *) reg signed [17:0] DAC_A_in, DAC_B_in;

assign DAC_CLK_A = sys_clk_louis;
assign DAC_CLK_B = sys_clk_louis;
assign DAC_MODE = 1'b1; //treat DACs seperately
assign DAC_WRT_A = ~sys_clk_louis;
assign DAC_WRT_B = ~sys_clk_louis;

always @(posedge sys_clk_louis)// convert 1s13 format to 0u14 format and send it to DAC A/B
    DAC_DA = {~DAC_A_in[17], DAC_A_in[16:4]};

always@ (posedge sys_clk_louis)
    DAC_DB = {~DAC_B_in[17], DAC_B_in[16:4]};

always @*
    case(SW[5:0])
        6'b000001 : DAC_A_in = signal_inphase;
        6'b000010 : DAC_A_in = mapped_inphase;
        6'b000100 : DAC_A_in = combo_mapped_inphase;
        6'b001000 : DAC_A_in = combo2_mapped_inphase;
        6'b010000 : DAC_A_in = combo3_mapped_inphase;
        6'b100000 : DAC_A_in = louis_mapped_inphase;
        default : DAC_A_in = 0;
    endcase

 always @*
    DAC_B_in = DAC_A_in;

assign ADC_CLK_A = sys_clk;
assign ADC_CLK_B = sys_clk;
assign ADC_OEB_A = 1'b1;
assign ADC_OEB_B = 1'b1;

always@ (posedge sys_clk_louis)
    ADC_A_reg <= ADC_DA;

always@ (posedge sys_clk_louis)
    ADC_B_reg <= ADC_DB;
