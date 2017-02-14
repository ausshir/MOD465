`ifndef _CLK_GEN_V
`define _CLK_GEN_V

// Generates system, sample and symbol clocks and clock enables needed for all
//  communications modules
// NOTE: clk_in is usually defined as 50MHz from an external crystal
//     and derivative clocks are 25, 6.25 and 1.5625 MHz

module clk_gen( input clk_in,
                input reset,
                output reg sys_clk,
                output sam_clk,
                output sym_clk,
                output sam_clk_ena,
                output sym_clk_ena,
                output [3:0] clk_phase );

    reg [4:0] down_count;

    always @(posedge clk_in, reset)
        if(reset)
            sys_clk = 0;
        else
            sys_clk = ~sys_clk;

    always @(posedge clk_in, reset)
        if(reset)
            down_count = 4'b1111;
        else
            down_count = down_count - 1;

    assign sam_clk = down_count[2];
    assign sym_clk = down_count[4];
    assign clk_phase = ~(down_count[4:1]);

    assign sym_clk_ena = (clk_phase == 4'd15);
    assign sam_clk_ena = (clk_phase == 4'd3 ||
                          clk_phase == 4'd7 ||
                          clk_phase == 4'd11||
                          clk_phase == 4'd15);

endmodule
`endif
