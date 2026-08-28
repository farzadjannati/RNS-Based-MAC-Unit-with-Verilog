module int_to_rns (
    input [7:0] in,
    output [2:0] r7,
    output [2:0] r8,
    output [3:0] r9
);

    int_to_radix7 i2r7(
        .in(in),
        .out(r7)
    );

    assign r8 = in[2:0];

    int_to_radix9 i2r9(
        .in(in),
        .out(r9)
    );
    
endmodule