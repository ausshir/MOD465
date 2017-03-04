module louis_lfsr_22(
  input sys_clk, clk_ena, reset,
  input [21:0] sig_in, reset_value,
  output reg [21:0] sig_out
);

reg linear_feedback;
always @ *
	linear_feedback <= sig_in[1] ~^ sig_in[0];

always @ (posedge sys_clk or negedge reset)
  if (reset == 1'b0)
    sig_out = reset_value;
  else
    if (clk_ena == 1'b1)
      if (sig_in == 22'd1) // last value before rolling over to all zero's
        sig_out <= 22'd4194303; // all ones
      else if (sig_in == 22'd4194303) // all ones
        sig_out <= 22'd0; // all zero's
      else
        sig_out <= {linear_feedback, sig_in[21:1]};
    else
      sig_out = sig_out;

endmodule
