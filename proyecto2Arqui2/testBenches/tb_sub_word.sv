module tb_sub_word;

    // Parameters for the testbench
    parameter regSize = 32;   // Size of each register (32 bits)

    // Declare input and output signals for the sub_word module
    logic [regSize-1:0] word_in;  // Input word
    logic [regSize-1:0] word_out;  // Output word after substitution

    // Instantiate the sub_word module
    sub_word #(regSize) uut (
        .word_in(word_in),
        .word_out(word_out)
    );


    // Initial block to apply test vectors
    initial begin
        // Test case 1
        word_in = 32'h00000101;  // Input word
        #10; // Wait for a small delay for the output to stabilize
        assert(word_out == 32'h63637c7c) else $error("Test Case 1 Failed: Expected 8f5b0c90 but got %h", word_out);

        // Test case 2
        word_in = 32'h03030707;  // Input word
        #10; // Wait for output stabilization
        assert(word_out == 32'h7b7bc5c5) else $error("Test Case 2 Failed: Expected 03030707 but got %h", word_out);

        // Test case 3
        word_in = 32'h0f0f1f1f;  // Input word
        #10; // Wait for output stabilization
        assert(word_out == 32'h7676c0c0) else $error("Test Case 3 Failed: Expected 0f0f1f1f but got %h", word_out);

        // Test case 4
        word_in = 32'h3f3f7f7f;  // Input word
        #10; // Wait for output stabilization
        assert(word_out == 32'h7575d2d2) else $error("Test Case 4 Failed: Expected 7575d2d2 but got %h", word_out);

        // Add more test cases as needed

        // Finish the simulation
        $finish;
    end

endmodule