module shift_rows (
    input logic [127:0] state,          // 128-bit state matrix input
    output logic [127:0] shiftedState  // 128-bit shifted state matrix output
);

    // Extract bytes from the state matrix
    logic [7:0] byte0, byte1, byte2, byte3;
    logic [7:0] byte4, byte5, byte6, byte7;
    logic [7:0] byte8, byte9, byte10, byte11;
    logic [7:0] byte12, byte13, byte14, byte15;

    // Extract bytes from state
    assign byte0 = state[127:120];
    assign byte1 = state[119:112];
    assign byte2 = state[111:104];
    assign byte3 = state[103:96];
    assign byte4 = state[95:88];
    assign byte5 = state[87:80];
    assign byte6 = state[79:72];
    assign byte7 = state[71:64];
    assign byte8 = state[63:56];
    assign byte9 = state[55:48];
    assign byte10 = state[47:40];
    assign byte11 = state[39:32];
    assign byte12 = state[31:24];
    assign byte13 = state[23:16];
    assign byte14 = state[15:8];
    assign byte15 = state[7:0];

    // Apply ShiftRows operation
    logic [7:0] row0 [3:0], row1 [3:0], row2 [3:0], row3 [3:0];
    logic [7:0] shifted_row1 [3:0], shifted_row2 [3:0], shifted_row3 [3:0];

    // Row 0: No shift
    assign row0 = {byte0, byte4, byte8, byte12};

    // Row 1: Shift by 1 byte (circular shift)
    assign shifted_row1 = {byte5, byte9, byte13, byte1};

    // Row 2: Shift by 2 bytes (circular shift)
    assign shifted_row2 = {byte10, byte14, byte2, byte6};

    // Row 3: Shift by 3 bytes (circular shift)
    assign shifted_row3 = {byte15, byte3, byte7, byte11};

    // Combine rows into the shifted state matrix
    assign shiftedState[127:120] = row0[0];
    assign shiftedState[119:112] = row1[0];
    assign shiftedState[111:104] = row2[0];
    assign shiftedState[103:96]  = row3[0];
    assign shiftedState[95:88]   = row0[1];
    assign shiftedState[87:80]   = row1[1];
    assign shiftedState[79:72]   = row2[1];
    assign shiftedState[71:64]   = row3[1];
    assign shiftedState[63:56]   = row0[2];
    assign shiftedState[55:48]   = row1[2];
    assign shiftedState[47:40]   = row2[2];
    assign shiftedState[39:32]   = row3[2];
    assign shiftedState[31:24]   = row0[3];
    assign shiftedState[23:16]   = row1[3];
    assign shiftedState[15:8]    = row2[3];
    assign shiftedState[7:0]     = row3[3];

endmodule
