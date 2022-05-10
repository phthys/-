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
next ne0(.clk(clk), .nRst(nRst), .next(next), .next_falling(next_falling)); /* ������ ȣ�� */

always @(*) begin           /*next_cnt�� 4�� ��, inc��ư�� next��ư�� �Է��� �����ϱ� ����*/
    if (next_cnt == 4) begin/*inc_a, next_a��� ������ ���� �����ؼ�, next_cnt�� 4�� ����,*/
        inc_a=0;            /*inc_a�� next_a�� 0���� �ϰ�, �ƴҶ��� ���� inc_falling�� */
        next_a=0;           /*next_falling ��ȣ�� �־ ����ߴ�.*/
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

always @(posedge clk_1khz)          /* clk_1khz�� positive edge�� �Ǹ� state�� nxt_state�� ����ִ� ���� �־� */
    if (~nRst)                      /* �������·� �Ѿ��, nRst ��ư�� ������ �ʱ������ S0���� ���ư��� */
        state <= S0;
    else
        state <= nxt_state;

always @(posedge clk_1khz) begin        /* clk_1khz�� positive edge�� ��, */
    if (~nRst) begin                    /* nRst ��ư�� ������ seg=0���� �ʱ�ȭ �����ش� */
        seg = 0;
    end else if (next_cnt == 4) begin   /* �׸��� next_cnt�� 4�� ���� 10hz�� �����̴� �� ���ֱ� ���� */
        seg = onvalue;                  /* seg�� onvalue�� ���� �־��ְ�, */
    end else begin
        if (cnt1<50) begin              /* �ƴ� ���, cnt1�� ���� clk_1khz ��ȣ�� 10hz�� ������ */
            cnt1 = cnt1+1;              /* cnt1�� 50���� ���� ���, seg�� onvalue�� �ְ� */
            seg = onvalue;
        end else if (cnt1<100) begin    /* 100���� ���� ���, seg�� offvalue�� �־ */
            cnt1 = cnt1+1;              /* 10hz, 50% duty cycle�� �����̵��� ����� */
            seg = offvalue;
        end else begin                  /* cnt1�� 100�� ������ 0���� �ʱ�ȭ �Ѵ� */
            cnt1= 0;
        end
    end
end

always @(posedge clk_1khz) begin        /* clk_1khz�� positive edge�� ��, */
    case (state)
    S0 : begin                          /* state�� S0 ���¸� */
        seg_sel <= 4'b0111;             /* seg_sel�� 4'b0111�� �־� digit1�� ���ڸ� ���ش� */
        end
    S1 : begin                          /* state�� S1 ���¸� */
        seg_sel <= 4'b1011;             /* seg_sel�� 4'b1011�� �־� digit2�� ���ڸ� ���ش� */
        end
    S2 : begin                          /* state�� S2 ���¸� */
        seg_sel <= 4'b1101;             /* seg_sel�� 4'b1101�� �־� digit3�� ���ڸ� ���ش� */
        end
    S3 : begin                          /* state�� S3 ���¸� */
        seg_sel <= 4'b1110;             /* seg_sel�� 4'b1110�� �־� digit4�� ���ڸ� ���ش� */
        end
    endcase                             /* �̸� �ݺ��Ͽ� dynamic display�� �����ߴ� */
end

always @(*) begin
    case (state)
        S0 : onvalue <= dig1;           /* state�� S0 ���¸� onvalue�� dig1�� ���� �ִ´� */
        S1 : onvalue <= dig2;           /* state�� S1 ���¸� onvalue�� dig2�� ���� �ִ´� */
        S2 : onvalue <= dig3;           /* state�� S2 ���¸� onvalue�� dig3�� ���� �ִ´� */ 
        S3 : onvalue <= dig4;           /* state�� S3 ���¸� onvalue�� dig4�� ���� �ִ´� */
    endcase                             /* �׸��� onvalue�� ���� seg�� ���� ��� �ǹǷ�, ���¿� ���缭 */
