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
/* chattering�� ���ŵ� ��ȣ next_reg */
assign next_falling = ~next_reg && next_reg2;
/* ���� ��ȣ next_reg�� 0, ���� ��ȣ next_reg2�� 1�� �Ǹ� next_falling ��ȣ�� �����*/
/* �� ����Ŭ �� ������ �� ��ȣ next_reg2�� ���� */
always @(posedge clk) begin
    if (~nRst) begin;
        next_reg2 <= #1 1'b0;
    end else begin
        next_reg2 <= #1 next_reg;
    end
end

endmodule
