module tb_matrix_transpose;        
    // Parameters for the testbench
    parameter regSize = 32;   // Size of each register (32 bits)
    parameter vecSize = 4;    // Number of registers (columns)

    // Declare input and output signals for the matrix_transpose module
    logic [regSize-1:0] matrix_in [vecSize-1:0];      // Input: vecSize x regSize bit matrix
    logic [regSize-1:0] matrix_out [vecSize-1:0];     // Output: vecSize x regSize bit matrix

    // Instantiate the matrix_transpose module
    matrix_transpose #(regSize, vecSize) uut (
        .matrix_in(matrix_in),
        .matrix_out(matrix_out)
    );

    // Initial block to apply test vectors
    initial begin
        // Test case with provided input values
        matrix_in[0] = 32'h7b5b5465;  // Row 0
        matrix_in[1] = 32'h73745665;  // Row 1
        matrix_in[2] = 32'h63746f72;  // Row 2
        matrix_in[3] = 32'h5d53475d;  // Row 3

        // Wait for a small delay for the output to stabilize
        #10;

        // Expected Output:
        // matrix_out[0] = 32'h7b735d63 (Transpose of first bytes)
        // matrix_out[1] = 32'h5b745374 (Transpose of second bytes)
        // matrix_out[2] = 32'h546f4754 (Transpose of third bytes)
        // matrix_out[3] = 32'h65656572 (Transpose of fourth bytes)

        // Assertions for expected output values
        assert(matrix_out[0] == 32'h7b73635d) else $error("Test Case 1 Failed: Expected 7b73635d but got %h", matrix_out[0]);
        assert(matrix_out[1] == 32'h5b747453) else $error("Test Case 2 Failed: Expected 5b747453 but got %h", matrix_out[1]);
        assert(matrix_out[2] == 32'h54566f47) else $error("Test Case 3 Failed: Expected 54566f47 but got %h", matrix_out[2]);
        assert(matrix_out[3] == 32'h6565725d) else $error("Test Case 4 Failed: Expected 6565725d but got %h", matrix_out[3]);

        // Finish the simulation
        $finish;
    end
endmodule