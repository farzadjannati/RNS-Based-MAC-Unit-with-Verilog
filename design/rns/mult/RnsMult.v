module mul_rns(
    input [9:0] a,
    input [9:0] b,
    output [9:0] c
);
    
    // index 7 to 9 --> radix7
    // index 4 to 6 --> radix8
    // index 0 to 3 --> radix9

    wire [19:0] MultOutput; // 6bit for 7 , 8 and 7 bit for 9

    Mult #(.LENGTH(3)) Multfor7 (.a(a[9:7]),.b(b[9:7]),.c(MultOutput[19:14]));
    Mult #(.LENGTH(3)) Multfor8 (.a(a[6:4]),.b(b[6:4]),.c(MultOutput[13:8]));
    Mult #(.LENGTH(4)) Multfor9 (.a(a[3:0]),.b(b[3:0]),.c(MultOutput[7:0]));

    Residuefor7 residue7(.a(MultOutput[19:14]),.c(c[9:7]));
    Residuefor8 residue8(.a(MultOutput[13:8]),.c(c[6:4]));
    Residuefor9 residue9(.a(MultOutput[7:0]),.c(c[3:0]));
endmodule

