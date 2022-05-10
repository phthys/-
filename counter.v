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

always @(posedge clk) begin     /* 25Mhz 클럭을 1khz로 나눠준다 */
    if (cnt<12500) begin        /* cnt가 12500보다 작으면 */
        cnt <= cnt + 1;         /* cnt에 1을 더해준다 */
    end else begin              /* 12500이 되면 */
        cnt <= 0;               /* cnt값을 0으로 초기화하고 */
        clk_1khz <= ~clk_1khz;  /* 1khz 클럭의 다음 반주기를 진행한다 */ 
    end
end

endmodule
