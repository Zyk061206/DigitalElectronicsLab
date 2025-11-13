module compare(
    input  wire A,
    input  wire B,
    output wire C,  // A > B
    output wire D,  // A == B
    output wire E  // A < B
);
    assign C = (A > B) ? 1'b1 : 1'b0;
    assign D = (A == B) ? 1'b1 : 1'b0;
    assign E = (A < B) ? 1'b1 : 1'b0;

endmodule


module compare (
    input  wire A,
    input  wire B,
    output wire C,
    output wire D,
    output wire E
);
    always @(*) begin
        if(A>B) begin
            C = 1;
            D = 0;
            E = 0;
        end
        else if(A==B) begin
            C = 0;
            D = 1;
            E = 0;
        end
        else if(A<B) begin
            C = 0;
            D = 0;
            E = 1;
        end
        else begin
            C = 0;
            D = 0;
            E = 0;
        end
    end

endmodule
module compare(
    input  wire A,
    input  wire B,
    output wire C,
    output wire D,
    output wire E
);

    wire notA, notB;
    wire and1, and2;

    // 非门
    not (notA, A);
    not (notB, B);

    // 与门
    and (and1, A, notB);   // A & ~B
    and (and2, notA, B);   // ~A & B

    // 异或门 + 非门 实现同或
    wire xor_out;
    xor (xor_out, A, B);
    not (D, xor_out);   // ~(A^B)

    // 直接连线
    buf (C, and1);
    buf (E, and2);

endmodule
