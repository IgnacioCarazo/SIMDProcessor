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
        state[0] = 32'h73744765;  // Input state        
        state[1] = 32'h63535465;  // Another input state
        state[2] = 32'h5d5b5672;  // Another input state        
        state[3] = 32'h7b746f5d;  // Another input state

        // Wait for a small delay for the output to stabilize
        #10;

        // Assertions for expected output values        
        assert(new_state[0] == 32'h8f92a04d) else $error("Test Case 1 Failed: Expected 8f92a04d but got %h", new_state[0]);
        assert(new_state[1] == 32'hfbed204d) else $error("Test Case 2 Failed: Expected fbed204d but got %h", new_state[1]);        
        assert(new_state[2] == 32'h4c39b140) else $error("Test Case 3 Failed: Expected 4c39b140 but got %h", new_state[2]);
        assert(new_state[3] == 32'h2192a84c) else $error("Test Case 4 Failed: Expected 2192a83c but got %h", new_state[3]);

        // Add more test cases as needed

        // Finish the simulation        
        $finish;
    end
endmodule