`ifndef _IMPUSE_TB_V_
`define _IMPULSE_TB_V_

`timescale 1ns/1ns

`include "../../design/clk_gen.v"
`include "../../design/srrc_gold_tx_flt.v"
`include "../../design/srrc_gold_rx_flt.v"
`include "defines.vh"

module impulse_gold_tb();

    // Clock Generation @ 40ns/25MHz
    //                  @ 160ns/6.25MHz
    //                  @ 640ns/1.5625
    reg clk_tb;
    initial begin: CLK_GEN
        clk_tb = 1;
        forever begin
            #20 clk_tb <= ~clk_tb;
        end
    end

    // Reset Generation @ 500ns
    reg reset;
    initial begin: SYS_RESET
        reset = 0;
        #1000 reset = 1;
        #880 reset = 0;
    end

    wire sys_clk, sam_clk, sym_clk, sam_clk_en, sym_clk_en;
    wire [3:0] phase;
    clk_gen clk(clk_tb, reset, sys_clk, sam_clk, sym_clk, sam_clk_en, sym_clk_en, phase);

    // Log File
    integer file;
    initial begin
        file = $fopen("impulse.csv","w");
        $fwrite(file,"time,sim_impulse_response\n");
    end

    // Impulse Generation
    reg [8:0] imp_count;
    reg signed [17:0] stimulus;
    wire signed [17:0] response;

    always @(posedge sys_clk or posedge reset) begin
        if(reset)
            imp_count = 5'b0;
        else if(sam_clk_en)
            imp_count = imp_count + 5'b1;
    end

    always @* begin
        if(imp_count == 5'h1D)
            stimulus = `SYMBOL_P2;
        else
            stimulus = 18'h0;
    end

    reg filewrite;
    always @(posedge sys_clk or posedge reset) begin
        if(reset)
            filewrite = 0;
        else if(imp_count == 5'h1D)
            filewrite = 1;
        else if(imp_count == 5'h1D && filewrite == 1) begin
            filewrite = 0;
        end
        else if(filewrite)
            $fwrite(file,"%d,%d\n", $time, response);
    end

    // Instantiate SUT
    srrc_gold_rx_flt sut(sys_clk, sam_clk_en, sym_clk_en, reset, stimulus, response);

    // end the simulation
    //initial begin
    //    #3250 $fclose("impulse.csv");
    //    $stop;
    //end

endmodule
`endif
