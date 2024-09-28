module shift_rows #(
    parameter regSize = 32,               // Size of each register (32 bits)
    parameter vecSize = 4                 // Number of registers (rows)
) (
    input logic [regSize-1:0] vect_in [vecSize-1:0],  // Input: vecSize x regSize bit matrix
    output logic [regSize-1:0] vect_out [vecSize-1:0] // Output: vecSize x regSize bit matrix
);

    logic [regSize-1:0] transposed [vecSize-1:0]; // Intermediate transposed matrix
    logic [regSize-1:0] shifted [vecSize-1:0];     // Intermediate shifted matrix

    // Instantiate the matrix_transpose module to transpose vect_in
    matrix_transpose #(
        .regSize(regSize),
        .vecSize(vecSize)
    ) transpose_inst (
        .matrix_in(vect_in),         // Connect vect_in to matrix_in
        .matrix_out(transposed)      // Connect transposed output
    );

    // Perform the shift rows operation on the transposed matrix
    always_comb begin
        // Row 0: No shift
        shifted[0] = transposed[0];  // b0, b4, b8, b12

        // Row 1: Shift left by 1 column
        shifted[1] = {transposed[1][regSize-1:8], transposed[1][regSize-1:0]}; // Shift first byte (b1) to the end

        // Row 2: Shift left by 2 columns
        shifted[2] = {transposed[2][regSize-1:16], transposed[2][regSize-1:0], transposed[2][regSize-1:24]}; // Shift b2 and b6

        // Row 3: Shift left by 3 columns
        shifted[3] = {transposed[3][regSize-1:24], transposed[3][regSize-1:16], transposed[3][regSize-1:8], transposed[3][regSize-1:0]}; // Shift b3, b7, and b11
    end

    // Instantiate the matrix_transpose module to transpose the shifted output
    matrix_transpose #(
        .regSize(regSize),
        .vecSize(vecSize)
    ) transpose_shifted_inst (
        .matrix_in(shifted),         // Connect shifted to matrix_in
        .matrix_out(vect_out)        // Connect vect_out to the final transposed output
    );

endmodule