`ifndef _MER_CALC_LUT_V_
`define _MER_CALC_LUT_V_

// Uses a LUT to calculate log10( mapper_power / error_power )
//  Can take in a range 1000-3048 (even only) (10-bits) for mapper_power
//  And a range of 0-256 (8-bits) for error_power
//  Giving a total LUT size of 18-bits
//  NOTE: All 1's (-1 signed) is an error output

`include "defines.vh"


module mer_calc_lut(input clk,
                    input clk_en,
                    input reset, // clear accumulators
                    input signed [17:0] mapper_power,
                    input signed [17:0] error_power,
                    output reg signed [6:0] approx_mer);

    reg signed [17:0] mapper_power_10_baseline;
    reg [9:0] mapper_power_10;
    reg [7:0] error_power_8;
    reg [17:0] lut_index;
    always @(posedge clk) begin
        mapper_power_10_baseline = mapper_power - 1000;
    end

    always @(posedge clk) begin
        mapper_power_10 <= mapper_power_10_baseline[10:1];
        error_power_8 <= error_power[7:0];
    end

    always @(posedge clk) begin
        lut_index = {{mapper_power_10},{error_power_8}};
    end

    always @(posedge clk)
        if(reset)
            approx_mer = 0;
        else if(clk_en)
            if((mapper_power > 18'sd3046) ||
               (mapper_power < 18'sd1000) ||
               (error_power > 18'sd254) ||
               (error_power < 18'sd1)) begin
                approx_mer = -7'sd1;
            end
            else begin
                case(lut_index)
                    `include "mer_lut.txt"
                    default: approx_mer = -7'sd1;
					 endcase
            end

endmodule
`endif
