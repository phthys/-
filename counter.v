`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/09 20:03:19
// Design Name: 
// Module Name: counter
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


module counter(input clk, output clk_1khz);
reg [14:0] cnt=0; 
reg clk_1khz=0;

always @(posedge clk) begin     /* 25Mhz Ŭ���� 1khz�� �����ش� */
    if (cnt<12500) begin        /* cnt�� 12500���� ������ */
        cnt <= cnt + 1;         /* cnt�� 1�� �����ش� */
    end else begin              /* 12500�� �Ǹ� */
        cnt <= 0;               /* cnt���� 0���� �ʱ�ȭ�ϰ� */
        clk_1khz <= ~clk_1khz;  /* 1khz Ŭ���� ���� ���ֱ⸦ �����Ѵ� */ 
    end
end

endmodule
