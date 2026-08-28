//==============================================================================
// File: MAC_Top.v
// Description: Top-level module integrating Controller and Datapath
//==============================================================================

`timescale 1ns/1ns

module MAC_Top (
    input wire clk,
    input wire rst,
    input wire start,
    
    output wire [9:0] result_rns,
    output wire [7:0] result_binary,
    output wire done
);

    //==========================================================================
    // Internal Control Signals
    //==========================================================================
    wire load_a_en;
    wire load_b_en;
    wire convert_en;
    wire mult_en;
    wire acc_en;
    wire acc_clear;
    wire result_valid;
    wire [1:0] operand_sel;

    //==========================================================================
    // Controller Instance
    //==========================================================================
    MAC_Controller controller (
        .clk(clk),
        .rst(rst),
        .start(start),
        
        .load_a_en(load_a_en),
        .load_b_en(load_b_en),
        .convert_en(convert_en),
        .mult_en(mult_en),
        .acc_en(acc_en),
        .acc_clear(acc_clear),
        .result_valid(result_valid),
        .operand_sel(operand_sel)
    );

    //==========================================================================
    // Datapath Instance
    //==========================================================================
    MAC_Datapath datapath (
        .clk(clk),
        .rst(rst),
        
        .load_a_en(load_a_en),
        .load_b_en(load_b_en),
        .convert_en(convert_en),
        .mult_en(mult_en),
        .acc_en(acc_en),
        .acc_clear(acc_clear),
        .operand_sel(operand_sel),
        
        .result_rns(result_rns),
        .result_binary(result_binary)
    );

    //==========================================================================
    // Output Assignment
    //==========================================================================
    assign done = result_valid;

endmodule
