`ifndef _FLT_TEST_V_
`define _FLT_TEST_V_

module flt_test (
         input clk,
         input reset,
		   input signed [17:0] x_in,
		   output reg signed [17:0] y,
         input [4:2] SW
         );

/*
reg signed [17:0] b0, b1, b2, b3, b4, b5, b6, b7,
                  b8, b9, b10, b11, b12, b13, b14, b15;
reg signed [17:0] x0, x1, x2, x3, x4, x5, x6, x7, x8, x9,
                  x10, x11, x12, x13, x14, x15, x16, x17,
						x18, x19,
						X20, X21, X2, X2, X2, X2, X2,
						X2, X2, X2,
*/
integer i;
reg signed [17:0]	b[15:0];
reg signed [17:0]	x[30:0];
reg signed [35:0] mult_out[15:0];
reg signed [17:0] sum_level_1[15:0];
reg signed [17:0] sum_level_2[7:0];
reg signed [17:0] sum_level_3[3:0];
reg signed [17:0] sum_level_4[1:0];
reg signed [17:0] sum_level_5;


always @ (posedge clk)
x[0] = { x_in[17], x_in[17:1]}; // sign extend input

always @ (posedge clk)
begin
for(i=1; i<31;i=i+1)
x[i] <= x[i-1];
end


always @ *
for(i=0;i<=14;i=i+1)
sum_level_1[i] = x[i]+x[30-i];

always @ *
sum_level_1[15] = x[15];


// always @ (posedge clk)
always @ *
for(i=0;i<=15; i=i+1)
mult_out[i] = sum_level_1[i] * b[i];


 always @ *
for(i=0;i<=7;i=i+1)
sum_level_2[i] = mult_out[2*i][34:17] + mult_out[2*i+1][34:17];



always @ *
for(i=0;i<=3;i=i+1)
sum_level_3[i] = sum_level_2[2*i] + sum_level_2[2*i+1];



always @ *
for(i=0;i<=1;i=i+1)
sum_level_4[i] = sum_level_3[2*i] + sum_level_3[2*i+1];


always @ *
sum_level_5 = sum_level_4[0] + sum_level_4[1];

always @ (posedge clk)
    if(reset)
        y = 0;
    else
        y = sum_level_5;