end                                     /* dig1�� ���� digit1��, dig2�� ���� digit2��, dig3�� ���� digit3��,
                                           dig4�� ���� digit4�� �� ��� �ȴ� */
    
always @(*) begin
    nxt_state = 2'bx;
    case (state)
    S0 : begin                  /* state�� S0 ���¸�, ���� ���� nxt_state�� S1�� �ִ´� */
        nxt_state = S1;
    end
    S1 : begin                  /* state�� S1 ���¸�, ���� ���� nxt_state�� S2�� �ִ´� */
        nxt_state = S2;
    end
    S2 : begin                  /* state�� S2 ���¸�, ���� ���� nxt_state�� S3�� �ִ´� */
        nxt_state = S3;
    end    
    S3 : begin                  /* state�� S3 ���¸�, ���� ���� nxt_state�� S0�� �ִ´� */
        nxt_state = S0;
    end
    endcase
end

always @(posedge clk) begin     /* clk�� posedge�� ��, */
    if (~nRst) begin            /* nRst ��ư�� ������ next_cnt�� �ʱ���� 0���� �ʱ�ȭ ��Ų�� */
        next_cnt <= #1 0;
    end else if (next_cnt == 4) begin
        if (value5==0 && value6==0 && value7==0 && value8==0) begin
            next_cnt <= #1 0;   /* next_cnt�� 4�� ��, digit1~4�� ��µ��ִ� ���ڰ� ��� 0�� �Ǹ� */
        end                     /* next_cnt�� �ʱ���� 0�� �ȴ� */
    end else
        next_cnt <= #1 next_cntv;   /* �� ���ǿ� �ش����� ������, next_cnt�� next_cntv�� ���� �ִ´� */
end

always @(*) begin
    if (next_a) begin               /* next_a ��ȣ�� ������ */
        next_cntv <= next_cnt+1;    /* next_cntv�� next_cnt�� 1�� ���� ���� �ִ´� */
    end else
        next_cntv <= next_cnt;      /* �ƴϸ� next_cntv�� next_cnt�� ���� �ִ´� */
end
/* ���� �� always ��Ͽ���, next ��ư�� ���� next_a ��ȣ�� ������ ���� next_cntv�� next_cnt+1 ���� ����,
�� ������ clk�� positive edge�� �Ǹ� next_cnt�� next_cntv (next_cnt+1�� �� ��)�� ���� �ȴ� */

always @(*) begin
    if (~nRst) begin    /* nRst ��ư�� ������ dig1~4�� 0���� �ʱ�ȭ��Ų�� */
        dig1 <= #1 0;
        dig2 <= #1 0;
        dig3 <= #1 0;
        dig4 <= #1 0;
    end else begin
        if (next_cnt == 4) begin    /* next_cnt�� 4�� ����, value 5~8�� ���� ���� dig1~4�� �ִ´� */
            dig1 <= #1 value5;
            dig2 <= #1 value6;
            dig3 <= #1 value7;
            dig4 <= #1 value8;
        end else begin              /* �� ���� ���, value 1~4�� ���� ���� dig1~4�� �ִ´� */
            dig1 <= #1 value1;
            dig2 <= #1 value2;
            dig3 <= #1 value3;
            dig4 <= #1 value4;
        end                         /* dig1~4�� ���� onvalue�� ���� �� ���� seg�� �Ѿ�� */
    end                             /* �ᱹ dig1~4�� �ش��ϴ� ���� state ���¿� ���� ������ seg�� ���� */ 
end                                 /* ���� digit1~4�� ����� �Ǵ� ���̴� */

