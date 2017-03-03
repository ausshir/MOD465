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

    always @(posedge clk_in or posedge reset)
        if(reset)
            sys_clk = 0;
        else
            sys_clk = ~sys_clk;

    always @(negedge sys_clk or posedge reset)
        if(reset)
            down_count = 3'b111;
        else
            down_count = down_count - 3'b1;

    assign sam_clk = down_count[1];
    assign sym_clk = down_count[3];
    assign clk_phase = ~(down_count[3:0]);

    assign sym_clk_ena = (clk_phase == 4'd15);
    assign sam_clk_ena = (clk_phase == 4'd3 ||
                          clk_phase == 4'd7 ||
                          clk_phase == 4'd11||
                          clk_phase == 4'd15);

/*
    reg [4:0] clk_acc;
    always @ (posedge clk_in or posedge reset)
        if(reset)
            clk_acc = 5'd0;
        else
            clk_acc = clk_acc - 5'd1;

    assign sys_clk = clk_acc[0];
    assign sam_clk = clk_acc[2];
    assign sym_clk = clk_acc[4];
    assign clk_phase = ~clk_acc[4:1];
    assign sam_clk_ena = &clk_phase[1:0];
    assign sym_clk_ena = &clk_phase;

*/

endmodule
`endif
