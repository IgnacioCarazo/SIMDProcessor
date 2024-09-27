module tb_sub_bytes;    
    // Parameters for the testbench
    parameter regSize = 32;   // Size of each register (32 bits)    
    parameter vecSize = 4;    // Size of the vector (number of registers)

    // Declare input and output signals for the sub_bytes module
    logic [vecSize-1:0][regSize-1:0] state;          // Input state matrix    
    logic [vecSize-1:0][regSize-1:0] new_state;      // Output new state matrix

    // Instantiate the sub_bytes module
    sub_bytes #(regSize, vecSize) uut (
        .state(state),
        .new_state(new_state)
    );

    // Initial block to apply test vectors
	 


    initial begin        
        // Test case 1
        state[0] = 32'h00000101;  // Input state        
        state[1] = 32'h03030707;  // Another input state
        state[2] = 32'h0f0f1f1f;  // Another input state        
        state[3] = 32'h3f3f7f7f;  // Another input state

        // Wait for a small delay for the output to stabilize
        #10;

        // Assertions for expected output values        
        assert(new_state[0] == 32'h63637c7c) else $error("Test Case 1 Failed: Expected 63637c7c but got %h", new_state[0]);
        assert(new_state[1] == 32'h7b7bc5c5) else $error("Test Case 2 Failed: Expected 7b7bc5c5 but got %h", new_state[1]);        
        assert(new_state[2] == 32'h7676c0c0) else $error("Test Case 3 Failed: Expected 4c39b140 but got %h", new_state[2]);
        assert(new_state[3] == 32'h7575d2d2) else $error("Test Case 4 Failed: Expected 2192a83c but got %h", new_state[3]);

        // Add more test cases as needed

        // Finish the simulation        
        $finish;
    end
endmodule