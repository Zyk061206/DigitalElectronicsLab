`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/11 08:09:51
// Design Name: 
// Module Name: Mux2to1
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


//  数据流描述
module Mux2to11(
    input d1,d2,s,
    output y
    );
    
    assign y = s ? d2:d1;  //根据s是否为0确定输出
endmodule
//  结构描述
module Mux2to12(
    input d1,d2,s,
    output y
    );
    
    wire s_n, o1, o2;			//定义wire类型变量
    not not1(s_n, s);			//s连接非门输出s_n
    and and1(o1, s, d2);		//s,d2连接与门输出o1
    and and2(o2, s_n, d1);	//s_n,d1连接与门输出o2
    or or1(y, o1, o2);			//o1,o2连接或门输出y
    
endmodule

// 行为描述
module Mux2to13(
    input d1,d2,s,
    output reg y
    );
    
    always @(d1 or d2 or s)begin
        case(s)
            1'b0: y <= d1;			//s为0时选择d1
            1'b1: y <= d2;			//s为1时选择d2
            default: y <= 0;		//默认输出0
        endcase
    end 
    	
endmodule

