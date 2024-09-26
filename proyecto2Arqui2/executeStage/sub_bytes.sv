module sub_bytes #(
    parameter regSize = 32,  // Size of each register (32 bits)
    parameter vecSize = 4    // Size of the vector (number of registers)
) (
    input logic [vecSize-1:0][regSize-1:0] state,     // Input: vecSize x regSize bit state matrix
    output logic [vecSize-1:0][regSize-1:0] new_state // Output: vecSize x regSize bit new state matrix
);

    // Generate loop to instantiate sub_word modules for each 32-bit word in the state matrix
    genvar i;
    generate
        for (i = 0; i < vecSize; i++) begin : sub_word_loop
            sub_word sub_word_inst (
                .word_in(state[i]),
                .word_out(new_state[i])
            );
        end
    endgenerate

endmodule