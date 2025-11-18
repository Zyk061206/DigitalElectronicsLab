`timescale 1ns / 1ps

module tb_cnt60_debug;

    reg CLK_1Hz;
    reg rst;
    reg mod;
    reg add_min;    // 分调整信号  
    reg add_hour;   // 时调整信号
    wire [5:0] sec_count;
    wire [5:0] min_count;
    wire [4:0] hour_count;
    wire sec_carry;
    wire min_carry;
    
    // 三级计数器级联
    cnt60 u_sec (.CLK_1Hz(CLK_1Hz), .rst(rst), .mod(1'b0), .add(1'b0), .carryIn(1'b0), .autoCount(1'b1), .count(sec_count), .carry(sec_carry));
    cnt60 u_min (.CLK_1Hz(CLK_1Hz), .rst(rst), .mod(add_min), .add(add_min), .carryIn(sec_carry), .autoCount(1'b0), .count(min_count), .carry(min_carry));
    hour24 u_hour (.CLK_1Hz(CLK_1Hz), .rst(rst), .mod(add_hour), .add(add_hour), .carryIn(min_carry), .count(hour_count));
    
    always #1 CLK_1Hz = ~CLK_1Hz;
    
    initial begin
        $display("=== 调试测试：详细监控进位过程 ===");
        
        CLK_1Hz = 0;
        rst = 1;
        mod = 0;
        add_min = 0;
        add_hour = 0;
        
        #2 rst = 0;
        #4 rst = 1;
        
        $display("时间(ns) | 时:分:秒 | sec_carry | min_carry | 说明");
        $display("---------|----------|-----------|-----------|------");
        
        // 等待到整秒开始
        wait(sec_count == 0);
        
        $display("\n--- 阶段1: 正常计数观察 ---");
        repeat(3) @(posedge CLK_1Hz);
        $display("%8t | %02d:%02d:%02d | %b | %b | 正常计数", 
                $time, hour_count, min_count, sec_count, sec_carry, min_carry);
        
        $display("\n--- 阶段2: 调时模式调整到59分 ---");
        mod = 1;
        add_min = 1;
        
        // 详细监控调整过程
        while (min_count < 59) begin
            @(posedge CLK_1Hz);
            if (min_count >= 57) begin
                $display("%8t | %02d:%02d:%02d | %b | %b | 调整分钟", 
                        $time, hour_count, min_count, sec_count, sec_carry, min_carry);
            end
        end
        
        $display("%8t | %02d:%02d:%02d | %b | %b | 到达59分", 
                $time, hour_count, min_count, sec_count, sec_carry, min_carry);
        
        $display("\n--- 阶段3: 关闭调时模式，观察进位 ---");
        @(posedge CLK_1Hz);
        mod = 0;
        add_min = 0;
        $display("%8t | %02d:%02d:%02d | %b | %b | 关闭调时模式", 
                $time, hour_count, min_count, sec_count, sec_carry, min_carry);
        
        // 详细观察进位过程
        repeat(10) begin
            @(posedge CLK_1Hz);
            $display("%8t | %02d:%02d:%02d | %b | %b | 等待进位", 
                    $time, hour_count, min_count, sec_count, sec_carry, min_carry);
            
            // 如果进位发生，检查小时
            if (min_count == 0 && $time > 50) begin
                $display("=== 进位检测到 ===");
                if (hour_count == 1) begin
                    $display("? 小时进位正确！");
                end else begin
                    $display("? 小时没有进位，仍然是: %0d", hour_count);
                end
                break;
            end
        end
        
        $display("\n? 测试完成!");
        $finish;
    end

endmodule
