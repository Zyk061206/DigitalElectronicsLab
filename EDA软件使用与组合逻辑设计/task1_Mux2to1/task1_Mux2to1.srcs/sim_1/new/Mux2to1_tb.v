`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/11 08:10:06
// Design Name: 
// Module Name: Mux2to1_tb
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


module tb_Mux2to1s();
    reg d1, d2, s;
    wire y1, y2, y3;
    
    // 实例化三个选择器
    Mux2to11 u1(.d1(d1), .d2(d2), .s(s), .y(y1));
    Mux2to12 u2(.d1(d1), .d2(d2), .s(s), .y(y2));
    Mux2to13 u3(.d1(d1), .d2(d2), .s(s), .y(y3));
    
    initial begin
        // 初始化信号
        d1 = 0; d2 = 0; s = 0;
        
        // 测试用例1: s=0, 选择d1
        #10 d1 = 1; d2 = 0; s = 0;
        #10 
        
        // 测试用例2: s=1, 选择d2
        #10 d1 = 1; d2 = 0; s = 1;
        #10 
        
// 测试用例3: 改变输入值
        #10 d1 = 0; d2 = 1; s = 0;
        #10 
        

        // 测试用例4: s=1, 选择d2
        #10 d1 = 0; d2 = 1; s = 1;
        #10 
        
        // 更多测试用例
        #10 d1 = 1; d2 = 1; s = 0;
        #10 
        
        #10 d1 = 0; d2 = 0; s = 1;
        #10 
        
        #10 $finish;
    end
    
endmodule

