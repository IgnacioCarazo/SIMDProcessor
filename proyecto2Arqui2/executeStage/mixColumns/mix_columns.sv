module mix_columns #(
    parameter regSize = 32,  // Size of each column (32 bits)
    parameter vecSize = 4    // Number of columns (4 for AES)
) (
    input logic [vecSize-1:0][regSize-1:0] vect,  // Input: 4 columns of 32 bits
    output logic [vecSize-1:0][regSize-1:0] new_vect  // Output: Transformed columns
);

    always_comb begin
        // Declare all the variables at the beginning of the block
        logic [7:0] b0, b1, b2, b3;
        logic [7:0] xtime_b0, xtime_b1, xtime_b2, xtime_b3;
        logic [7:0] mul_by_3_b0, mul_by_3_b1, mul_by_3_b2, mul_by_3_b3;

        for (int i = 0; i < vecSize; i++) begin
            // Extract the 4 bytes from the 32-bit word (column)
            b0 = vect[i][31:24];  // First byte
            b1 = vect[i][23:16];  // Second byte
            b2 = vect[i][15:8];   // Third byte
            b3 = vect[i][7:0];    // Fourth byte

            // xtime operation (multiply by 2) for each byte without a function
            xtime_b0 = (b0 << 1) ^ ((b0 & 8'h80) ? 8'h1B : 8'h00);
            xtime_b1 = (b1 << 1) ^ ((b1 & 8'h80) ? 8'h1B : 8'h00);
            xtime_b2 = (b2 << 1) ^ ((b2 & 8'h80) ? 8'h1B : 8'h00);
            xtime_b3 = (b3 << 1) ^ ((b3 & 8'h80) ? 8'h1B : 8'h00);

            // mul_by_3 operation (multiply by 3) is xtime(b) ^ b, done inline
            mul_by_3_b0 = xtime_b0 ^ b0;
            mul_by_3_b1 = xtime_b1 ^ b1;
            mul_by_3_b2 = xtime_b2 ^ b2;
            mul_by_3_b3 = xtime_b3 ^ b3;

            // Perform the MixColumns transformation on the bytes
            new_vect[i][31:24] = xtime_b0 ^ mul_by_3_b1 ^ b2 ^ b3; // New byte 0
            new_vect[i][23:16] = b0 ^ xtime_b1 ^ mul_by_3_b2 ^ b3; // New byte 1
            new_vect[i][15:8]  = b0 ^ b1 ^ xtime_b2 ^ mul_by_3_b3; // New byte 2
            new_vect[i][7:0]   = mul_by_3_b0 ^ b1 ^ b2 ^ xtime_b3; // New byte 3
        end
    end
endmodule