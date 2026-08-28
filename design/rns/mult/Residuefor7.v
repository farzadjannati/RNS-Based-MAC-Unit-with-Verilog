module Residuefor7 (
    input [5:0] a,
    output reg signed [2:0] c
);
    
    wire[2:0] p0;
    wire[2:0] p1;

    wire [3:0] partial_result;

    assign p0 = a[2:0];
    assign p1 = a[5:3];

    assign partial_result = p0 + p1;

        always @(partial_result) begin
			c=0;
            case (partial_result)
                4'd0 : c = 3'b000; 
                4'd1 : c = 3'b001; 
                4'd2 : c = 3'b010; 
                4'd3 : c = 3'b011; 
                4'd4 : c = 3'b100; 
                4'd5 : c = 3'b101; 
                4'd6 : c = 3'b110; 
                4'd7 : c = 3'b000; 
                4'd8 : c = 3'b001; 
                4'd9 : c = 3'b010; 
                4'd10 : c = 3'b011; 
                4'd11 : c = 3'b100; 
                4'd12 : c = 3'b101; 
                4'd13 : c = 3'b110; 
                4'd14 : c = 3'b000; 

        endcase
    end

endmodule
