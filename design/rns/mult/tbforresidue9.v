`timescale 1ns/1ns

module tb_mul_rns ();

    wire [2:0] r7;
    wire [2:0] r8;
    wire [3:0] r9;

    mul_rns mr(
        .a({3'd5, 3'd3, 4'd1}), // 19
        .b({3'd5, 3'd4, 4'd3}), //12
        .c({r7, r8, r9}) //228   //4  4  3
    );

    initial
    #5 $stop;
    
endmodule

module tb_Residuefor9;

    reg [6:0] a;
    wire [3:0] c;

    // Instantiate the module
    Residuefor9 dut (
        .a(a),
        .mi(4'b1001),
        .c(c)
    );

    integer i;

    initial begin
        $display("Testing Residuefor9...");
        $display(" a   | c  | expected");
        $display("----------------------");

        for (i = 0; i < 128; i = i + 1) begin
            a = i[6:0];
            #100; // wait for combinational propagation

            $display("%3d | %d  | %d", a, c, i % 9);
            if (c !== (i % 9)) begin
                $display("ERROR: input=%d, got=%d, expected=%d", a, c, i%9);
            end
        end

        $display("Testbench finished.");
        $stop;
    end

endmodule
