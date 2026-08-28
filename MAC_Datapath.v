//==============================================================================
// File: MAC_Datapath.v
// Description: Datapath for MAC operation in RNS system with moduli {7, 8, 9}
//              Uses modules from the original project files
//==============================================================================

`timescale 1ns/1ns

module MAC_Datapath (
    input wire clk,
    input wire rst,
    
    // Control signals from controller
    input wire load_a_en,
    input wire load_b_en,
    input wire convert_en,
    input wire mult_en,
    input wire acc_en,
    input wire acc_clear,
    input wire [1:0] operand_sel,
    
    // Data outputs
    output wire [9:0] result_rns,
    output wire [7:0] result_binary
);

    //==========================================================================
    // Parameters - Moduli for RNS Adder: {7, 8, 9}
    // mi[10:8] = 7 (3'b111)
    // mi[7:4]  = 8 (4'b1000)  
    // mi[3:0]  = 9 (4'b1001)
    //==========================================================================
    localparam [10:0] MODULI = 11'b111_1000_1001;

    //==========================================================================
    // Memory Address Parameters
    // a[0], a[1], a[2] at addresses 0, 1, 2
    // b[0], b[1], b[2] at addresses 3, 4, 5
    //==========================================================================
    wire [31:0] addr_a;
    wire [31:0] addr_b;
    
    assign addr_a = {30'd0, operand_sel};        // 0, 1, 2
    assign addr_b = {30'd0, operand_sel} + 32'd3; // 3, 4, 5

    //==========================================================================
    // Memory Output Wires
    //==========================================================================
    wire [7:0] mem_data_a;
    wire [7:0] mem_data_b;

    //==========================================================================
    // Memory Instances - Using DataMem from original files
    //==========================================================================
    DataMem #(
        .dataWidth(8),
        .blockSize(4096),
        .addressWidth(32)
    ) mem_a (
        .write(1'b0),
        .addressBus(addr_a),
        .memDataIN(8'd0),
        .memDataOut(mem_data_a)
    );

    DataMem #(
        .dataWidth(8),
        .blockSize(4096),
        .addressWidth(32)
    ) mem_b (
        .write(1'b0),
        .addressBus(addr_b),
        .memDataIN(8'd0),
        .memDataOut(mem_data_b)
    );

    //==========================================================================
    // Internal Registers
    //==========================================================================
    reg [7:0] a_int_reg;
    reg [7:0] b_int_reg;
    reg [9:0] a_rns_reg;
    reg [9:0] b_rns_reg;
    reg [9:0] mult_result_reg;
    reg [9:0] accumulator;

    //==========================================================================
    // Integer to RNS Conversion Wires
    //==========================================================================
    wire [2:0] a_r7, a_r8;
    wire [3:0] a_r9;
    wire [2:0] b_r7, b_r8;
    wire [3:0] b_r9;

    //==========================================================================
    // Integer to RNS Converters - Using int_to_rns from original files
    //==========================================================================
    int_to_rns conv_a (
        .in(a_int_reg),
        .r7(a_r7),
        .r8(a_r8),
        .r9(a_r9)
    );

    int_to_rns conv_b (
        .in(b_int_reg),
        .r7(b_r7),
        .r8(b_r8),
        .r9(b_r9)
    );

    //==========================================================================
    // RNS Multiplier - Using mul_rns from original files
    //==========================================================================
    wire [9:0] mult_out;

    mul_rns rns_multiplier (
        .a(a_rns_reg),
        .b(b_rns_reg),
        .c(mult_out)
    );

    //==========================================================================
    // RNS Adder - Using RNSAdder from original files
    //==========================================================================
    wire [9:0] adder_out;

    RNSAdder rns_adder (
        .a(accumulator),
        .b(mult_result_reg),
        .mi(MODULI),
        .c(adder_out)
    );

    //==========================================================================
    // RNS to Integer Converter - Using rns_to_int from original files
    //==========================================================================
    rns_to_int rns2int (
        .r7(accumulator[9:7]),
        .r8(accumulator[6:4]),
        .r9(accumulator[3:0]),
        .result(result_binary)
    );

    //==========================================================================
    // Output Assignment
    //==========================================================================
    assign result_rns = accumulator;

    //==========================================================================
    // Datapath Sequential Logic
    //==========================================================================
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_int_reg       <= 8'd0;
            b_int_reg       <= 8'd0;
            a_rns_reg       <= 10'd0;
            b_rns_reg       <= 10'd0;
            mult_result_reg <= 10'd0;
            accumulator     <= 10'd0;
        end else begin
            // Load operand A from memory
            if (load_a_en) begin
                a_int_reg <= mem_data_a;
            end
            
            // Load operand B from memory
            if (load_b_en) begin
                b_int_reg <= mem_data_b;
            end
            
            // Convert integer to RNS
            if (convert_en) begin
                a_rns_reg <= {a_r7, a_r8, a_r9};
                b_rns_reg <= {b_r7, b_r8, b_r9};
            end
            
            // Store multiplication result
            if (mult_en) begin
                mult_result_reg <= mult_out;
            end
            
            // Accumulator control
            if (acc_clear) begin
                accumulator <= 10'd0;
            end else if (acc_en) begin
                accumulator <= adder_out;
            end
        end
    end

endmodule
