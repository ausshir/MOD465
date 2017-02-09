module EE461_Lab_4(
			input CLOCK_50,
			input [17:0]SW,
			input [3:0] KEY,
			input [13:0]ADC_DA,
			input [13:0]ADC_DB,
			output reg [3:0] LEDG,
			output reg [17:0] LEDR,
			output reg[13:0]DAC_DA,
			output reg [13:0]DAC_DB,
			// output	I2C_SCLK,
			// inout		I2C_SDAT,
			output	ADC_CLK_A,
			output	ADC_CLK_B,
			output	ADC_OEB_A,
			output	ADC_OEB_B,
			// input 	ADC_OTR_A,
			// input 	ADC_OTR_B,
			output	DAC_CLK_A,
			output	DAC_CLK_B,
			output	DAC_MODE,
			output	DAC_WRT_A,
			output	DAC_WRT_B
			// ,input 	OSC_SMA_ADC4,
			// input 	SMA_DAC4
			 );
	reg clk;

	reg [11:0] NCO_freq, phase_ref,
			           quadrature_phase_out, phase_to_ROM;
	(* noprune *) reg [11:0] phase_out, staggered_phase_out;
	reg signed [13:0] signal_to_DAC;
	reg signed [29:0] multiplier_output;
	reg [35:0] PLL_acc, quad_phase;

	wire dwell_pulse;
	wire [17:0] sweep_gen_freq;
	wire signed [17:0] SUT_out;
	wire signed [11:0] NCO_1_out, NCO_2_out;
	/******************************
	*	generate the clock used for sampling ADC and
	*  driving the DAC, i.e. generate the sampling clock
	*/
	always @ (posedge CLOCK_50)
	clk = ~clk;
	// end generatating sampling clock

	/************************
			  Set up DACs
			*/
			assign DAC_CLK_A = clk;
			assign DAC_CLK_B = clk;


			assign DAC_MODE = 1'b1; //treat DACs seperately

			assign DAC_WRT_A = ~clk;
			assign DAC_WRT_B = ~clk;

		always@ (posedge clk)// convert 1s13 format to 0u14
								//format and send it to DAC A
		DAC_DA = {~signal_to_DAC[13],
						signal_to_DAC[12:0]};


		always@ (posedge clk) // DAC B is not used in this
					 // lab so makes it the same as DAC A

			DAC_DB = {~signal_to_DAC[13],
						signal_to_DAC[12:0]} ;
			/*  End DAC setup
			************************/

	/********************
	*	set up ADCs, which are not used in this lab
	*/
	(* noprune *) reg [13:0] registered_ADC_A;
	(* noprune *) reg [13:0] registered_ADC_B;

	assign ADC_CLK_A = clk;
			assign ADC_CLK_B = clk;

			assign ADC_OEB_A = 1'b1;
			assign ADC_OEB_B = 1'b1;


			always@ (posedge clk)
				registered_ADC_A <= ADC_DA;

			always@ (posedge clk)
				registered_ADC_B <= ADC_DB;

			/*  End ADC setup
			************************/


	/******************************
			Set up switches and LEDs
			*/
			always @ *
			LEDR = SW;
			always @ *
			LEDG = {dwell_pulse, KEY[2:0]};

	//end setting up switches and LEDs

	// instantiate the sweep generator
		SweepGenerator sweep_gen_1(.clock(clk),
							  .sweep_rate_adj(3'b010),
							  .dwell_pulse(dwell_pulse),
							  .reset(~KEY[1]),
							  .lock_stop(~KEY[2]),
							  .lock_start(~KEY[3]),
							  .freq(sweep_gen_freq));
	// dwell pulse is assigned to LEDG[3] elsewhere so that it is not optimized out


	//  make the phase accumulator for the NCOs

	always @ (posedge clk)
	phase_ref = phase_ref + NCO_freq;



	// make data selector for phase_ref
	always @ (posedge clk)
	if (SW[0]==1'b0)
			NCO_freq = sweep_gen_freq[17:6];
	else  NCO_freq = {SW[17:14], 8'b0};

	// make the data selector for signal_to_DAC
	always @ *
	if (SW[1]==1'b0)
		signal_to_DAC = {NCO_1_out, 2'b0};
	else
	   signal_to_DAC = SUT_out[17:4];

	// make the phase locked loop
	always @ *
	multiplier_output = NCO_2_out * SUT_out;

	always @ *
	quad_phase = { { 6{multiplier_output[29]} }, multiplier_output}
					  + PLL_acc;

	always @ (posedge clk)
	PLL_acc = quad_phase;

	always @ *
	quadrature_phase_out = quad_phase[35:24];

	always @ *
	phase_to_ROM = phase_ref + quadrature_phase_out;

	// end of making PLL

	// make the phase out, which does not to a pin
	// as its intendended destination is SignalTap
	always @ (posedge clk)
	phase_out = quadrature_phase_out + 12'b1100_0000_0000;

	always @ (negedge clk)
	staggered_phase_out = phase_out;

	// intantiate the phase-to-voltage ROM
	// for NCOs 1 and 2
	ROM_for_12_x_12_NCO NCO_ROM_1 (
		  .address_a(phase_ref),
		  .address_b(phase_to_ROM),
		  .clock(clk),
		  .q_a(NCO_1_out),
		  .q_b(NCO_2_out));

	// Instantiate the system under test
/*	system_under_test SUT_1 (.clk(clk),
	                         .SUT_in(NCO_1_out),
									 .SUT_out(SUT_out) );

*/
lab4_windowed_flt filt_1 (.clk(clk),
	                         	 .x_in({NCO_1_out,6'b0}),
									 	 .y(SUT_out),
									 	 .SW(SW[4:2])
										);


endmodule
