`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/18 08:07:59
// Design Name: 
// Module Name: divider_tb
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


module divider_tb;

// 输入信号
    reg CLK;
    reg cr;
    
    //输出
    wire CLK_OUT;
    
    //实例化 
    Divider100MHz_1Hz uut(
    .CR(cr),
    .CLK_100MHz(CLK),
    .CLK_1Hz_Out(CLK_OUT )
    );   
    
    
    always #5 CLK = ~CLK;
    
    initial begin 
        CLK = 0;
        cr = 0;
        
        #100;
        
        cr = 1;
        
        #5000;    
        
        $finish;
    end
    
endmodule
