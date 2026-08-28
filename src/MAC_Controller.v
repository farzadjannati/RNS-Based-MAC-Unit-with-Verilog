//==============================================================================
// File: MAC_Controller.v
// Description: FSM Controller for MAC operation in RNS
//              Computes: result = a[0]*b[0] + a[1]*b[1] + a[2]*b[2]
//==============================================================================

`timescale 1ns/1ns

module MAC_Controller (
    input wire clk,
    input wire rst,
    input wire start,
    
    // Control outputs to datapath
    output reg load_a_en,
    output reg load_b_en,
    output reg convert_en,
    output reg mult_en,
    output reg acc_en,
    output reg acc_clear,
    output reg result_valid,
    output reg [1:0] operand_sel
);

    //==========================================================================
    // State Encoding - 15 states for complete MAC operation
    //==========================================================================
    localparam [3:0] S_IDLE     = 4'd0;
    localparam [3:0] S_INIT     = 4'd1;
    localparam [3:0] S_LOAD1    = 4'd2;
    localparam [3:0] S_CONV1    = 4'd3;
    localparam [3:0] S_MULT1    = 4'd4;
    localparam [3:0] S_ACC1     = 4'd5;
    localparam [3:0] S_LOAD2    = 4'd6;
    localparam [3:0] S_CONV2    = 4'd7;
    localparam [3:0] S_MULT2    = 4'd8;
    localparam [3:0] S_ACC2     = 4'd9;
    localparam [3:0] S_LOAD3    = 4'd10;
    localparam [3:0] S_CONV3    = 4'd11;
    localparam [3:0] S_MULT3    = 4'd12;
    localparam [3:0] S_ACC3     = 4'd13;
    localparam [3:0] S_DONE     = 4'd14;

    //==========================================================================
    // State Register
    //==========================================================================
    reg [3:0] current_state, next_state;

    // State register with async reset
    always @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= S_IDLE;
        else
            current_state <= next_state;
    end

    //==========================================================================
    // Next State Logic
    //==========================================================================
    always @(*) begin
        next_state = current_state;
        
        case (current_state)
            S_IDLE:  if (start) next_state = S_INIT;
            S_INIT:  next_state = S_LOAD1;
            S_LOAD1: next_state = S_CONV1;
            S_CONV1: next_state = S_MULT1;
            S_MULT1: next_state = S_ACC1;
            S_ACC1:  next_state = S_LOAD2;
            S_LOAD2: next_state = S_CONV2;
            S_CONV2: next_state = S_MULT2;
            S_MULT2: next_state = S_ACC2;
            S_ACC2:  next_state = S_LOAD3;
            S_LOAD3: next_state = S_CONV3;
            S_CONV3: next_state = S_MULT3;
            S_MULT3: next_state = S_ACC3;
            S_ACC3:  next_state = S_DONE;
            S_DONE:  if (!start) next_state = S_IDLE;
            default: next_state = S_IDLE;
        endcase
    end

    //==========================================================================
    // Output Logic (Moore Machine)
    //==========================================================================
    always @(*) begin
        // Default all outputs to inactive
        load_a_en    = 1'b0;
        load_b_en    = 1'b0;
        convert_en   = 1'b0;
        mult_en      = 1'b0;
        acc_en       = 1'b0;
        acc_clear    = 1'b0;
        result_valid = 1'b0;
        operand_sel  = 2'd0;
        
        case (current_state)
            S_INIT: begin
                acc_clear = 1'b1;
            end
            
            S_LOAD1: begin
                load_a_en   = 1'b1;
                load_b_en   = 1'b1;
                operand_sel = 2'd0;
            end
            
            S_CONV1: begin
                convert_en = 1'b1;
            end
            
            S_MULT1: begin
                mult_en = 1'b1;
            end
            
            S_ACC1: begin
                acc_en = 1'b1;
            end
            
            S_LOAD2: begin
                load_a_en   = 1'b1;
                load_b_en   = 1'b1;
                operand_sel = 2'd1;
            end
            
            S_CONV2: begin
                convert_en = 1'b1;
            end
            
            S_MULT2: begin
                mult_en = 1'b1;
            end
            
            S_ACC2: begin
                acc_en = 1'b1;
            end
            
            S_LOAD3: begin
                load_a_en   = 1'b1;
                load_b_en   = 1'b1;
                operand_sel = 2'd2;
            end
            
            S_CONV3: begin
                convert_en = 1'b1;
            end
            
            S_MULT3: begin
                mult_en = 1'b1;
            end
            
            S_ACC3: begin
                acc_en = 1'b1;
            end
            
            S_DONE: begin
                result_valid = 1'b1;
            end
        endcase
    end

endmodule
