module ref_level_test # (
  parameter LFSR_LENGTH = 22
  )(
  input clk, clk_en, reset,
  input hold,
  input [17:0] dec_var,
  output reg signed [17:0] ref_level, avg_power,
  output reg signed [17+LFSR_LENGTH:0] sum_dec_var, delayed_sum_dec_var
);

// ----------------------------------------------------------------------------------
//  accumulator
// ----------------------------------------------------------------------------------

always @ *
  if (dec_var[17] == 1'b0) //if positive
    sum_dec_var = delayed_sum_dec_var + dec_var;
  else // must be negative
    sum_dec_var = delayed_sum_dec_var + {-dec_var};

always @ (posedge clk or negedge reset)
  if (reset == 1'b0)
    delayed_sum_dec_var = {{LFSR_LENGTH + 18}{1'b0}};
  else
    if (clk_en == 1'b1)
      if (hold == 1'b0)
        delayed_sum_dec_var = sum_dec_var;
      else
        delayed_sum_dec_var = {{LFSR_LENGTH + 18}{1'b0}};
    else
      delayed_sum_dec_var = delayed_sum_dec_var;

// ----------------------------------------------------------------------------------
//  reference level
// ----------------------------------------------------------------------------------

always @ (posedge clk or negedge reset)
  if (reset == 1'b0)
    ref_level = 18'd0;
  else
    if (hold == 1'b1)
      ref_level = sum_dec_var[17+LFSR_LENGTH:LFSR_LENGTH];
    else
      ref_level = ref_level;


// ----------------------------------------------------------------------------------
//  mapper out power
// ----------------------------------------------------------------------------------

reg [35:0] squared_ref_level;
always @ *
  squared_ref_level = ref_level*ref_level; //2s34

reg [17:0] trimmed_squared_ref_level;
always @ *
  trimmed_squared_ref_level = squared_ref_level[34:17]; //1s17

reg [35:0] mult_out;
wire [17:0] one_p_two_five = 18'd81920; //2s16
always @ *
  mult_out = trimmed_squared_ref_level * one_p_two_five; //3s33

always @ *
  avg_power = mult_out[33:16]; //1s17

endmodule
