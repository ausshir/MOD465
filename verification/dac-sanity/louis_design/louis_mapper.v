module louis_mapper(
  input [1:0] sig_in,
  input [17:0] reference_level,
  output reg signed [17:0] sig_out
);

always @ *
  case(sig_in)
    2'b11: sig_out = {-{reference_level + {1'b0, reference_level[17:1]}}}; // -3/2*r (-1)
    2'b10: sig_out = {-{1'b0, reference_level[17:1]}}; // -1/2*r                     (-1/3)
    2'b00: sig_out = { {1'b0, reference_level[17:1]}}; //  1/2*r                     (1/3)
    2'b01: sig_out = {{reference_level + {1'b0, reference_level[17:1]}}}; //  3/2*r  (+1)
    default: sig_out = 18'sd0;
  endcase
endmodule
