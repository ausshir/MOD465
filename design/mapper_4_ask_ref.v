`ifndef _MAPPER_4_ASK_REF_V_
`define _MAPPER_4_ASK_REF_V_

module mapper_4_ask_ref(input clk,
                        input clk_en,
                        input [1:0] data,
                        input signed [17:0] ref_level,
                        output reg signed [17:0] sig_out/*,
                        output reg signed [17:0] SYMBOL_P2,
                        output reg signed [17:0] SYMBOL_P1,
                        output reg signed [17:0] SYMBOL_N1,
                        output reg signed [17:0] SYMBOL_N2*/);

    // Inphase Mapping using grey code on last two bits of the symbol
    /* This is what I had before the insanity
    always @*
        case(data)
            2'b00 : sig_out = {{ref_level + {1'b0, ref_level[17:1]}}}; //3/2 * ref (+1)
            2'b01 : sig_out = {{1'b0, ref_level[17:1]}}; // 1/2 * ref (1/3)
            2'b11 : sig_out = {-{1'b0, ref_level[17:1]}}; // -1/2 * ref (-1/3)
            2'b10 : sig_out = {-{ref_level + {1'b0, ref_level[17:1]}}}; // -3/2 * ref (-1)
        endcase

    /*
    always @ *
      case(data)
        2'b11: sig_out = {-{ref_level + {1'b0, ref_level[17:1]}}}; // -3/2*r (-1)
        2'b10: sig_out = {-{1'b0, ref_level[17:1]}}; // -1/2*r                     (-1/3)
        2'b00: sig_out = { {1'b0, ref_level[17:1]}}; //  1/2*r                     (1/3)
        2'b01: sig_out = {{ref_level + {1'b0, ref_level[17:1]}}}; //  3/2*r  (+1)
        default: sig_out = 18'sd0;
    endcase
    */

    always @*
        if(data[1:0] == 2'b00)
            sig_out = {{ref_level + {1'b0, ref_level[17:1]}}}; //3/2 * ref (+1)
        else if(data[1:0] == 2'b01)
            sig_out = {{1'b0, ref_level[17:1]}}; // 1/2 * ref (1/3)
        else if(data[1:0] == 2'b11)
            sig_out = {-{1'b0, ref_level[17:1]}}; // -1/2 * ref (-1/3)
        else    // 2'b10
            sig_out = {-{ref_level + {1'b0, ref_level[17:1]}}}; // -3/2 * ref (-1)

    /*
    always @* begin
        SYMBOL_P2 = {{ref_level + {1'b0, ref_level[17:1]}}};
        SYMBOL_P1 = {{1'b0, ref_level[17:1]}};
        SYMBOL_N1 = {-{1'b0, ref_level[17:1]}};
        SYMBOL_N2 = {-{ref_level + {1'b0, ref_level[17:1]}}};
    end
    */

endmodule
`endif
