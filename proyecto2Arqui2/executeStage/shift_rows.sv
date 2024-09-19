module shift_rows (
    input logic [127:0] state,          // 128-bit state matrix input
    output logic [127:0] shiftedState    // 128-bit shifted state matrix output
);

    // Extract bytes from the state matrix
    logic [7:0] state_bytes [15:0]; // Array to store the 16 extracted bytes

    // Extract bytes from state (Column-major order)
    assign state_bytes[0] = state[127:120];  // s0
    assign state_bytes[1] = state[119:112];  // s1
    assign state_bytes[2] = state[111:104];  // s2
    assign state_bytes[3] = state[103:96];   // s3
    assign state_bytes[4] = state[95:88];    // s4
    assign state_bytes[5] = state[87:80];    // s5
    assign state_bytes[6] = state[79:72];    // s6
    assign state_bytes[7] = state[71:64];    // s7
    assign state_bytes[8] = state[63:56];    // s8
    assign state_bytes[9] = state[55:48];    // s9
    assign state_bytes[10] = state[47:40];   // s10
    assign state_bytes[11] = state[39:32];   // s11
    assign state_bytes[12] = state[31:24];   // s12
    assign state_bytes[13] = state[23:16];   // s13
    assign state_bytes[14] = state[15:8];    // s14
    assign state_bytes[15] = state[7:0];     // s15

    // Apply ShiftRows operation (Shifting within rows, while preserving column-major order)

    // Row 0: No shift
    assign shiftedState[127:120] = state_bytes[0];   // s0 remains s0
    assign shiftedState[95:88]   = state_bytes[4];   // s4 remains s4
    assign shiftedState[63:56]   = state_bytes[8];   // s8 remains s8
    assign shiftedState[31:24]   = state_bytes[12];  // s12 remains s12

    // Row 1: Shift by 1 byte (left within the row)
    assign shiftedState[119:112] = state_bytes[5];   // s5 moves to s1
    assign shiftedState[87:80]   = state_bytes[9];   // s9 moves to s5
    assign shiftedState[55:48]   = state_bytes[13];  // s13 moves to s9
    assign shiftedState[23:16]   = state_bytes[1];   // s1 moves to s13

    // Row 2: Shift by 2 bytes (left within the row)
    assign shiftedState[111:104] = state_bytes[10];  // s10 moves to s2
    assign shiftedState[79:72]   = state_bytes[14];  // s14 moves to s6
    assign shiftedState[47:40]   = state_bytes[2];   // s2 moves to s10
    assign shiftedState[15:8]    = state_bytes[6];   // s6 moves to s14

    // Row 3: Shift by 3 bytes (left within the row)
    assign shiftedState[103:96]  = state_bytes[15];  // s15 moves to s3
    assign shiftedState[71:64]   = state_bytes[3];   // s3 moves to s7
    assign shiftedState[39:32]   = state_bytes[7];   // s7 moves to s11
    assign shiftedState[7:0]     = state_bytes[11];  // s11 moves to s15

endmodule
