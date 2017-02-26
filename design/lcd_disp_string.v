module LCD_display_string(index,out,hex0,hex1);
input [4:0] index;
input [3:0] hex0,hex1;
output [7:0] out;
reg [7:0] out;
// ASCII hex values for LCD Display
// Enter Live Hex Data Values from hardware here
// LCD DISPLAYS THE FOLLOWING:
//----------------------------
//| Count=XX                  |
//| DE2                       |
//----------------------------
// Line 1
   always
     case (index)
    5'h00: out <= 8'h43;
    5'h01: out <= 8'h6F;
    5'h02: out <= 8'h75;
    5'h03: out <= 8'h6E;
    5'h04: out <= 8'h74;
    5'h05: out <= 8'h3D;
    5'h06: out <= {4'h0,hex1};
    5'h07: out <= {4'h0,hex0};
// Line 2
    5'h10: out <= 8'h44;
    5'h11: out <= 8'h45;
    5'h12: out <= 8'h32;
    default: out <= 8'h20;
     endcase
endmodule
