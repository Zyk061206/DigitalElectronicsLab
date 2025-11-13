`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/11 08:23:29
// Design Name: 
// Module Name: Encoder8to3
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

// 行为描述方式
module Encoder8to3_1(
    input [7:0] I,
    output reg [2:0] O
    );
    
    always @(I)begin
        if(I[7] == 0) O <= 3'b000;
        else if(I[6] == 0) O <= 3'b001;
        else if(I[5] == 0) O <= 3'b010;
        else if(I[4] == 0) O <= 3'b011;
        else if(I[3] == 0) O <= 3'b100;
        else if(I[2] == 0) O <= 3'b101;
        else if(I[1] == 0) O <= 3'b110;
        else if(I[0] == 0) O <= 3'b111;
        else O <= 3'b111;

    end 
endmodule

// 数据流形式
module Encoder8to3_2(
    input [7:0] I,
    output [2:0] O
    );
    
    assign O = (I[7] == 0) ? 3'b000 :  // 最高优先级：I7
               (I[6] == 0) ? 3'b001 :
               (I[5] == 0) ? 3'b010 :
               (I[4] == 0) ? 3'b011 :
               (I[3] == 0) ? 3'b100 :
               (I[2] == 0) ? 3'b101 :
               (I[1] == 0) ? 3'b110 :
               (I[0] == 0) ? 3'b111 :       // 最低优先级：I0
                              3'b111;            // 默认值：所有输入为高电平

endmodule 


module Encoder8to3_3(
    input [7:0] I,
    output [2:0] O
);

    // 子模块：检测每个输入位的有效性和优先级
    
    // 检测每个输入是否有效（低电平有效）
    wire i0_valid, i1_valid, i2_valid, i3_valid;
    wire i4_valid, i5_valid, i6_valid, i7_valid;
    
    not U1(i0_valid, I[0]);  // I0为0时有效
    not U2(i1_valid, I[1]);  // I1为0时有效
    not U3(i2_valid, I[2]);  // I2为0时有效
    not U4(i3_valid, I[3]);  // I3为0时有效
    not U5(i4_valid, I[4]);  // I4为0时有效
    not U6(i5_valid, I[5]);  // I5为0时有效
    not U7(i6_valid, I[6]);  // I6为0时有效
    not U8(i7_valid, I[7]);  // I7为0时有效
    
    // 优先级选择：只有更高优先级都无效时才选择当前位
    wire sel_i0, sel_i1, sel_i2, sel_i3;
    wire sel_i4, sel_i5, sel_i6, sel_i7;
    
    // 最高优先级：I7总是被选择（如果有效）
    assign sel_i7 = i7_valid;
    
    // I6：只有当I7无效时才选择
    wire not_i7_valid;
    not U9(not_i7_valid, i7_valid);
    and U10(sel_i6, i6_valid, not_i7_valid);
    
    // I5：只有当I7,I6都无效时才选择
    wire not_i6_valid;
    not U11(not_i6_valid, i6_valid);
    and U12(sel_i5, i5_valid, not_i7_valid, not_i6_valid);
    
    // I4：只有当I7,I6,I5都无效时才选择
    wire not_i5_valid;
    not U13(not_i5_valid, i5_valid);
    and U14(sel_i4, i4_valid, not_i7_valid, not_i6_valid, not_i5_valid);
    
    // I3：只有当I7-I4都无效时才选择
    wire not_i4_valid;
    not U15(not_i4_valid, i4_valid);
    and U16(sel_i3, i3_valid, not_i7_valid, not_i6_valid, not_i5_valid, not_i4_valid);
    
    // I2：只有当I7-I3都无效时才选择
    wire not_i3_valid;
    not U17(not_i3_valid, i3_valid);
    and U18(sel_i2, i2_valid, not_i7_valid, not_i6_valid, not_i5_valid, not_i4_valid, not_i3_valid);
    
    // I1：只有当I7-I2都无效时才选择
    wire not_i2_valid;
    not U19(not_i2_valid, i2_valid);
    and U20(sel_i1, i1_valid, not_i7_valid, not_i6_valid, not_i5_valid, not_i4_valid, not_i3_valid, not_i2_valid);
    
    // I0：只有当I7-I1都无效时才选择
    wire not_i1_valid;
    not U21(not_i1_valid, i1_valid);
    and U22(sel_i0, i0_valid, not_i7_valid, not_i6_valid, not_i5_valid, not_i4_valid, not_i3_valid, not_i2_valid, not_i1_valid);
    
    // 输入全为1时
    wire or_all;
    and Uall(or_all,I[0],I[1],I[2],I[3],I[4],I[5],I[6],I[7]);
    
    // 输出编码逻辑
    // O[2] = 1'b1 当选择 I0,I1,I2,I3 (二进制000-011)
    // O[2] = 1'b0 当选择 I4,I5,I6,I7 (二进制100-111)
    wire or_o2_1, or_o2_2;
    or U23(or_o2_1, sel_i0, sel_i1);
    or U24(or_o2_2, sel_i2, sel_i3);
    or U25(O[2], or_o2_1, or_o2_2, or_all);
    
    // O[1] = 1'b1 当选择 I0,I1,I4,I5 (二进制000,001,100,101)
    // O[1] = 1'b0 当选择 I2,I3,I6,I7 (二进制010,011,110,111)
    wire or_o1_1, or_o1_2;
    or U26(or_o1_1, sel_i0, sel_i1);
    or U27(or_o1_2, sel_i4, sel_i5);
    or U28(O[1], or_o1_1, or_o1_2, or_all);
    
    // O[0] = 1'b1 当选择 I0,I2,I4,I6 (二进制000,010,100,110)
    // O[0] = 1'b0 当选择 I1,I3,I5,I7 (二进制001,011,101,111)
    wire or_o0_1, or_o0_2;
    or U29(or_o0_1, sel_i0, sel_i2);
    or U30(or_o0_2, sel_i4, sel_i6);
    or U31(O[0], or_o0_1, or_o0_2, or_all);

endmodule
