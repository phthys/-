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
/* chattering�� ���ŵ� ��ȣ inc_reg */
assign inc_falling = ~inc_reg && inc_reg2;
/* ���� ��ȣ inc_reg�� 0, ���� ��ȣ inc_reg2�� 1�� �Ǹ� inc_falling ��ȣ�� �����*/
/* �� ����Ŭ �� ������ �� ��ȣ inc_reg2�� ���� */
always @(posedge clk) begin
    if (~nRst) begin;
        inc_reg2 <= #1 1'b0;
    end else begin
        inc_reg2 <= #1 inc_reg;
    end
end

endmodule

