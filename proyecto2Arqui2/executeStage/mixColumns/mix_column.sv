module mix_column (
    input logic [31:0] col,              // Input: A single column of 32 bits
    output logic [31:0] new_col          // Output: Transformed column
);

    logic [7:0] b0, b1, b2, b3;
    logic [7:0] xtime_b0, xtime_b1, xtime_b2, xtime_b3;
    logic [7:0] mul_by_3_b0, mul_by_3_b1, mul_by_3_b2, mul_by_3_b3;

    always_comb begin
        // Extract the 4 bytes from the 32-bit word (column)
        b0 = col[31:24];  // First byte
        b1 = col[23:16];  // Second byte
        b2 = col[15:8];   // Third byte
        b3 = col[7:0];    // Fourth byte

        // xtime operation (multiply by 2)
        xtime_b0 = (b0 << 1) ^ ((b0 & 8'h80) ? 8'h1B : 8'h00);
        xtime_b1 = (b1 << 1) ^ ((b1 & 8'h80) ? 8'h1B : 8'h00);
        xtime_b2 = (b2 << 1) ^ ((b2 & 8'h80) ? 8'h1B : 8'h00);
        xtime_b3 = (b3 << 1) ^ ((b3 & 8'h80) ? 8'h1B : 8'h00);

        // mul_by_3 operation (multiply by 3)
        mul_by_3_b0 = xtime_b0 ^ b0;
        mul_by_3_b1 = xtime_b1 ^ b1;
        mul_by_3_b2 = xtime_b2 ^ b2;
        mul_by_3_b3 = xtime_b3 ^ b3;

        // Perform the MixColumns transformation on the bytes
        new_col[31:24] = xtime_b0 ^ mul_by_3_b1 ^ b2 ^ b3; // New byte 0
        new_col[23:16] = b0 ^ xtime_b1 ^ mul_by_3_b2 ^ b3; // New byte 1
        new_col[15:8]  = b0 ^ b1 ^ xtime_b2 ^ mul_by_3_b3; // New byte 2
        new_col[7:0]   = mul_by_3_b0 ^ b1 ^ b2 ^ xtime_b3; // New byte 3
    end
endmodule