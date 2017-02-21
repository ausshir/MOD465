`ifndef _LFSR_22_MAX_V_
`define _LFSR_22_MAX_V_

// Maximal length LFSR with 22 taps using (Tap 21 XNOR Tap 22)
//  Made to output a random 2-bit number to simulate binary data payloads

`include "defines.vh"

module lfsr_22_max(input clk,
                   input clk_en,
                   input reset,
                   output [21:0] seq_out,
                   output [3:0] sym_out,
                   output reg cycle_out);

    reg [21:0] fb_reg;

    integer i;
    always @(posedge clk or posedge reset)
        if(reset)
            fb_reg[21] <= 1'b1;
        else if(clk_en)
            fb_reg[21] <= fb_reg[20] ~^ fb_reg[19];

    always @(posedge clk or posedge reset)
        if(reset)
            fb_reg[20:0] <= `LFSR_SEED;
        else if(clk_en) begin
            for(i=1; i<=20; i=i+1) begin
                fb_reg[i] <= fb_reg[i-1];
            end
            fb_reg[0] <= fb_reg[21];
        end


    assign sym_out = fb_reg[3:0];
    assign seq_out = fb_reg;


    // LFSR Cycle Counter
    //  This is for the accumulator to gather one complete cycle of the LFSR
    //  Optionally, this could stop the LFSR or trigger a reset on the reference level logic
    reg [22:0] lfsr_counter;
    wire count_complete;
    always @(posedge clk or posedge reset)
        if(reset)
            lfsr_counter = 0;
        else if(clk_en)
            if(seq_out == `LFSR_SEED)
                lfsr_counter = 0;
            else
                lfsr_counter = lfsr_counter + {{{`LFSR_LEN-1}{1'b0}}, 1'b1};
        else
            lfsr_counter = lfsr_counter;

    always @(posedge clk or posedge reset)
        if(reset)
            cycle_out = 0;
        else if(lfsr_counter > 1 && (fb_reg == `LFSR_SEED))
            cycle_out = 1'b1;
        else
            cycle_out = cycle_out;



endmodule
`endif
