`ifndef _MAPPER_16_QAM_V_
`define _MAPPER_16_QAM_V_

`include "defines.vh"

module mapper_16_qam_ref(input clk,
                           input clk_en,
                           input [3:0] data,
                           input signed [17:0] ref_level,
                           output reg signed [17:0] sig_inph,
                           output reg signed [17:0] sig_quad);

    reg signed [17:0] SYMBOL_P2, SYMBOL_P1, SYMBOL_N1, SYMBOL_N2;
    always @* begin
        SYMBOL_P2 <= {{ref_level + {1'b0, ref_level[17:1]}}};
        SYMBOL_P1 <= {{1'b0, ref_level[17:1]}};
        SYMBOL_N1 <= {-{1'b0, ref_level[17:1]}};
        SYMBOL_N2 <= {-{ref_level + {1'b0, ref_level[17:1]}}};
    end

    // Inphase Mapping using grey code on last two bits of the symbol
    always @*
        case(data[`INPHASE])
            2'b00 : sig_inph = SYMBOL_P2;
            2'b01 : sig_inph = SYMBOL_P1;
            2'b11 : sig_inph = SYMBOL_N1;
            2'b10 : sig_inph = SYMBOL_N2;
        endcase

    // Quadrature Mapping using grey code on first two bits of the symbol
    always @*
        case(data[`QUADRATURE])
            2'b00 : sig_quad = SYMBOL_P2;
            2'b01 : sig_quad = SYMBOL_P1;
            2'b11 : sig_quad = SYMBOL_N1;
            2'b10 : sig_quad = SYMBOL_N2;
        endcase

endmodule
`endif
