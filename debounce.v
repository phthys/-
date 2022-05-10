`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/09 20:04:14
// Design Name: 
// Module Name: debounce
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


module debounce(input clk, nRst, button_in, output reg DB_out);

parameter N = 11; /*ī������ ����� �����ϱ� ���� ���� */
reg [N-1:0] q_reg;
reg [N-1:0] q_next; /*11��Ʈ ī����*/
reg DFF1, DFF2;
wire q_add;
wire q_reset;

assign q_reset = (DFF1^DFF2);   /*D flip flop �ΰ��� xor ���� ���� ��ȣ�� ���� */
assign q_add = ~(q_reg[N-1]);   /*�ֻ��� ��Ʈ�� 0�� ��, �� ���ϴ� ���� �������� �������� add��ȣ�� ���� */

always @ (*) begin
    case( {q_reset , q_add})
        2'b00: q_next = q_reg;  /*q_reset ��ȣ�� 0�̰� q_add ��ȣ�� 0�̸� ���� ī���ʹ� ���簪�� �����ϰ� */
        2'b01: q_next = q_reg + 1;  /* q_reset�� 0�̰� q_add ��ȣ�� 1�� �Ǹ� ���� ī���� ���� 1�� ���ؼ� ���� ī���� ���� �ִ´�*/
        default : q_next = { N {1'b0} };    /*q_reset�� 1�̸� ī���� ���� 0���� �ʱ�ȭ */
    endcase
end

always @(posedge clk) begin
    if(nRst == 1'b0) begin  /* nRst ��ư�� ������ */
        DFF1 <= 1'b0;
        DFF2 <= 1'b0;       /*flip flop ���� �ʱ�ȭ �ϰ� */
        q_reg <= { N {1'b0} };  /*ī���� ���� �ʱ�ȭ �Ѵ� */
    end else begin
        DFF1 <= button_in;  /* ��ư �Է��� ������ �� Ŭ������ DFF1�� ����� */
        DFF2 <= DFF1;       /* ���� ����Ŭ�� ����� DFF2�� ���� �ȴ� */
        q_reg <= q_next;    /* q_add ��ȣ�� q_add ��ȣ�� ���� ������ ���� ī���� ���� ���� ī���Ϳ� �ִ´� */
    end
end

always @(posedge clk) begin
    if(q_reg[N-1] == 1'b1)  /* �ֻ��� ��Ʈ�� 1�� �Ǹ� */
        DB_out <= DFF2;     /* DFF2�� ���� ������� �������� */
    else
        DB_out <= DB_out;   /* �ƴϸ� ������ ���� �����Ѵ� */
    end
endmodule
