`ifndef _SRRC_RX_FLT_V_
`define _SRRC_RX_FLT_V_

module srrc_rx_flt (input clk,
                    input reset,
		            input signed [17:0] in,
	                output reg signed [17:0] out);

integer i;
reg signed [17:0]	b[8:0];
reg signed [17:0]	x[16:0];
reg signed [35:0] mult_out[8:0];
reg signed [17:0] sum_level_1[8:0];
reg signed [17:0] sum_level_2[4:0];
reg signed [17:0] sum_level_3[2:0];
reg signed [17:0] sum_level_4[1:0];

// Input and shift register
// May need to sign extend input
always @*
    if(reset)
        x[0] = 18'b0;
    else
        x[0] = { in[17:0] };

// Shift Register
always @ (posedge clk)
    for( i=1; i<17;i=i+1)
        if(reset)
            x[i] = 18'b0;
        else
            x[i] <= x[i-1];

always @ *
    for(i=0;i<=15;i=i+1)
        if(reset)
            sum_level_1[i] = 15'b0;
        else
            sum_level_1[i] = x[i]+x[16-i];

always @ *
    if(reset)
        sum_level_1[8] = 1'b0;
    else
        sum_level_1[8] = x[8];

// always @ (posedge clk) // For pipelining
always @ *
    for(i=0;i<=8; i=i+1)
        if(reset)
            mult_out[i] = 16'b0;
        else
            mult_out[i] = sum_level_1[i] * b[i];

always @ *
    for(i=0;i<=8;i=i+1)
        if(reset)
            sum_level_2[i] = 8'b0;
        else begin
            sum_level_2[i] <= mult_out[2*i][34:17] + mult_out[2*i+1][34:17];
            sum_level_2[4] <= mult_out[8][34:17];
        end

always @ *
    for(i=0;i<=4;i=i+1)
        if(reset)
            sum_level_3[i] = 4'b0;
        else begin
            sum_level_3[i] <= sum_level_2[2*i] + sum_level_2[2*i+1];
            sum_level_3[2] <= sum_level_2[4];
        end

always @ *
    for(i=0;i<=2;i=i+1)
        if(reset)
            sum_level_4[i] = 18'b0;
        else begin
            sum_level_4[0] <= sum_level_3[0] + sum_level_3[2];
            sum_level_4[1] <= sum_level_3[1];
        end

always @ (posedge clk)
    if(reset)
        out = 0;
    else
        out = sum_level_4[0] + sum_level_4[1];


always @* begin
    if(reset)
        b[ 0] =  18'sd   3259;
        b[ 1] = -18'sd   3378;
        b[ 2] = -18'sd  10461;
        b[ 3] = -18'sd  12207;
        b[ 4] = -18'sd   3946;
        b[ 5] =  18'sd  14611;
        b[ 6] =  18'sd  38196;
        b[ 7] =  18'sd  57937;
        b[ 8] =  18'sd  65624;
end

endmodule
`endif