always @(posedge clk) begin                 /* clk�� positive edge �� �� */
    if (inc_a) begin                        /* inc��ư�� ���� inc_a ��ȣ�� ������ */
        if (next_cnt == 0) begin            /* next_cnt�� 0�� �� value1�� dig1+1�� ���� �ְ� */
            value1 = dig1>=9 ? 0 : dig1+1;  /* dig1�� 9���� ũ�ų� ������ 0�� �ִ´� */
        end else if (next_cnt == 1) begin   /* next_cnt�� 1�� �� value2�� dig2+1�� ���� �ְ� */
            value2 = dig2>=9 ? 0 : dig2+1;  /* dig2�� 9���� ũ�ų� ������ 0�� �ִ´� */
        end else if (next_cnt == 2) begin   /* next_cnt�� 2�� �� value3�� dig3+1�� ���� �ְ� */
            value3 = dig3>=9 ? 0 : dig3+1;  /* dig3�� 9���� ũ�ų� ������ 0�� �ִ´� */
        end else if (next_cnt == 3) begin   /* next_cnt�� 3�� �� value4�� dig4+1�� ���� �ְ� */
            value4 = dig4>=9 ? 0 : dig4+1;  /* dig4�� 9���� ũ�ų� ������ 0�� �ִ´� */
        end               
    end else begin          /* �� �ܿ� inc ��ư�� ������ ������, value1~4�� ���� dig1~4�� ���� �ִ´� */
        value1=dig1;
        value2=dig2;
        value3=dig3;
        value4=dig4;
    end
end
/* ���� �� always ��� ������ ���� �Ʒ� ����� clk�� positive edge�� ��, value1~4�� dig1~4�� 1�� ���� ���� ����,
�� ����� �׻�, dig1~4�� value1~4�� ���� ���� ������, value1~4�� ���� �����ϴ� ���ÿ� dig1~4�� ���� 1 �����Ѵ�. */


always @(posedge clk_1khz) begin    /* clk_1khz�� positive edge �� �� */
    if (~nRst) begin                /* nRst ��ư�� ������ value5~8�� 0���� �ʱ�ȭ ��Ų�� */
        value5=0;
        value6=0;
        value7=0;
        value8=0;
    end else if (next_cnt == 4) begin   /* next_cnt�� 4�� ��, */
        if (cnt2<=100) begin            /* cnt2�� clk_1khz�� 10hz�� �����ش� */
            cnt2=cnt2+1;                /* cnt2�� 100���� ������ cnt2�� 1�� �����ְ� */
        end else begin
            cnt2=0;                     /* cnt2�� 100���� Ŀ���� cnt2�� 0���� �ʱ�ȭ�ϰ� */
            value8=dig4-1;              /* value8�� dig4���� 1�� �� ���� �־��ش� */
            if (value8>9) begin         /* �� ������ �ݺ��ϴ� value8�� 9���� Ŀ���� (4'hF�� �Ǹ�) */
                value8=9;               /* value8�� 9�� �����, value7�� dig3���� 1�� �� ���� �־��ش� */
                value7=dig3-1;
            end
            if (value7>9) begin         /* ��, ���� ������ �ݺ��ϴ� value7�� 9���� Ŀ���� */
                value7=9;               /* value7�� 9�� �����, value6�� dig2���� 1�� �� ���� �־��ش� */
                value6=dig2-1;
            end
            if (value6>9) begin         /* ���� ������� �ݺ��ϴ� value 6�� 9���� Ŀ���� */
                value6=9;               /* value6�� 9�� �����, value5�� dig1���� 1�� �� ���� �־��ش� */
                value5=dig1-1;
            end
        end
    end else begin                      /* next_cnt�� 4�� �ƴ� �� */
        value5 = value1;                /* value5~8 �� value1~4 �� ��� �ִ� ���� ���� �־��ش� */
        value6 = value2;
        value7 = value3;
        value8 = value4;
    end
end
/* value 5~8�� next_cnt�� 0~3�϶� value1~4�� ���� �޾ƿ��⸸ �ϰ�,
next_cnt�� 4�� �Ǹ� value1~4�� �ϴ� ������ ��� �ϰ� �ȴ�.
value 5~8�� ���� ��� �����ؼ� 0�� �Ǹ� 
dig1~4�� value5~8�� ���� 0�� ���� �ǰ�, next_cnt�� 0���� �ʱ�ȭ �ǰ�,
dig1~4�� �� 0�� value1~4�� ���� �Ǽ� ���� �ʱ�ȭ �ȴ�. */
endmodule

