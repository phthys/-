`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/04 05:03:36
// Design Name: 
// Module Name: timer
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


module timer(clk, nRst, inc, next, seg_dat, seg_sel);
input clk, nRst, inc, next;
output reg [7:0] seg_dat;
output reg [3:0] seg_sel;
parameter [1:0] S0 = 2'd0, S1 = 2'd1, S2 = 2'd2, S3 = 2'd3;
reg [1:0] state=0, nxt_state;
reg [3:0] seg;
reg [22:0] cnt1 = 0;
reg [22:0] cnt2 = 0;
reg [3:0] offvalue = 10;
reg [3:0] value1=0, value2=0, value3=0, value4=0, value5=0, value6=0, value7=0, value8=0;
reg [3:0] onvalue;
wire inc_falling, next_falling;
reg inc_a, next_a;
reg [3:0] dig1, dig2, dig3, dig4;
wire clk_1khz;
reg [2:0] next_cnt=0, next_cntv=0;

counter c0(.clk(clk), .clk_1khz(clk_1khz));
increase in0(.clk(clk), .nRst(nRst), .inc(inc), .inc_falling(inc_falling));
next ne0(.clk(clk), .nRst(nRst), .next(next), .next_falling(next_falling)); /* 서브모듈 호출 */

always @(*) begin           /*next_cnt가 4일 때, inc버튼과 next버튼의 입력을 무시하기 위해*/
    if (next_cnt == 4) begin/*inc_a, next_a라는 변수를 따로 선언해서, next_cnt가 4일 때는,*/
        inc_a=0;            /*inc_a와 next_a를 0으로 하고, 아닐때는 각각 inc_falling과 */
        next_a=0;           /*next_falling 신호를 넣어서 사용했다.*/
    end else begin
        inc_a=inc_falling;
        next_a=next_falling;
    end
end

always @(*) begin           /* bcd to 7segment */
    case (seg)
    0 : seg_dat = 8'b00111111;
    1 : seg_dat = 8'b00000110;
    2 : seg_dat = 8'b01011011;
    3 : seg_dat = 8'b01001111;
    4 : seg_dat = 8'b01100110;
    5 : seg_dat = 8'b01101101;
    6 : seg_dat = 8'b01111101;
    7 : seg_dat = 8'b00000111;
    8 : seg_dat = 8'b01111111;
    9 : seg_dat = 8'b01100111;
    default : seg_dat = 8'b00000000;
    endcase
end

always @(posedge clk_1khz)          /* clk_1khz가 positive edge가 되면 state에 nxt_state에 들어있는 값을 넣어 */
    if (~nRst)                      /* 다음상태로 넘어가고, nRst 버튼을 누르면 초기상태인 S0으로 돌아간다 */
        state <= S0;
    else
        state <= nxt_state;

always @(posedge clk_1khz) begin        /* clk_1khz가 positive edge일 때, */
    if (~nRst) begin                    /* nRst 버튼을 누르면 seg=0으로 초기화 시켜준다 */
        seg = 0;
    end else if (next_cnt == 4) begin   /* 그리고 next_cnt가 4일 때는 10hz로 깜빡이는 걸 없애기 위해 */
        seg = onvalue;                  /* seg에 onvalue의 값만 넣어주고, */
    end else begin
        if (cnt1<50) begin              /* 아닌 경우, cnt1을 통해 clk_1khz 신호를 10hz로 나눠서 */
            cnt1 = cnt1+1;              /* cnt1이 50보다 작을 경우, seg에 onvalue를 넣고 */
            seg = onvalue;
        end else if (cnt1<100) begin    /* 100보다 작을 경우, seg에 offvalue를 넣어서 */
            cnt1 = cnt1+1;              /* 10hz, 50% duty cycle로 깜빡이도록 해줬다 */
            seg = offvalue;
        end else begin                  /* cnt1이 100이 넘으면 0으로 초기화 한다 */
            cnt1= 0;
        end
    end
end

always @(posedge clk_1khz) begin        /* clk_1khz가 positive edge일 때, */
    case (state)
    S0 : begin                          /* state가 S0 상태면 */
        seg_sel <= 4'b0111;             /* seg_sel에 4'b0111을 넣어 digit1의 숫자를 켜준다 */
        end
    S1 : begin                          /* state가 S1 상태면 */
        seg_sel <= 4'b1011;             /* seg_sel에 4'b1011을 넣어 digit2의 숫자를 켜준다 */
        end
    S2 : begin                          /* state가 S2 상태면 */
        seg_sel <= 4'b1101;             /* seg_sel에 4'b1101을 넣어 digit3의 숫자를 켜준다 */
        end
    S3 : begin                          /* state가 S3 상태면 */
        seg_sel <= 4'b1110;             /* seg_sel에 4'b1110을 넣어 digit4의 숫자를 켜준다 */
        end
    endcase                             /* 이를 반복하여 dynamic display를 구현했다 */
end

always @(*) begin
    case (state)
        S0 : onvalue <= dig1;           /* state가 S0 상태면 onvalue에 dig1의 값을 넣는다 */
        S1 : onvalue <= dig2;           /* state가 S1 상태면 onvalue에 dig2의 값을 넣는다 */
        S2 : onvalue <= dig3;           /* state가 S2 상태면 onvalue에 dig3의 값을 넣는다 */ 
        S3 : onvalue <= dig4;           /* state가 S3 상태면 onvalue에 dig4의 값을 넣는다 */
    endcase                             /* 그리고 onvalue의 값이 seg에 들어가서 출력 되므로, 상태에 맞춰서 */
end                                     /* dig1의 값이 digit1에, dig2의 값이 digit2에, dig3의 값이 digit3에,
                                           dig4의 값이 digit4에 들어가 출력 된다 */
    
always @(*) begin
    nxt_state = 2'bx;
    case (state)
    S0 : begin                  /* state가 S0 상태면, 다음 상태 nxt_state에 S1을 넣는다 */
        nxt_state = S1;
    end
    S1 : begin                  /* state가 S1 상태면, 다음 상태 nxt_state에 S2을 넣는다 */
        nxt_state = S2;
    end
    S2 : begin                  /* state가 S2 상태면, 다음 상태 nxt_state에 S3을 넣는다 */
        nxt_state = S3;
    end    
    S3 : begin                  /* state가 S3 상태면, 다음 상태 nxt_state에 S0을 넣는다 */
        nxt_state = S0;
    end
    endcase
end

always @(posedge clk) begin     /* clk이 posedge일 때, */
    if (~nRst) begin            /* nRst 버튼을 누르면 next_cnt를 초기상태 0으로 초기화 시킨다 */
        next_cnt <= #1 0;
    end else if (next_cnt == 4) begin
        if (value5==0 && value6==0 && value7==0 && value8==0) begin
            next_cnt <= #1 0;   /* next_cnt가 4일 때, digit1~4에 출력되있는 숫자가 모두 0이 되면 */
        end                     /* next_cnt는 초기상태 0이 된다 */
    end else
        next_cnt <= #1 next_cntv;   /* 위 조건에 해당하지 않으면, next_cnt에 next_cntv의 값을 넣는다 */
end

always @(*) begin
    if (next_a) begin               /* next_a 신호가 들어오면 */
        next_cntv <= next_cnt+1;    /* next_cntv에 next_cnt에 1을 더한 값을 넣는다 */
    end else
        next_cntv <= next_cnt;      /* 아니면 next_cntv에 next_cnt의 값을 넣는다 */
end
/* 위의 두 always 블록에서, next 버튼을 눌러 next_a 신호가 들어오면 먼저 next_cntv에 next_cnt+1 값이 들어가고,
그 다음에 clk가 positive edge가 되면 next_cnt에 next_cntv (next_cnt+1이 된 값)이 들어가게 된다 */

always @(*) begin
    if (~nRst) begin    /* nRst 버튼을 누르면 dig1~4를 0으로 초기화시킨다 */
        dig1 <= #1 0;
        dig2 <= #1 0;
        dig3 <= #1 0;
        dig4 <= #1 0;
    end else begin
        if (next_cnt == 4) begin    /* next_cnt가 4일 때는, value 5~8의 값을 각각 dig1~4에 넣는다 */
            dig1 <= #1 value5;
            dig2 <= #1 value6;
            dig3 <= #1 value7;
            dig4 <= #1 value8;
        end else begin              /* 그 외의 경우, value 1~4의 값을 각각 dig1~4에 넣는다 */
            dig1 <= #1 value1;
            dig2 <= #1 value2;
            dig3 <= #1 value3;
            dig4 <= #1 value4;
        end                         /* dig1~4의 값의 onvalue에 들어가고 그 값이 seg로 넘어가서 */
    end                             /* 결국 dig1~4에 해당하는 값이 state 상태에 따라 나뉘어 seg에 들어가서 */ 
end                                 /* 각각 digit1~4에 출력이 되는 것이다 */

always @(posedge clk) begin                 /* clk가 positive edge 일 때 */
    if (inc_a) begin                        /* inc버튼을 눌러 inc_a 신호가 들어오면 */
        if (next_cnt == 0) begin            /* next_cnt가 0일 때 value1에 dig1+1의 값을 넣고 */
            value1 = dig1>=9 ? 0 : dig1+1;  /* dig1이 9보다 크거나 같으면 0을 넣는다 */
        end else if (next_cnt == 1) begin   /* next_cnt가 1일 때 value2에 dig2+1의 값을 넣고 */
            value2 = dig2>=9 ? 0 : dig2+1;  /* dig2가 9보다 크거나 같으면 0을 넣는다 */
        end else if (next_cnt == 2) begin   /* next_cnt가 2일 때 value3에 dig3+1의 값을 넣고 */
            value3 = dig3>=9 ? 0 : dig3+1;  /* dig3이 9보다 크거나 같으면 0을 넣는다 */
        end else if (next_cnt == 3) begin   /* next_cnt가 3일 때 value4에 dig4+1의 값을 넣고 */
            value4 = dig4>=9 ? 0 : dig4+1;  /* dig4가 9보다 크거나 같으면 0을 넣는다 */
        end               
    end else begin          /* 그 외에 inc 버튼을 누르지 않으면, value1~4에 각각 dig1~4의 값을 넣는다 */
        value1=dig1;
        value2=dig2;
        value3=dig3;
        value4=dig4;
    end
end
/* 위의 두 always 블록 에서는 먼저 아래 블록의 clk이 positive edge일 때, value1~4에 dig1~4에 1을 더한 값이 들어가고,
위 블록은 항상, dig1~4에 value1~4의 값이 들어가기 떄문에, value1~4의 값이 증가하는 동시에 dig1~4의 값이 1 증가한다. */


always @(posedge clk_1khz) begin    /* clk_1khz가 positive edge 일 때 */
    if (~nRst) begin                /* nRst 버튼을 누르면 value5~8을 0으로 초기화 시킨다 */
        value5=0;
        value6=0;
        value7=0;
        value8=0;
    end else if (next_cnt == 4) begin   /* next_cnt가 4일 때, */
        if (cnt2<=100) begin            /* cnt2로 clk_1khz를 10hz로 나눠준다 */
            cnt2=cnt2+1;                /* cnt2가 100보다 작으면 cnt2에 1을 더해주고 */
        end else begin
            cnt2=0;                     /* cnt2가 100보다 커지면 cnt2를 0으로 초기화하고 */
            value8=dig4-1;              /* value8에 dig4에서 1을 뺀 값을 넣어준다 */
            if (value8>9) begin         /* 위 내욜을 반복하다 value8이 9보다 커지면 (4'hF가 되면) */
                value8=9;               /* value8을 9로 만들고, value7에 dig3에서 1을 뺀 값을 넣어준다 */
                value7=dig3-1;
            end
            if (value7>9) begin         /* 또, 위의 내용을 반복하다 value7이 9보다 커지면 */
                value7=9;               /* value7을 9로 만들고, value6에 dig2에서 1을 뺀 값을 넣어준다 */
                value6=dig2-1;
            end
            if (value6>9) begin         /* 위의 내용들을 반복하다 value 6이 9보다 커지면 */
                value6=9;               /* value6을 9로 만들고, value5에 dig1에서 1을 뺀 값을 넣어준다 */
                value5=dig1-1;
            end
        end
    end else begin                      /* next_cnt가 4가 아닐 땐 */
        value5 = value1;                /* value5~8 에 value1~4 에 들어 있는 값을 각각 넣어준다 */
        value6 = value2;
        value7 = value3;
        value8 = value4;
    end
end
/* value 5~8은 next_cnt가 0~3일땐 value1~4의 값을 받아오기만 하고,
next_cnt가 4가 되면 value1~4가 하던 역할을 대신 하게 된다.
value 5~8의 값이 모두 감소해서 0이 되면 
dig1~4에 value5~8의 값인 0이 들어가게 되고, next_cnt도 0으로 초기화 되고,
dig1~4에 들어간 0이 value1~4에 들어가게 되서 값이 초기화 된다. */
endmodule

