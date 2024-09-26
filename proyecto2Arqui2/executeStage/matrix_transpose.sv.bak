module matrix_transpose #(
    parameter regSize = 32,               // Size of each register (32 bits)
    parameter vecSize = 4                 // Number of registers (columns)
) (
    input logic [regSize-1:0] matrix_in [vecSize-1:0],  // Input: vecSize x regSize bit matrix
    output logic [regSize-1:0] matrix_out [vecSize-1:0] // Output: vecSize x regSize bit matrix
);

    always_comb begin
        // Transpose the matrix
        matrix_out[0] = {matrix_in[0][31:24], matrix_in[1][31:24], matrix_in[2][31:24], matrix_in[3][31:24]}; // Column 0 to Row 0
        matrix_out[1] = {matrix_in[0][23:16], matrix_in[1][23:16], matrix_in[2][23:16], matrix_in[3][23:16]}; // Column 1 to Row 1
        matrix_out[2] = {matrix_in[0][15:8],  matrix_in[1][15:8],  matrix_in[2][15:8],  matrix_in[3][15:8]};  // Column 2 to Row 2
        matrix_out[3] = {matrix_in[0][7:0],   matrix_in[1][7:0],   matrix_in[2][7:0],   matrix_in[3][7:0]};   // Column 3 to Row 3
    end


endmodule
