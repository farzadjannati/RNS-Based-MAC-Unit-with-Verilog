module CSA #(parameter LENGTH  = 4, parameter MILENGTH = 4) (input [LENGTH -1:0]a,b,input [MILENGTH -1:0]mi,output signed [LENGTH:0] c);
    
    assign c = (a + b) - mi;

endmodule
