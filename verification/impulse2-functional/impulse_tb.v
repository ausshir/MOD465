`ifndef _IMPUSE_TB_V_
`define _IMPULSE_TB_V_

`timescale 1ns/1ns
`include "../../design/srrc_tx_lut_flt.v"

module impulse_tb();

    // Clock Generation @ 160ns/6.25MHz
    //                  @ 640ns/1.5625
    reg clk_tb;
    initial begin: CLK_GEN
        clk_tb = 1;
        forever begin
            #80 clk_tb <= ~clk_tb;
        end
    end

    reg clk_sym;
    initial begin: SYM_GEN
        clk_sym = 1;
        forever begin
             #320 clk_sym <= ~clk_sym;
        end
    end

    // Reset Generation @ 500ns
    reg reset;
    initial begin: SYS_RESET
        reset = 0;
        #1000 reset = 1;
        #880 reset = 0;
    end

    // Log File
    integer file;
    initial begin
        file = $fopen("impulse.csv","w");
        $fwrite(file,"time,sim_impulse_response\n");
    end

    // Impulse Generation
    reg [4:0] imp_count;
    reg signed [17:0] stimulus;
    wire signed [17:0] response;

    always @(posedge clk_tb) begin
        if(reset)
            imp_count = 5'b0;
        else
            imp_count = imp_count + 5'b1;
    end

    always @* begin
        if(imp_count == 5'h1D)
            stimulus = 18'b01_1111_1111_1111_1111; //full-scale signed
        else
            stimulus = 18'h0;
    end

    reg filewrite;
    always @(posedge clk_tb) begin
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
    srrc_tx_lut_flt sut(clk_tb, reset, clk_sym, stimulus, response);

    // end the simulation
    //initial begin
    //    #3250 $fclose("impulse.csv");
    //    $stop;
    //end

endmodule
`endif
