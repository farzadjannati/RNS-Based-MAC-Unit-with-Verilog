module Residuefor9(
    input [6:0] a,
    output reg signed [3:0] c
);

    wire[2:0] p0;
    wire[2:0] p1;
    wire[2:0] p2;

    wire signed [4:0] partial_result;

    assign p0 = a[2:0];
    assign p1 = a[5:3];
    assign p2 = {2'b0, a[6]};

    assign partial_result = {1'b0, p0} + (~{1'b0,p1} + 4'b0001) + {1'b0, p2};

always @(*) begin
    case (partial_result)
        5'b11001: c <= 4'd2; // -7
        5'b11010: c <= 4'd3; // -6
        5'b11011: c <= 4'd4; // -5
        5'b11100: c <= 4'd5; // -4
        5'b11101: c <= 4'd6; // -3
        5'b11110: c <= 4'd7; // -2
        5'b11111: c <= 4'd8; // -1
        5'b00000: c <= 4'd0; // 0
        5'b00001: c <= 4'd1; // 1
        5'b00010: c <= 4'd2; // 2
        5'b00011: c <= 4'd3; // 3
        5'b00100: c <= 4'd4; // 4
        5'b00101: c <= 4'd5; // 5
        5'b00110: c <= 4'd6; // 6
        5'b00111: c <= 4'd7; // 7
        5'b01000: c <= 4'd8; // 8
        default: c <= 4'd0;
    endcase
end

endmodule

