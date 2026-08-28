`timescale 1ns /1ns

module int_to_radix9 (
    input [7:0] in,
    output reg [3:0] out
);

    wire[2:0] p0;
    wire[2:0] p1;
    wire[2:0] p2;
    wire [4:0] partial_result;

    assign p0 = in[2:0];
    assign p1 = in[5:3];
    assign p2 = {1'b0, in[7:6]};
    
    assign partial_result = p0 + p2 - p1;

    // carry_save_adder csa(
    //     .a(p0),
    //     .b(~p1+1),
    //     .c(p2),
    //     .result(partial_result)
    // );

    always @(partial_result) begin
        case (partial_result)
            5'b11001 : out = 4'b0010;
            5'b11010 : out = 4'b0011;
            5'b11011 : out = 4'b0100;
            5'b11100 : out = 4'b0101;
            5'b11101 : out = 4'b0110;
            5'b11110 : out = 4'b0111;
            5'b11111 : out = 4'b1000;
            5'b00000 : out = 4'b0000; 
            5'b00001 : out = 4'b0001; 
            5'b00010 : out = 4'b0010; 
            5'b00011 : out = 4'b0011; 
            5'b00100 : out = 4'b0100; 
            5'b00101 : out = 4'b0101; 
            5'b00110 : out = 4'b0110; 
            5'b00111 : out = 4'b0111; 
            5'b01000 : out = 4'b1000; 
            5'b01001 : out = 4'b0000; 
            5'b01010 : out = 4'b0001; 
        endcase
    end

endmodule


module tb_i2r9 ();
    reg [7:0] in;
    reg test;
    reg [3:0] temp;
    wire [3:0] result;

    int_to_radix9 i2r9(
        .in(in),
        .out(result)
    );

    integer i;
    
    initial begin
        for(i = 0; i < 256; i = i + 1) begin
            #1 in = i;
            temp = i % 9;
            #1;
            test = (result == temp);
        end
        #1 $stop;
    end

endmodule