always @ *
   case(SW[4:2])
      3'h0: begin // Han Window
         b[ 0] =  18'sd      0;
         b[ 1] = -18'sd     65;
         b[ 2] = -18'sd    195;
         b[ 3] =  18'sd      0;
         b[ 4] =  18'sd    881;
         b[ 5] =  18'sd   2071;
         b[ 6] =  18'sd   2249;
         b[ 7] =  18'sd      0;
         b[ 8] = -18'sd   4621;
         b[ 9] = -18'sd   9036;
         b[10] = -18'sd   8786;
         b[11] =  18'sd      0;
         b[12] =  18'sd  17661;
         b[13] =  18'sd  39628;
         b[14] =  18'sd  57935;
         b[15] =  18'sd  65060;
      end

      3'h1: begin // Kaiser-Han
         b[ 0] = -18'sd    391;
         b[ 1] = -18'sd    912;
         b[ 2] = -18'sd    976;
         b[ 3] =  18'sd      0;
         b[ 4] =  18'sd   1929;
         b[ 5] =  18'sd   3663;
         b[ 6] =  18'sd   3413;
         b[ 7] =  18'sd      0;
         b[ 8] = -18'sd   5746;
         b[ 9] = -18'sd  10519;
         b[10] = -18'sd   9726;
         b[11] =  18'sd      0;
         b[12] =  18'sd  18305;
         b[13] =  18'sd  40303;
         b[14] =  18'sd  58276;
         b[15] =  18'sd  65207;
      end

      3'h2: begin // Hamming
         b[ 0] = -18'sd    313;
         b[ 1] = -18'sd    535;
         b[ 2] = -18'sd    542;
         b[ 3] =  18'sd      0;
         b[ 4] =  18'sd   1241;
         b[ 5] =  18'sd   2577;
         b[ 6] =  18'sd   2598;
         b[ 7] =  18'sd      0;
         b[ 8] = -18'sd   4938;
         b[ 9] = -18'sd   9451;
         b[10] = -18'sd   9052;
         b[11] =  18'sd      0;
         b[12] =  18'sd  17872;
         b[13] =  18'sd  39911;
         b[14] =  18'sd  58189;
         b[15] =  18'sd  65288;
      end

      3'h3: begin // Kaiser-Hamming
         b[ 0] = -18'sd    163;
         b[ 1] = -18'sd    474;
         b[ 2] = -18'sd    585;
         b[ 3] =  18'sd      0;
         b[ 4] =  18'sd   1393;
         b[ 5] =  18'sd   2831;
         b[ 6] =  18'sd   2790;
         b[ 7] =  18'sd      0;
         b[ 8] = -18'sd   5119;
         b[ 9] = -18'sd   9683;
         b[10] = -18'sd   9195;
         b[11] =  18'sd      0;
         b[12] =  18'sd  17969;
         b[13] =  18'sd  40019;
         b[14] =  18'sd  58260;
         b[15] =  18'sd  65336;
      end

      3'h4: begin // Blackman
         b[ 0] =  18'sd      0;
         b[ 1] = -18'sd     24;
         b[ 2] = -18'sd     76;
         b[ 3] =  18'sd      0;
         b[ 4] =  18'sd    413;
         b[ 5] =  18'sd   1083;
         b[ 6] =  18'sd   1315;
         b[ 7] =  18'sd      0;
         b[ 8] = -18'sd   3317;
         b[ 9] = -18'sd   7081;
         b[10] = -18'sd   7425;
         b[11] =  18'sd      0;
         b[12] =  18'sd  16682;
         b[13] =  18'sd  38765;
         b[14] =  18'sd  57878;
         b[15] =  18'sd  65455;
      end

      3'h5: begin // Blackman-Kaiser
         b[ 0] = -18'sd     22;
         b[ 1] = -18'sd    114;
         b[ 2] = -18'sd    193;
         b[ 3] =  18'sd      0;
         b[ 4] =  18'sd    689;
         b[ 5] =  18'sd   1619;
         b[ 6] =  18'sd   1801;
         b[ 7] =  18'sd      0;
         b[ 8] = -18'sd   3979;
         b[ 9] = -18'sd   8076;
         b[10] = -18'sd   8125;
         b[11] =  18'sd      0;
         b[12] =  18'sd  17221;
         b[13] =  18'sd  39313;
         b[14] =  18'sd  58080;
         b[15] =  18'sd  65453;
      end

      3'h6: begin // Rectangular
         b[ 0] = -18'sd   3568;
         b[ 1] = -18'sd   5407;
         b[ 2] = -18'sd   4117;
         b[ 3] =  18'sd      0;
         b[ 4] =  18'sd   4866;
         b[ 5] =  18'sd   7570;
         b[ 6] =  18'sd   5947;
         b[ 7] =  18'sd      0;
         b[ 8] = -18'sd   7647;
         b[ 9] = -18'sd  12616;
         b[10] = -18'sd  10705;
         b[11] =  18'sd      0;
         b[12] =  18'sd  17842;
         b[13] =  18'sd  37849;
         b[14] =  18'sd  53527;
         b[15] =  18'sd  59453;
      end

      3'h7: begin // Pre-Lab Kaiser
         b[ 0] =  18'sd      0;
         b[ 1] =  18'sd      0;
         b[ 2] =  18'sd      0;
         b[ 3] =  18'sd      0;
         b[ 4] = -18'sd    410;
         b[ 5] =  18'sd      0;
         b[ 6] =  18'sd   1234;
         b[ 7] =  18'sd      0;
         b[ 8] = -18'sd   2822;
         b[ 9] =  18'sd      0;
         b[10] =  18'sd   5791;
         b[11] =  18'sd      0;
         b[12] = -18'sd  12234;
         b[13] =  18'sd      0;
         b[14] =  18'sd  41139;
         b[15] =  18'sd  65536;
      end
   endcase

/* for debugging
always@ *
for (i=0; i<=15; i=i+1)
if (i==15) % center coefficient
b[i] = 18'sd 131071; % almost 1 i.e. 1-2^(17)
else b[i] =18'sd0; % other than center coefficient
*/

/* for debugging
always@ *
for (i=0; i<=15; i=i+1)
 b[i] =18'sd 8192; % value of 1/16
*/
endmodule
`endif
