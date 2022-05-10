`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/09 20:05:49
// Design Name: 
// Module Name: bcd_to_7seg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module bcd_to_7seg(x, seg);

input [3:0] x;
output reg [7:0] seg;

always @(*) begin
    case(x)
        4'b0000 : seg = 8'b00111111;
        4'b0001 : seg = 8'b00000110;
        4'b0010 : seg = 8'b01011011;
        4'b0011 : seg = 8'b01001111;
        4'b0100 : seg = 8'b01100110;
        4'b0101 : seg = 8'b01101101;
        4'b0110 : seg = 8'b01111101;
        4'b0111 : seg = 8'b00000111;
        4'b1000 : seg = 8'b01111111;
        4'b1001 : seg = 8'b01100111;
        default : seg = 8'b00000000;
    endcase
end
endmodule