`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/05 19:38:33
// Design Name: 
// Module Name: next
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


module next(input clk, input nRst, input next, output next_falling);
wire next_reg, next_falling;
reg next_reg2;

debounce db1(.clk(clk), .nRst(nRst), .button_in(next), .DB_out(next_reg) );
/* chattering이 제거된 신호 next_reg */
assign next_falling = ~next_reg && next_reg2;
/* 현재 신호 next_reg가 0, 이전 신호 next_reg2가 1이 되면 next_falling 신호를 만든다*/
/* 한 사이클 더 딜레이 된 신호 next_reg2를 만듬 */
always @(posedge clk) begin
    if (~nRst) begin;
        next_reg2 <= #1 1'b0;
    end else begin
        next_reg2 <= #1 next_reg;
    end
end

endmodule
