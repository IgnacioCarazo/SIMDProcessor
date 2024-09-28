module sub_word #(
    parameter regSize = 32               // Size of each word (32 bits)
) (
    input logic [regSize-1:0] word_in,   // Input: 32-bit word
    output logic [regSize-1:0] word_out   // Output: 32-bit word after substitution
);
    logic [7:0] sbox_outputs[0:3]; // Array to hold outputs from S-Box for each byte

    // Instantiate the S-Box
    s_box sbox_inst0 (
        .addr(word_in[31:24]), // MSB byte
        .data(sbox_outputs[0])  // Output for MSB
    );
    s_box sbox_inst1 (
        .addr(word_in[23:16]), // Byte 1
        .data(sbox_outputs[1])  // Output for Byte 1
    );
    s_box sbox_inst2 (
        .addr(word_in[15:8]),  // Byte 2
        .data(sbox_outputs[2])  // Output for Byte 2
    );
    s_box sbox_inst3 (
        .addr(word_in[7:0]),   // LSB byte
        .data(sbox_outputs[3])  // Output for LSB
    );

    // Assign the outputs to the word_out
    always_comb begin
        word_out[31:24] = sbox_outputs[0];
        word_out[23:16] = sbox_outputs[1];
        word_out[15:8]  = sbox_outputs[2];
        word_out[7:0]   = sbox_outputs[3];
    end
endmodule