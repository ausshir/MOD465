module louis_clock(
  input clock_50, reset,
  output wire sys_clk, sam_clk, sym_clk, sam_clk_ena, sym_clk_ena,
  output wire [3:0] clk_phase
);

reg [4:0] q;
always @ (posedge clock_50 or negedge reset)
  if (reset == 1'b0)
    q = 5'd0;
  else
    q = q - 5'd1;

assign sys_clk = q[0];
assign sam_clk = q[2];
assign sym_clk = q[4];
assign clk_phase = ~q[4:1];
assign sam_clk_ena = &clk_phase[1:0];
assign sym_clk_ena = &clk_phase;

endmodule
