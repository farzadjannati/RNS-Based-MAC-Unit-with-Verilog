`timescale 1ns/1ns

module tb();

    reg clk,rst;
    reg [9:0] a,b;
    reg [10:0] mi;
    wire [9:0] c;
    always #10 clk = ~clk;

    RNSAdder ourrns(.a(a),.b(b),.mi(mi),.c(c));

    // our mis 7,8,9 so we are going to add A = 180 , B = 260 
    // A representation is (5,4,0) and B is (1,4,8) and A + B = 440 is (6,0,8)
    // we need 4 bit for last residue (9) and 6 bit for others
       

    initial begin
        rst <=0;
        clk <=0;
        #20
        rst<=1;
        #40
        rst<=0;
        a<=10'b1011000000;//180
        b<=10'b0011001000;//260 result should be 1100001000
        mi<=11'b11110001001;
        #100
        $stop;
    end

endmodule
