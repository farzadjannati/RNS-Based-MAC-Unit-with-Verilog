//==============================================================================
// File: MAC_TB.v
// Description: Testbench for RNS MAC unit - Comprehensive verification
//==============================================================================

`timescale 1ns/1ns

module MAC_TB;

    //==========================================================================
    // Testbench Signals
    //==========================================================================
    reg clk;
    reg rst;
    reg start;
    
    wire [9:0] result_rns;
    wire [7:0] result_binary;
    wire done;

    //==========================================================================
    // Clock Generation
    //==========================================================================
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    //==========================================================================
    // DUT Instance
    //==========================================================================
    MAC_Top dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .result_rns(result_rns),
        .result_binary(result_binary),
        .done(done)
    );

    //==========================================================================
    // Test Variables
    //==========================================================================
    reg [7:0] expected_result;
    reg [2:0] expected_mod7;
    reg [2:0] expected_mod8;
    reg [3:0] expected_mod9;
    integer errors;

    //==========================================================================
    // Main Test
    //==========================================================================
    initial begin
        // Initialize
        rst = 0;
        start = 0;
        errors = 0;
        
        // Expected values from DataMem.txt:
        // a[0]=5, a[1]=10, a[2]=3
        // b[0]=4, b[1]=2,  b[2]=6
        // Result = 5*4 + 10*2 + 3*6 = 20 + 20 + 18 = 58
        expected_result = 8'd58;
        expected_mod7 = 58 % 7;  // 2
        expected_mod8 = 58 % 8;  // 2
        expected_mod9 = 58 % 9;  // 4
        
        $display("");
        $display("################################################################");
        $display("#                                                              #");
        $display("#         MAC Unit Testbench - RNS System {7, 8, 9}            #");
        $display("#                                                              #");
        $display("################################################################");
        $display("");
        $display("Test Configuration:");
        $display("  Moduli: {7, 8, 9}");
        $display("  Dynamic Range: 7 * 8 * 9 = 504");
        $display("");
        $display("Input Data (from DataMem.txt):");
        $display("  a[0] = 5,  b[0] = 4  =>  5 * 4  = 20");
        $display("  a[1] = 10, b[1] = 2  => 10 * 2  = 20");
        $display("  a[2] = 3,  b[2] = 6  =>  3 * 6  = 18");
        $display("  -----------------------------------------");
        $display("  Expected MAC Result: 20 + 20 + 18 = 58");
        $display("");
        $display("Expected RNS Representation of 58:");
        $display("  58 mod 7 = %0d", expected_mod7);
        $display("  58 mod 8 = %0d", expected_mod8);
        $display("  58 mod 9 = %0d", expected_mod9);
        $display("================================================================");
        $display("");
        
        // Apply reset
        $display("[%0t] Applying reset...", $time);
        #15;
        rst = 1;
        #30;
        rst = 0;
        #15;
        $display("[%0t] Reset complete.", $time);
        $display("");
        
        // Start MAC operation
        $display("[%0t] Starting MAC operation...", $time);
        $display("");
        start = 1;
        @(posedge clk);
        @(posedge clk);
        start = 0;
        
        // Wait for completion
        $display("Waiting for MAC to complete...");
        $display("");
        wait(done == 1'b1);
        @(posedge clk);
        #5;
        
        // Display and verify results
        $display("================================================================");
        $display("                        RESULTS                                 ");
        $display("================================================================");
        $display("");
        $display("RNS Result (10-bit): %b", result_rns);
        $display("");
        $display("  Bits [9:7] (mod 7): %b = %0d", result_rns[9:7], result_rns[9:7]);
        $display("  Bits [6:4] (mod 8): %b = %0d", result_rns[6:4], result_rns[6:4]);
        $display("  Bits [3:0] (mod 9): %b = %0d", result_rns[3:0], result_rns[3:0]);
        $display("");
        $display("Binary Result: %0d", result_binary);
        $display("Expected:      %0d", expected_result);
        $display("");
        
        // Detailed verification
        $display("================================================================");
        $display("                      VERIFICATION                              ");
        $display("================================================================");
        $display("");
        
        // Check mod 7
        if (result_rns[9:7] == expected_mod7) begin
            $display("[PASS] mod 7: Got %0d, Expected %0d", result_rns[9:7], expected_mod7);
        end else begin
            $display("[FAIL] mod 7: Got %0d, Expected %0d", result_rns[9:7], expected_mod7);
            errors = errors + 1;
        end
        
        // Check mod 8
        if (result_rns[6:4] == expected_mod8) begin
            $display("[PASS] mod 8: Got %0d, Expected %0d", result_rns[6:4], expected_mod8);
        end else begin
            $display("[FAIL] mod 8: Got %0d, Expected %0d", result_rns[6:4], expected_mod8);
            errors = errors + 1;
        end
        
        // Check mod 9
        if (result_rns[3:0] == expected_mod9) begin
            $display("[PASS] mod 9: Got %0d, Expected %0d", result_rns[3:0], expected_mod9);
        end else begin
            $display("[FAIL] mod 9: Got %0d, Expected %0d", result_rns[3:0], expected_mod9);
            errors = errors + 1;
        end
        
        // Check final binary result
        if (result_binary == expected_result) begin
            $display("[PASS] Binary: Got %0d, Expected %0d", result_binary, expected_result);
        end else begin
            $display("[FAIL] Binary: Got %0d, Expected %0d", result_binary, expected_result);
            errors = errors + 1;
        end
        
        $display("");
        $display("================================================================");
        $display("                       FINAL STATUS                             ");
        $display("================================================================");
        $display("");
        
        if (errors == 0) begin
            $display("  **************************************");
            $display("  *                                    *");
            $display("  *      ALL TESTS PASSED!             *");
            $display("  *                                    *");
            $display("  **************************************");
        end else begin
            $display("  **************************************");
            $display("  *                                    *");
            $display("  *      %0d ERROR(S) DETECTED           *", errors);
            $display("  *                                    *");
            $display("  **************************************");
        end
        
        $display("");
        $display("================================================================");
        $display("");
        
        // Additional verification info
        $display("Manual Verification:");
        $display("  Step 1: 5 * 4 = 20");
        $display("    20 mod 7 = %0d, 20 mod 8 = %0d, 20 mod 9 = %0d", 20%7, 20%8, 20%9);
        $display("  Step 2: 10 * 2 = 20");
        $display("    20 mod 7 = %0d, 20 mod 8 = %0d, 20 mod 9 = %0d", 20%7, 20%8, 20%9);
        $display("  Step 3: 3 * 6 = 18");
        $display("    18 mod 7 = %0d, 18 mod 8 = %0d, 18 mod 9 = %0d", 18%7, 18%8, 18%9);
        $display("");
        $display("  Accumulation in RNS:");
        $display("    After step 1: (6, 4, 2)");
        $display("    After step 2: (6+6=12 mod 7=5, 4+4=8 mod 8=0, 2+2=4)");
        $display("    After step 3: (5+4=9 mod 7=2, 0+2=2, 4+0=4)");
        $display("    Final RNS: (2, 2, 4) = 58 in binary");
        $display("");
        
        #100;
        $stop;
    end

    //==========================================================================
    // State Monitor
    //==========================================================================
    reg [3:0] prev_state;
    initial prev_state = 0;
    
    always @(posedge clk) begin
        if (dut.controller.current_state != prev_state) begin
            $display("[%0t] FSM State: %0d -> %0d", 
                     $time, prev_state, dut.controller.current_state);
            prev_state <= dut.controller.current_state;
        end
    end

    //==========================================================================
    // Key Signal Monitor
    //==========================================================================
    always @(posedge clk) begin
        if (dut.datapath.load_a_en) begin
            #1;
            $display("[%0t] LOAD: a_int=%0d, b_int=%0d (sel=%0d)", 
                     $time, 
                     dut.datapath.mem_data_a, 
                     dut.datapath.mem_data_b,
                     dut.controller.operand_sel);
        end
        
        if (dut.datapath.convert_en) begin
            #1;
            $display("[%0t] CONVERT: a_rns=%b, b_rns=%b", 
                     $time,
                     {dut.datapath.a_r7, dut.datapath.a_r8, dut.datapath.a_r9},
                     {dut.datapath.b_r7, dut.datapath.b_r8, dut.datapath.b_r9});
        end
        
        if (dut.datapath.mult_en) begin
            #1;
            $display("[%0t] MULTIPLY: %b * %b = %b", 
                     $time,
                     dut.datapath.a_rns_reg,
                     dut.datapath.b_rns_reg,
                     dut.datapath.mult_out);
        end
        
        if (dut.datapath.acc_en && !dut.datapath.acc_clear) begin
            #1;
            $display("[%0t] ACCUMULATE: %b + %b = %b", 
                     $time,
                     dut.datapath.accumulator,
                     dut.datapath.mult_result_reg,
                     dut.datapath.adder_out);
        end
    end

endmodule
