`ifndef _MAPPER_4_ASK_REF_V_
`define _MAPPER_4_ASK_REF_V_

module mapper_4_ask_ref(input clk,
                        input clk_en,
                        input [1:0] data,
                        input signed [17:0] ref_level,
                        output reg signed [17:0] sig_out,
                        output reg signed [17:0] SYMBOL_P2,
                        output reg signed [17:0] SYMBOL_P1,
                        output reg signed [17:0] SYMBOL_N1,
                        output reg signed [17:0] SYMBOL_N2);

    always @* begin
        SYMBOL_P2 <= {{ref_level + {1'b0, ref_level[17:1]}}};
        SYMBOL_P1 <= {{1'b0, ref_level[17:1]}};
        SYMBOL_N1 <= {-{1'b0, ref_level[17:1]}};
        SYMBOL_N2 <= {-{ref_level + {1'b0, ref_level[17:1]}}};
    end

    always @*
        case(data)
            2'b00 : sig_out = SYMBOL_P2;
            2'b01 : sig_out = SYMBOL_P1;
            2'b11 : sig_out = SYMBOL_N1;
            2'b10 : sig_out = SYMBOL_N2;
        endcase

endmodule
`endif
