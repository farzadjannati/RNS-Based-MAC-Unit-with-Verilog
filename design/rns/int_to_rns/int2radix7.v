`timescale 1ns /1ns

module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);

endmodule

module carry_save_adder(
    input [2:0] a,
    input [2:0] b,
    input [2:0] c,
    output [4:0] result
);
 
    wire [2:0] sum_vector;
    wire [2:0] cout_vector;

    genvar i;
    generate
        for (i = 0; i < 3; i = i + 1) begin

            full_adder fa(
                .a(a[i]),
                .b(b[i]),
                .cin(c[i]),
                .sum(sum_vector[i]),
                .cout(cout_vector[i])
            );

        end
    endgenerate

    assign result  = {cout_vector, 1'b0} + sum_vector;

endmodule

module int_to_radix7 (
    input [7:0] in,
    output reg [2:0] out
);

    wire[2:0] p0;
    wire[2:0] p1;
    wire[2:0] p2;
    wire [4:0] partial_result;

    assign p0 = in[2:0];
    assign p1 = in[5:3];
    assign p2 = {1'b0, in[7:6]};
    
    carry_save_adder csa(
        .a(p0),
        .b(p1),
        .c(p2),
        .result(partial_result)
    );

    always @(partial_result) begin
        case (partial_result)
            5'd0 : out = 3'b000; 
            5'd1 : out = 3'b001; 
            5'd2 : out = 3'b010; 
            5'd3 : out = 3'b011; 
            5'd4 : out = 3'b100; 
            5'd5 : out = 3'b101; 
            5'd6 : out = 3'b110; 
            5'd7 : out = 3'b000; 
            5'd8 : out = 3'b001; 
            5'd9 : out = 3'b010; 
            5'd10 : out = 3'b011; 
            5'd11 : out = 3'b100; 
            5'd12 : out = 3'b101; 
            5'd13 : out = 3'b110; 
            5'd14 : out = 3'b000; 
            5'd15 : out = 3'b001; 
            5'd16 : out = 3'b010; 
            5'd17 : out = 3'b011; 
        endcase
    end

endmodule


module tb_i2r7 ();
    reg [7:0] in;
    reg test;
    reg [2:0] temp;
    wire [2:0] result;

    int_to_radix7 i2r7(
        .in(in),
        .out(result)
    );

    integer i;
    
    initial begin
        for(i = 0; i < 256; i = i + 1) begin
            #1 in = i;
            temp = i % 7;
            #1;
            test = (result == temp);
        end
        #1 $stop;
    end

endmodule