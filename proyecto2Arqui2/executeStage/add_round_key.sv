module add_round_key #(parameter vecSize = 4) (
    input logic [vecSize-1:0][31:0] state,        // Input: 4 columns of 32 bits
    input logic [vecSize-1:0][31:0] round_key,    // Input: 4 columns of 32 bits
    output logic [vecSize-1:0][31:0] new_state     // Output: 4 columns of 32 bits
);
    // Generate XOR modules for each round key
    genvar i; // Declare a generate variable
    generate
        for (i = 0; i < vecSize; i++) begin : xor_inst
            xor_32bit xor_inst_i (
                .a(state[i]),
                .b(round_key[i]),
                .result(new_state[i])
            );
        end
    endgenerate
endmodule