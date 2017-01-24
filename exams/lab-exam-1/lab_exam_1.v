module lab_exam_1(
						   input clock_50,
							input [17:0]SW,
							input [3:0] KEY,
							input [13:0]ADC_DA,
						   input [13:0]ADC_DB,
							output reg [3:0] LEDG,
							output reg [17:0] LEDR,
							output reg[13:0]DAC_DA,
							output reg [13:0]DAC_DB,
							output	ADC_CLK_A,
							output	ADC_CLK_B,
							output	ADC_OEB_A,
							output	ADC_OEB_B,
							output	DAC_CLK_A,
							output	DAC_CLK_B,
							output	DAC_MODE,
							output	DAC_WRT_A,
							output	DAC_WRT_B,
							output	signed [17:0] srrc_out,
							output	signed [17:0] srrc_input,
							output	[1:0]	i_sym,
							output	sys_clk,
							output	sam_clk_ena,
							output	sym_clk_ena
							);
			  

//**************************************************				
//					DECLARATIONS					
					
		(* keep *) wire signed [13:0]	sin_out;

					
		reg [4:0] NCO_freq;	// unsigned fraction with units cycles/sample	
					
										
	   (* noprune *)reg [13:0] registered_ADC_A;
		(* noprune *)reg [13:0] registered_ADC_B;
					

									
	//*****************************
	//			Set up switches and LEDs
	
					always @ *
					LEDR = SW;
					always @ *
					LEDG = KEY;
					
	// end setting up switches and LEDs
	// ***************************
							
	//************************
	//				  Set up DACs
					
					assign DAC_CLK_A = sys_clk;
					assign DAC_CLK_B = sys_clk;
					
					
					assign DAC_MODE = 1'b1; //treat DACs seperately
					
					assign DAC_WRT_A = ~sys_clk;
					assign DAC_WRT_B = ~sys_clk;
					
					always@ (posedge sys_clk)// make DAC A echo ADC A
					DAC_DA = registered_ADC_A[13:0];
						
						
		always@ (posedge sys_clk) 
			DAC_DB = DAC_out;
			
//  End DAC setup
//************************	
					
// ************************
//		 Setup ADCs
					
					assign ADC_CLK_A = sys_clk;
					assign ADC_CLK_B = sys_clk;
					
					assign ADC_OEB_A = 1'b1;
					assign ADC_OEB_B = 1'b1;

					
					always@ (posedge sys_clk)
						registered_ADC_A <= ADC_DA;
						
					always@ (posedge sys_clk)
						registered_ADC_B <= ADC_DB;
						
// **********************************************************
// Main Code
// **********************************************************
//wire sys_clk, sam_clk, sam_clk_ena, sym_clk_ena, sym_clk, q1;
wire sam_clk, sym_clk, q1;
						

//wire signed [17:0]srrc_out, srrc_input;
wire [13:0] DAC_out;
//wire [1:0] i_sym; //value of symbol

 EE465_filter_test_baseband SRRC_test(
						   .clock_50(clock_50),
							.reset(~KEY[3]),
							.output_from_filter_1s17(srrc_out),
							.filter_input_scale(SW[2:0]),
							.input_to_filter_1s17(srrc_input),
							.lfsr_value(i_sym),
							.symbol_clk_ena(sym_clk_ena),
							.sample_clk_ena(sam_clk_ena),
							.system_clk(sys_clk),
							.output_to_DAC(DAC_out)
							);

//Connect your TX filter here					
//ee465_gold_standard_srrc filly(
//			.sys_clk(sys_clk), 		//system clock, your design may not use this
//			.sam_clk(sam_clk_ena), 	//sampling clock
//			.sig_in(srrc_input), 	//4-ASK input value 1s17
//			.sig_out(srrc_out) 		//output of SRRC filter 1s17
//			);


//srrc_tx_lut_flt tx_m_flt(.clk(sam_clk_ena),
//							.reset(~KEY[3]),
//							.symbol_clk(sym_clk_ena),
//							.in(srrc_input),
//							.out(srrc_out));
							
			
// *********************************************************
// Code for your MER circuit goes below here
// *********************************************************




endmodule
