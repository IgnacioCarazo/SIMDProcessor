module key_expansion #(
    parameter regSize = 32,         // Size of each register (32 bits)
    parameter vecSize = 4           // Number of registers (4 words for AES-128)
) (
    input logic [vecSize-1:0][regSize-1:0] current_key, // Input key as a 2D array (4 x 32 bits)
	 input logic [3:0] round,
    output logic [vecSize-1:0][regSize-1:0] next_key     // Output next round key
);


	  // Internal wire for the transformed word
    logic [regSize-1:0] temp_word;    
    logic [regSize-1:0] sub_word_out; // Output from sub_word module
	 
    // Define round constants (Rcon) as a LUT
    logic [31:0] rcon [0:10];     
    initial begin
        rcon[0] = 32'h01000000; rcon[1] = 32'h02000000;
        rcon[2] = 32'h04000000; rcon[3] = 32'h08000000;
        rcon[4] = 32'h10000000; rcon[5] = 32'h20000000;
        rcon[6] = 32'h40000000; rcon[7] = 32'h80000000;
        rcon[8] = 32'h1b000000; rcon[9] = 32'h36000000;
        rcon[10] = 32'h00000000; // This can be adjusted as needed
    end

   

    // Instantiate the sub_word module
    sub_word sub_word_inst (
        .word_in(temp_word),
        .word_out(sub_word_out)
    );

    // Compute the next key
    always_comb begin
        // Start with the last word of the current key
        temp_word = current_key[vecSize-1];

        // Always apply the sub_word transformation and the rotation
        temp_word = {temp_word[regSize-2:0], temp_word[regSize-1]}; // Rotate left
        temp_word = sub_word_out ^ rcon[round]; // XOR with the first round constant (for round 1)

        // Generate the next key
        next_key[0] = current_key[0] ^ temp_word; // XOR with the first word
        next_key[1] = current_key[1] ^ next_key[0]; // XOR with the previous result
        next_key[2] = current_key[2] ^ next_key[1]; // XOR with the previous result
        next_key[3] = current_key[3] ^ next_key[2]; // XOR with the previous result
    end
endmodule