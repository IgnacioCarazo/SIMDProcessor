module shift_rows #(
    parameter regSize = 32,        // Size of each register (32 bits)
    parameter vecSize = 4          // Number of registers (rows)
)(
    input logic [vecSize-1:0][regSize-1:0] vect_in,    
    output logic [vecSize-1:0][regSize-1:0] vect_out
);
    always_comb begin
        // Intermediate transposed and shifted matrices
        logic [regSize-1:0] transposed [vecSize-1:0];
        logic [regSize-1:0] shifted [vecSize-1:0];

        // Transpose the input matrix and apply row shifts
        transposed[0] = {vect_in[0][31:24], vect_in[1][31:24], vect_in[2][31:24], vect_in[3][31:24]}; // Column 0 to Row 0
        transposed[1] = {vect_in[0][23:16], vect_in[1][23:16], vect_in[2][23:16], vect_in[3][23:16]}; // Column 1 to Row 1
        transposed[2] = {vect_in[0][15:8],  vect_in[1][15:8],  vect_in[2][15:8],  vect_in[3][15:8]};  // Column 2 to Row 2
        transposed[3] = {vect_in[0][7:0],   vect_in[1][7:0],   vect_in[2][7:0],   vect_in[3][7:0]};   // Column 3 to Row 3

        // Perform the shift rows operation on the transposed matrix
        shifted[0] = transposed[0];  // Row 0: No shift
        shifted[1] = {transposed[1][23:0], transposed[1][31:24]}; // Row 1: Shift left by 1 byte
        shifted[2] = {transposed[2][15:0], transposed[2][31:16]}; // Row 2: Shift left by 2 bytes
        shifted[3] = {transposed[3][7:0], transposed[3][31:8]};   // Row 3: Shift left by 3 bytes

        // Final transpose to produce the output
        vect_out[0] = {shifted[0][31:24], shifted[1][31:24], shifted[2][31:24], shifted[3][31:24]}; // Row 0 to Column 0
        vect_out[1] = {shifted[0][23:16], shifted[1][23:16], shifted[2][23:16], shifted[3][23:16]}; // Row 1 to Column 1
        vect_out[2] = {shifted[0][15:8],  shifted[1][15:8],  shifted[2][15:8],  shifted[3][15:8]};  // Row 2 to Column 2
        vect_out[3] = {shifted[0][7:0],   shifted[1][7:0],   shifted[2][7:0],   shifted[3][7:0]};   // Row 3 to Column 3
    end
endmodule