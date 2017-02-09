module system_under_test (
input clk, 
input signed [11:0] SUT_in,
output reg signed [17:0] SUT_out);

always @ * 
SUT_out = {SUT_in, 6'b0};
endmodule
