module mix_columns #(
    parameter regSize = 32,  // Size of each column (32 bits)
    parameter vecSize = 4    // Number of columns (4 for AES)
) (
    input logic [vecSize-1:0][regSize-1:0] vect,  // Input: 4 columns of 32 bits
    output logic [vecSize-1:0][regSize-1:0] new_vect  // Output: Transformed columns
);

    genvar i; // Declare a generate variable

    generate
        for (i = 0; i < vecSize; i++) begin : mix_column_gen
            mix_column mc (
                .col(vect[i]),               // Connect input column
                .new_col(new_vect[i])       // Connect output column
            );
        end
    endgenerate

endmodule