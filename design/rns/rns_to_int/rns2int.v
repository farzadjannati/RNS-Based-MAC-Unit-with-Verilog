`timescale 1ns/1ns

module rns_to_int (
    input [2:0] r7,
    input [2:0] r8,
    input [3:0] r9,
    output [7:0] result
);

    wire [2:0] a0;
    wire [2:0] a1;
    wire [3:0] a2;

    wire [5:0] p2;
    wire [5:0] p2_abs;

    assign a0 = r7;

    assign a1 = a0 - r8;

    assign p2 = (r9 - a0) + {a1, 1'b0};

    assign p2_abs = (p2[5] == 1'b1) ? p2+6'd9 : p2;

    assign a2 = ((p2_abs << 2) + p2_abs)%9;

    assign result = a0 + 7*a1 + 56*a2;
    
endmodule

module tb_i2r2i ();

    wire [2:0] r7;
    wire [2:0] r8;
    wire [3:0] r9;
    wire [7:0] result;
    reg [7:0] in;
    wire test;

    int_to_rns i2r(
        .in(in),
        .r7(r7),
        .r8(r8),
        .r9(r9)
    );

    rns_to_int r2i(
        .r7(r7),
        .r8(r8),
        .r9(r9),
        .result(result)
    );

    assign test = (in == result );

    integer i;

    initial begin
        for(i = 0; i < 256; i = i + 1) begin
            in = i;
            #5;
        end
        #1 $stop;
    end
    
endmodule