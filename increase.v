`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/05 13:56:27
// Design Name: 
// Module Name: increase
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


module increase(input clk, input nRst, input inc, output inc_falling);
wire inc_reg, inc_falling;
reg inc_reg2;

debounce db0(.clk(clk), .nRst(nRst), .button_in(inc), .DB_out(inc_reg) );
/* chattering이 제거된 신호 inc_reg */
assign inc_falling = ~inc_reg && inc_reg2;
/* 현재 신호 inc_reg가 0, 이전 신호 inc_reg2가 1이 되면 inc_falling 신호를 만든다*/
/* 한 사이클 더 딜레이 된 신호 inc_reg2를 만듬 */
always @(posedge clk) begin
    if (~nRst) begin;
        inc_reg2 <= #1 1'b0;
    end else begin
        inc_reg2 <= #1 inc_reg;
    end
end

endmodule

