module Residuefor8 (
    input [5:0]a,
    output signed [3:0] c
);
    
    assign c = a[2:0];

endmodule
