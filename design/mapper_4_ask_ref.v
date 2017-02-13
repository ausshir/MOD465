`ifndef _MAPPER_4_ASK_REF_V_
`define _MAPPER_4_ASK_REF_V_

module mapper_4_ask_ref(input clk,
                        input clk_en,
                        input [3:0] data,
                        input signed [17:0] ref_level;
                        output signed reg [17:0] in_phs_sig);

    // Inphase Mapping using grey code on last two bits of the symbol
    always @*
        if(data[1:0] == 2'b00)
            in_phs_sig = {{reference_level + {1'b0, ref_level[17:1]}}}; //3/2 * ref (+1)
        else if(data[1:0] == 2'b01)
            in_phs_sig = {{1'b0, ref_level[17:1]}}; // 1/2 * ref (1/3)
        else if(data[1:0] == 2'b11)
            in_phs_sig = {-{1'b0, reference_level[17:1]}}; // -1/2 * ref (-1/3)
        else // 2'b10
            in_phs_sig = {-{reference_level + {1'b0, ref_level[17:1]}}}; // -3/2 * ref (-1)

endmodule
`endif
