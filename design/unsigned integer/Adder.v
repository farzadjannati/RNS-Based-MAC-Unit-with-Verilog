module Adder #(parameter LENGTH  = 4) (input [LENGTH-1:0] a,b, output [LENGTH-1:0] c);

    assign c = a + b;

endmodule
