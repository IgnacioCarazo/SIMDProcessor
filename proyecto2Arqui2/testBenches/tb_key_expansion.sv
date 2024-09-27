module tb_key_expansion;
    parameter regSize = 32;      // Size of each register (32 bits)
    parameter vecSize = 4;       // Number of registers (4 words for AES-128)

    // Declare input and output signals for the key_expansion module
    logic [vecSize-1:0][regSize-1:0] key;    // Input key as a 2D array (4 x 32 bits)
    logic [vecSize-1:0][regSize-1:0] round;  // Round number as a 2D array (4 x 32 bits)
    logic [vecSize-1:0][regSize-1:0] next_key; // Output next round key

    // Instantiate the key_expansion module
    key_expansion #(regSize, vecSize) uut (
        .current_key(key),
        .round(round),            // Passing the 2D round array
        .next_key(next_key)
    );

    // Initial block to apply test vectors
    initial begin
        // Test case: Input key (all zeros for simplicity)
        key[0] = 32'h00000000;    // First word of the key
        key[1] = 32'h00000000;    // Second word of the key
        key[2] = 32'h00000000;    // Third word of the key
        key[3] = 32'h00000000;    // Fourth word of the key

        // Set the round value in the 2D array (use specific round for each word if necessary)
        // Example: Set the round value to 1 in all words (you can customize this if needed)
        round[0] = 32'h00000000;  // First word has the round value 1
        round[1] = 32'h00000000;  // Second word has the round value 1
        round[2] = 32'h00000000;  // Third word has the round value 1
        round[3] = 32'h00000000;  // Fourth word has the round value 1

        // Wait for the next key to stabilize
        #10;

        // Check expected outputs for the next_key (adjust expected values based on the key expansion algorithm)
        // For this case, I'm assuming the next_key will be all zeros (modify this according to your expected values)
        assert(next_key[0] == 32'h61636363) else $error("Test Case 1 Failed: %h", next_key[0]);
        assert(next_key[1] == 32'h61636363) else $error("Test Case 1 Failed: %h", next_key[1]);
        assert(next_key[2] == 32'h61636363) else $error("Test Case 1 Failed: %h", next_key[2]);
        assert(next_key[3] == 32'h61636363) else $error("Test Case 1 Failed: %h", next_key[3]);

        // End of testbench
        $finish;
    end
endmodule