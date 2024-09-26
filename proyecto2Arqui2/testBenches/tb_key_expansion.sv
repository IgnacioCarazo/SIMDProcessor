module tb_key_expansion;
    parameter regSize = 32;    // Size of each register (32 bits)
    parameter vecSize = 4;     // Number of registers (4 words for AES-128)

    // Declare input and output signals for the key_expansion module
    logic [vecSize-1:0][regSize-1:0] key;               // Input key as a 2D array (4 x 32 bits)
	 logic [3:0] round;
    logic [vecSize-1:0][regSize-1:0] next_key;          // Output next round key

    // Instantiate the key_expansion module (without the round input now)
    key_expansion #(regSize, vecSize) uut (
        .current_key(key),
        .next_key(next_key)
    );

    // Initial block to apply test vectors
    initial begin
        // Test case: Input key
        key[0] = 32'h00000000;   // First word of the key
        key[1] = 32'h00000000;   // Second word of the key
        key[2] = 32'h00000000;   // Third word of the key
        key[3] = 32'h00000000;   // Fourth word of the key
		  
		  round = 1;

        // Wait for the next key to stabilize
        #10;

        // Check expected outputs for the next_key (you can customize expected values based on your key expansion algorithm)
        assert(next_key[0] == 32'h00000000) else $error("Test Case 1 Failed: ", next_key[0]);
        assert(next_key[1] == 32'h00000000) else $error("Test Case 1 Failed: ", next_key[1]);
        assert(next_key[2] == 32'h00000000) else $error("Test Case 1 Failed: ", next_key[2]);
        assert(next_key[3] == 32'h00000000) else $error("Test Case 1 Failed: ", next_key[3]);

        // End of testbench
        $finish;
    end
endmodule