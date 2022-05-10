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

parameter N = 11; /*카운터의 사이즈를 결정하기 위해 선언 */
reg [N-1:0] q_reg;
reg [N-1:0] q_next; /*11비트 카운터*/
reg DFF1, DFF2;
wire q_add;
wire q_reset;

assign q_reset = (DFF1^DFF2);   /*D flip flop 두개를 xor 시켜 리셋 신호를 만듬 */
assign q_add = ~(q_reg[N-1]);   /*최상위 비트가 0일 때, 즉 원하는 값에 도달하지 못했을때 add신호를 만듬 */

always @ (*) begin
    case( {q_reset , q_add})
        2'b00: q_next = q_reg;  /*q_reset 신호가 0이고 q_add 신호가 0이면 다음 카운터는 현재값을 유지하고 */
        2'b01: q_next = q_reg + 1;  /* q_reset이 0이고 q_add 신호가 1이 되면 현재 카운터 값에 1을 더해서 다음 카운터 값에 넣는다*/
        default : q_next = { N {1'b0} };    /*q_reset이 1이면 카운터 값을 0으로 초기화 */
    endcase
end

always @(posedge clk) begin
    if(nRst == 1'b0) begin  /* nRst 버튼을 누르면 */
        DFF1 <= 1'b0;
        DFF2 <= 1'b0;       /*flip flop 값을 초기화 하고 */
        q_reg <= { N {1'b0} };  /*카운터 값도 초기화 한다 */
    end else begin
        DFF1 <= button_in;  /* 버튼 입력을 받으면 매 클럭마다 DFF1을 만들고 */
        DFF2 <= DFF1;       /* 다음 사이클의 출력이 DFF2로 들어가게 된다 */
        q_reg <= q_next;    /* q_add 신호와 q_add 신호에 의해 결정된 다음 카운터 값을 현재 카운터에 넣는다 */
    end
end

always @(posedge clk) begin
    if(q_reg[N-1] == 1'b1)  /* 최상위 비트가 1이 되면 */
        DB_out <= DFF2;     /* DFF2의 값을 출력으로 내보내고 */
    else
        DB_out <= DB_out;   /* 아니면 현재의 값을 유지한다 */
    end
endmodule
