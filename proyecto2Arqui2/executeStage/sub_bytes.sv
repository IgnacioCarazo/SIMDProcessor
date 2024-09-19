module subbytes (
    input logic [127:0] state,          // 128-bit state matrix input
    input logic [7:0] sbox_data [255:0], // Predefined S-Box data (as an input array)
    output logic [127:0] new_state      // 128-bit new state matrix output
);
    // Internal wires for byte extraction
    logic [7:0] state_bytes [15:0]; // Array to store extracted bytes
    logic [7:0] sbox_results [15:0]; // Array to store S-Box results

    // ******
    // Esto esta mal porque yo lo estaba implementando a nivel de byte y no en indices como
    // vimos ahora en la llamada, con x y y.
    // ******

    // Extract bytes from state (parallel extraction)
    always_comb begin
        state_bytes[0] = state[7:0];
        state_bytes[1] = state[15:8];
        state_bytes[2] = state[23:16];
        state_bytes[3] = state[31:24];
        state_bytes[4] = state[39:32];
        state_bytes[5] = state[47:40];
        state_bytes[6] = state[55:48];
        state_bytes[7] = state[63:56];
        state_bytes[8] = state[71:64];
        state_bytes[9] = state[79:72];
        state_bytes[10] = state[87:80];
        state_bytes[11] = state[95:88];
        state_bytes[12] = state[103:96];
        state_bytes[13] = state[111:104];
        state_bytes[14] = state[119:112];
        state_bytes[15] = state[127:120];
    end

    // Perform S-Box substitution in parallel
    always_comb begin
        // Each byte's S-Box lookup is done in parallel
        sbox_results[0] = sbox_data[state_bytes[0]];
        sbox_results[1] = sbox_data[state_bytes[1]];
        sbox_results[2] = sbox_data[state_bytes[2]];
        sbox_results[3] = sbox_data[state_bytes[3]];
        sbox_results[4] = sbox_data[state_bytes[4]];
        sbox_results[5] = sbox_data[state_bytes[5]];
        sbox_results[6] = sbox_data[state_bytes[6]];
        sbox_results[7] = sbox_data[state_bytes[7]];
        sbox_results[8] = sbox_data[state_bytes[8]];
        sbox_results[9] = sbox_data[state_bytes[9]];
        sbox_results[10] = sbox_data[state_bytes[10]];
        sbox_results[11] = sbox_data[state_bytes[11]];
        sbox_results[12] = sbox_data[state_bytes[12]];
        sbox_results[13] = sbox_data[state_bytes[13]];
        sbox_results[14] = sbox_data[state_bytes[14]];
        sbox_results[15] = sbox_data[state_bytes[15]];
    end

    // Combine S-Box results into new state matrix (parallel combination)
    always_comb begin
        new_state[7:0] = sbox_results[0];
        new_state[15:8] = sbox_results[1];
        new_state[23:16] = sbox_results[2];
        new_state[31:24] = sbox_results[3];
        new_state[39:32] = sbox_results[4];
        new_state[47:40] = sbox_results[5];
        new_state[55:48] = sbox_results[6];
        new_state[63:56] = sbox_results[7];
        new_state[71:64] = sbox_results[8];
        new_state[79:72] = sbox_results[9];
        new_state[87:80] = sbox_results[10];
        new_state[95:88] = sbox_results[11];
        new_state[103:96] = sbox_results[12];
        new_state[111:104] = sbox_results[13];
        new_state[119:112] = sbox_results[14];
        new_state[127:120] = sbox_results[15];
    end
endmodule
