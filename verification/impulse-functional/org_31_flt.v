`ifndef _ORG_31_FLT_V_
`define _ORG_31_FLT_V_

module org_31_flt (input clk,
                    input reset,
		            input signed [17:0] in,
	                output reg signed [17:0] out);

integer i;
reg signed [17:0]	b[15:0];
reg signed [17:0]	x[30:0];
reg signed [35:0] mult_out[15:0];
reg signed [17:0] sum_level_1[15:0];
reg signed [17:0] sum_level_2[7:0];
reg signed [17:0] sum_level_3[3:0];
reg signed [17:0] sum_level_4[1:0];
reg signed [17:0] sum_level_5;

// Input and shift register
// May need to sign extend input
always @ (posedge clk)
    if(reset)
        x[0] = 18'b0;
    else
        x[0] = { in[17:0] };

// Shift Register
always @ (posedge clk)
    for(i=1; i<31;i=i+1)
        if(reset)
            x[i] = 18'b0;
        else
            x[i] <= x[i-1];

always @ *
    for(i=0;i<=14;i=i+1)
        if(reset)
            sum_level_1[i] = 15 'b0;
        else
            sum_level_1[i] = x[i]+x[30-i];

always @ *
    if(reset)
        sum_level_1[15] = 1'b0;
    else
        sum_level_1[15] = x[15];

// always @ (posedge clk) // For pipelining
always @ *
    for(i=0;i<=15; i=i+1)
        if(reset)
            mult_out[i] = 16'b0;
        else
            mult_out[i] = sum_level_1[i] * b[i];

always @ *
    for(i=0;i<=7;i=i+1)
        if(reset)
            sum_level_2[i] = 8'b0;
        else
            sum_level_2[i] = mult_out[2*i][34:17] + mult_out[2*i+1][34:17];

always @ *
    for(i=0;i<=3;i=i+1)
        if(reset)
            sum_level_3[i] = 4'b0;
        else
            sum_level_3[i] = sum_level_2[2*i] + sum_level_2[2*i+1];

always @ *
    for(i=0;i<=1;i=i+1)
        if(reset)
            sum_level_4[i] = 2'b0;
        else
            sum_level_4[i] = sum_level_3[2*i] + sum_level_3[2*i+1];

always @ *
    if(reset)
        sum_level_5 = 18'b0;
    else
        sum_level_5 = sum_level_4[0] + sum_level_4[1];

always @ (posedge clk)
    if(reset)
        out = 0;
    else
        out = sum_level_5;


always @* begin // Han Window
    if(reset)
        b[ 0] =  18'sd     12;
        b[ 1] = -18'sd     65;
        b[ 2] = -18'sd    195;
        b[ 3] =  18'sd      0;
        b[ 4] =  18'sd    881;
        b[ 5] =  18'sd   2071;
        b[ 6] =  18'sd   2249;
        b[ 7] =  18'sd      0;
        b[ 8] =  18'sd   3259;
        b[ 9] = -18'sd   3378;
        b[10] = -18'sd  10461;
        b[11] = -18'sd  12207;
        b[12] = -18'sd   3946;
        b[13] =  18'sd  14611;
        b[14] =  18'sd  38196;
        b[15] =  18'sd  57937;
end

endmodule
`endif
