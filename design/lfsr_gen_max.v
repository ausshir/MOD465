`ifndef _LFSR_GEN_MAX_V_
`define _LFSR_GEN_MAX_V_

// Maximal length LFSR with 22 taps using (Tap 21 XNOR Tap 22)
//  Made to output a random 2-bit number to simulate binary data payloads
// Based on http://www.ece.ualberta.ca/~elliott/ee552/studentAppNotes/1999f/Drivers_Ed/lfsr.html

`ifndef _DEFINES_VH
    `include "defines.vh"
`endif

module lfsr_gen_max(input clk,
                   input clk_en,
                   input reset,
                   output [21:0] seq_out,
                   output [3:0] sym_out,
                   output reg cycle_out_once,
                   output reg cycle_out_periodic,
                   output reg cycle_out_periodic_ahead,
                   output reg cycle_out_periodic_behind,
                   output reg [`LFSR_LEN-1:0] lfsr_counter);

    wire [31:0] taps_array [0:32];
    assign taps_array[0] =  32'b00000000000000000000000000000000; //invalid
    assign taps_array[1] =  32'b00000000000000000000000000000000; //invalid
    assign taps_array[2] =  32'b00000000000000000000000000000000; //invalid
    assign taps_array[2] =  32'b00000000000000000000000000000011; //invalid
    assign taps_array[3] =  32'b00000000000000000000000000000101; //invalid
    assign taps_array[4] =  32'b00000000000000000000000000001001; //invalid
    assign taps_array[5] =  32'b00000000000000000000000000010010;
    assign taps_array[6] =  32'b00000000000000000000000000100001;
    assign taps_array[7] =  32'b00000000000000000000000001000001;
    assign taps_array[8] =  32'b00000000000000000000000010001110;
    assign taps_array[9] =  32'b00000000000000000000000100001000;
    assign taps_array[10] = 32'b00000000000000000000001000000100;
    assign taps_array[11] = 32'b00000000000000000000010000000010;
    assign taps_array[12] = 32'b00000000000000000000100000101001;
    assign taps_array[13] = 32'b00000000000000000001000000001101;
    assign taps_array[14] = 32'b00000000000000000010000000010101;
    assign taps_array[15] = 32'b00000000000000000100000000000001;
    assign taps_array[16] = 32'b00000000000000001000000000010110;
    assign taps_array[17] = 32'b00000000000000010000000000000100;
    assign taps_array[18] = 32'b00000000000000100000000001000000;
    assign taps_array[19] = 32'b00000000000001000000000000010011;
    assign taps_array[20] = 32'b00000000000010000000000000000100;
    assign taps_array[21] = 32'b00000000000100000000000000000010;
    assign taps_array[22] = 32'b00000000001000000000000000000001;
    assign taps_array[23] = 32'b00000000010000000000000000010000;
    assign taps_array[24] = 32'b00000000100000000000000000001101;
    assign taps_array[25] = 32'b00000001000000000000000000000100;
    assign taps_array[26] = 32'b00000010000000000000000000100011;
    assign taps_array[27] = 32'b00000100000000000000000000010011;
    assign taps_array[28] = 32'b00001000000000000000000000000100;
    assign taps_array[29] = 32'b00010000000000000000000000000010;
    assign taps_array[30] = 32'b00100000000000000000000000101001;
    assign taps_array[31] = 32'b01000000000000000000000000000100;
    assign taps_array[32] = 32'b10000000000000000000000001100010;

    wire [31:0] taps;
    assign taps = taps_array[`LFSR_LEN];

    reg [`LFSR_LEN-2:0] LFSR_reg;
    reg LFSR_fb;

    integer i;
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            LFSR_reg <= `LFSR_SEED;
            LFSR_fb <= 0;
        end

        else if(clk_en) begin
            for(i=`LFSR_LEN-2; i>=1; i=i-1) begin
                if(taps[i-1] == 1'b1) begin
                    LFSR_reg[i] <= LFSR_reg[i-1] ^ LFSR_fb;
                end
                else begin
                    LFSR_reg[i] <= LFSR_reg[i-1];
                end
            end
            LFSR_reg[0] <= LFSR_fb;
            LFSR_fb <= LFSR_reg[`LFSR_LEN-2];
        end
    end

    assign sym_out = {LFSR_reg[19], LFSR_reg[3], LFSR_reg[15], LFSR_reg[0]}; //should be 0,15
    assign seq_out = {LFSR_fb, LFSR_reg};


    // LFSR Cycle Counter
    //  This is for the accumulator to gather one complete cycle of the LFSR
    //  Optionally, this could stop the LFSR or trigger a reset on the reference level logic
    wire count_complete;
    always @(posedge clk or posedge reset)
        if(reset)
            lfsr_counter = 1;
        else if(clk_en)
            if(seq_out == `LFSR_SEED)
                lfsr_counter = 1;
            else
                lfsr_counter = lfsr_counter + 1;
        else
            lfsr_counter = lfsr_counter;

    reg cycle_out_pre, cycle_out_pre_periodic;
    always @(posedge clk or posedge reset)
        if(reset) begin
            cycle_out_pre <= 0;
            cycle_out_pre_periodic <= 0;
        end
        else if(lfsr_counter > 1 && (seq_out == `LFSR_SEED)) begin
            cycle_out_pre <= 1'b1;
            cycle_out_pre_periodic <= 1'b1;
        end
        else begin
            cycle_out_pre <= cycle_out_pre;
            cycle_out_pre_periodic <= 1'b0;
        end

    always @(posedge clk or posedge reset)
        if(reset)
            cycle_out_once = 0;
        else if(clk_en)
            cycle_out_once = cycle_out_pre;

    always @(posedge clk or posedge reset)
        if(reset)
            cycle_out_periodic = 0;
        else if(clk_en)
            cycle_out_periodic = cycle_out_pre_periodic;


    always @*
        if(lfsr_counter == 2)
            cycle_out_periodic_behind = 1;
        else
            cycle_out_periodic_behind = 0;

    always @*
        if(lfsr_counter == {{`LFSR_LEN}{1'b1}})
            cycle_out_periodic_ahead = 1;
        else
            cycle_out_periodic_ahead = 0;




endmodule
`endif
