module RNSAdder(input [9:0] a , b , input [10:0]mi, output [9:0] c);
    
    // index 7 to 9 --> radix7
    // index 4 to 6 --> radix8
    // index 0 to 3 --> radix9

    wire [3:0] CSA_outoutfor7,CSA_outoutfor8;
    wire [4:0] CSA_outoutfor9;
    wire [9:0] adder_output;

    Adder #(.LENGTH(3)) adderfor7 (.a(a[9:7]),.b(b[9:7]),.c(adder_output[9:7]));
    Adder #(.LENGTH(3)) adderfor8 (.a(a[6:4]),.b(b[6:4]),.c(adder_output[6:4]));
    Adder #(.LENGTH(4)) adderfor9 (.a(a[3:0]),.b(b[3:0]),.c(adder_output[3:0]));
    CSA #(.LENGTH(3),.MILENGTH(3)) CSAfor7(.a(a[9:7]),.b(b[9:7]),.mi(mi[10:8]),.c(CSA_outoutfor7));
    CSA #(.LENGTH(3),.MILENGTH(4)) CSAfor8(.a(a[6:4]),.b(b[6:4]),.mi(mi[7:4]),.c(CSA_outoutfor8));
    CSA #(.LENGTH(4),.MILENGTH(4)) CSAfor9(.a(a[3:0]),.b(b[3:0]),.mi(mi[3:0]),.c(CSA_outoutfor9));

    assign c[9:7] = CSA_outoutfor7[3]?adder_output[9:7]:CSA_outoutfor7;
    assign c[6:4] = CSA_outoutfor8[3]?adder_output[6:4]:CSA_outoutfor8;
    assign c[3:0] = CSA_outoutfor9[4]?adder_output[3:0]:CSA_outoutfor9;

endmodule
