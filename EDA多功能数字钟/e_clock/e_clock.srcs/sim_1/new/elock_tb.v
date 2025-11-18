`timescale 1ns / 1ps

module tb_eclock_fast;

    // 输入信号
    reg CLK;
    reg mod_adjust;
    reg add_min;
    reg add_hour;
    reg rst_n;
    
    // 输出信号
    wire [7:0] an;
    wire [7:0] seg;
    
    // 实例化电子时钟
    eclock uut (
        .CLK(CLK),
        .mod_adjust(mod_adjust),
        .add_min(add_min),
        .add_hour(add_hour),
        .rst_n(rst_n),
        .an(an),
        .seg(seg)
    );
    
    // 100MHz时钟 (10ns周期)
    always #5 CLK = ~CLK;
    
    initial begin
        
        // 初始化
        CLK = 0;
        mod_adjust = 0;
        add_min = 0;
        add_hour = 0;
        rst_n = 0;  // 先保持复位
        
        #100;
        
        rst_n = 1;  // 释放复位
        #10000;
        $finish;
    end
    
    // 超时保护
    initial begin
        #10000000;  // 10ms超时
        $display("!!! 测试超时 !!!");
        $finish;
    end

endmodule
