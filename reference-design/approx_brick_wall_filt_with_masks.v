module approx_brick_wall_filt_with_masks (
         input clk,
			input [17:0] data_mask, coef_mask,
		   input signed [17:0] x_in,
		   output reg signed [17:0] y   );

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
mult_out[i] = sum_level_1[i] * $signed( b[i] & coef_mask );


 always @ *
for(i=0;i<=7;i=i+1)
sum_level_2[i] = (mult_out[2*i][34:17] + mult_out[2*i+1][34:17])
                  & data_mask;



always @ *
for(i=0;i<=3;i=i+1)
sum_level_3[i] = sum_level_2[2*i] + sum_level_2[2*i+1];



always @ *
for(i=0;i<=1;i=i+1)
sum_level_4[i] = sum_level_3[2*i] + sum_level_3[2*i+1];


always @ *
sum_level_5 = sum_level_4[0] + sum_level_4[1];

always @ (posedge clk)
y = sum_level_5;


always @ *
   begin
   b[0] =  -18'sd   3566;
   b[1] =  -18'sd   5403;
   b[2] =  -18'sd   4114;
   b[3] =   18'sd      0;
   b[4] =   18'sd   4863;
   b[5] =   18'sd   7564;
   b[6] =   18'sd   5943;
   b[7] =   18'sd      0;
   b[8] =  -18'sd   7641;
   b[9] =  -18'sd  12607;
   b[10] = -18'sd  10698;
   b[11] =  18'sd      0;
   b[12] =  18'sd  17829;
   b[13] =  18'sd  37822;
   b[14] =  18'sd  53488;
   b[15]=   18'sd  59411;
   end




endmodule
