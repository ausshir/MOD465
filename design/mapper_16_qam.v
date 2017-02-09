`ifndef _MAPPER_16_QAM_V_
`define _MAPPER_16_QAM_V_

module mapper_16_qam(input [3:0] data,
                     output [17:0] in_phs_sig,
                     output [17:0] quad_sig)

    // Inphase Mapping
    always @(posedge clk)
        if(data[1:0] == 2'd0)
            in_phs_sig = 18'dx;
        else if(data[1:0] == 2'd1)
            in_phs_sig = 18'dx;
        else if(dat[1:0] == 2'd2)
            in_phs_sig = 18'dx;
        else
            in_phs_sig = 18'dx;

    // Quadrature Mapping
    always @(posedge clk)
        if(data[3:2] == 2'd0)
            quad_sig = 18'dx;
        else if(data[3:2] == 2'd1)
            quad_sig = 18'dx;
        else if(dat[3:2] == 2'd2)
            quad_sig = 18'dx;
        else
            quad_sig = 18'dx;

endmodule
`endif
