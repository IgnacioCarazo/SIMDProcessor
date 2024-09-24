module mix_columns #(
    parameter regSize = 8,               // Size of each register (8 bits)
    parameter vecSize = 16               // Size of the vector (number of registers, e.g., 16 for AES)
) (
    input logic [vecSize-1:0][regSize-1:0] vect,        // Input: vecSize x regSize bit vector
    output logic [vecSize-1:0][regSize-1:0] new_vect     // Output: vecSize x regSize bit new vector
);

    always_comb begin
        // MixColumns transformation
        for (int i = 0; i < vecSize; i += 4) begin
            new_vect[i]   = (vect[i] << 1) ^ (vect[i+1] << 1) ^ vect[i+1] ^ vect[i+2] ^ vect[i+3];
            new_vect[i+1] = vect[i] ^ (vect[i+1] << 1) ^ (vect[i+2] << 1) ^ vect[i+3];
            new_vect[i+2] = vect[i] ^ vect[i+1] ^ (vect[i+2] << 1) ^ (vect[i+3] << 1);
            new_vect[i+3] = (vect[i] << 1) ^ vect[i+1] ^ vect[i+2] ^ (vect[i+3] << 1);
        end
    end
endmodule
