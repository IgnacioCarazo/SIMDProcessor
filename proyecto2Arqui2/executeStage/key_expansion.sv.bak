module key_expansion #(
    parameter regSize = 8,                // Size of each register (8 bits)
    parameter vecSize = 16                // Size of the key (128 bits / 8 bits per register = 16)
) (
    input logic [vecSize-1:0][regSize-1:0] key,     // Input key as a 2D array (16 x 8 bits)
    output logic [10:0][vecSize-1:0][regSize-1:0] round_keys // 11 round keys for AES-128
);

    logic [31:0] temp;                          // Temporary variable for key manipulation
    logic [31:0] temp_sbox;                     // To store S-box substituted value

    // Define round constants (Rcon) as a LUT
    logic [31:0] rcon [10:0] = {
        32'h01000000, 32'h02000000, 32'h04000000,
        32'h08000000, 32'h10000000, 32'h20000000,
        32'h40000000, 32'h80000000, 32'h1b000000,
        32'h36000000, 32'h00000000                 
    };

    // First round key is the original key
    assign round_keys[0] = key;

    // Instantiate the S-Box once
    sub_bytes sbox_instance (
        .state(temp), 
        .new_state(temp_sbox)
    );

    // Key expansion process
    always_comb begin
        for (int i = 1; i <= 10; i++) begin
            // Rotate the last 32 bits of the previous round key
            temp = {round_keys[i-1][23:0], round_keys[i-1][127:24]}; 

            // Apply S-Box to the rotated value
            // This assumes temp is being set to a value to be substituted
            sbox_instance.state = temp; // Assign the temp value to the state input of the S-Box
            // Wait for temp_sbox to be updated; it happens in the next cycle due to the combinational nature

            // XOR with Rcon
            temp = temp_sbox ^ rcon[i-1];

            // Generate the new round key
            round_keys[i][127:96] = round_keys[i-1][127:96] ^ temp;
            round_keys[i][95:64]  = round_keys[i-1][95:64] ^ round_keys[i][127:96];
            round_keys[i][63:32]  = round_keys[i-1][63:32] ^ round_keys[i][95:64];
            round_keys[i][31:0]   = round_keys[i-1][31:0] ^ round_keys[i][63:32];
        end
    end
endmodule
