`ifndef _LFSR_22_MAX_V_
`define _LFSR_22_MAX_V_

// Maximal length LFSR with 22 taps using (Tap 21 XNOR Tap 22)
//  Made to output a random 2-bit number to simulate binary data payloads

module lfsr_22_max(input clk,
                   input reset,
                   output [21:0] seq_out,
                   output [1:0] sym_out);

    reg [21:0] fb_reg;

    integer i;
    always @(posedge clk)
        if(reset)
            fb_reg[21] <= 1'b1;
        else
            fb_reg[21] <= fb_reg[20] ~^ fb_reg[19];

    always @(posedge clk)
        if(reset)
            fb_reg[20:0] <= 21'b111010110111101010111;
        else begin
            for(i=1; i<=20; i=i+1) begin
                fb_reg[i] <= fb_reg[i-1];
            end
            fb_reg[0] <= fb_reg[21];
        end


    assign sym_out = fb_reg[1:0];
    assign seq_out = fb_reg;

endmodule
`endif
