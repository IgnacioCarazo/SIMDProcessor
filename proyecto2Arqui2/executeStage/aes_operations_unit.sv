module aes_operations_unit (
    input logic [127:0] stateIn,   // 128-bit input state matrix
    input logic [127:0] round,     // 128-bit round input (4-bit index within)
    input logic [2:0] opcode,      // 3-bit opcode to select AES operation
    input logic aesInstEn,         // AES Instruction Enable
    input logic [127:0] roundKey,  // 128-bit round key (for key expansion)
    output logic [127:0] state_out // 128-bit output state matrix
);
    // Internal wires for intermediate results
    logic [127:0] subBytesResult;
    logic [127:0] shiftRowsResult;
    logic [127:0] mixColumnsResult;
    logic [127:0] addRoundKeyResult;
    logic [127:0] state_temp;

    // Round keys for 10 rounds
    logic [127:0] round_keys [0:10];

    // Key expansion module
    key_expansion ke (
        .keyIn(roundKey),  // Assuming the input key for expansion
        .roundKeys(round_keys)
    );

    // Instantiate AES operations modules
    sub_bytes sb (
        .state(stateIn),
        .new_state(subBytesResult)
    );

    shift_rows sr (
        .state(stateIn),
        .new_state(shiftRowsResult)
    );

    mix_columns mc (
        .stateIn(stateIn),
        .inverse_select(1'b0), // Assuming encryption (not inversion)
        .state_out(mixColumnsResult)
    );

    // Operation Selector with AES enable control
    always_comb begin
        if (aesInstEn) begin
            case (opcode)
                3'd0: state_temp = subBytesResult;      // Opcode 0: subBytes
                3'd1: state_temp = shiftRowsResult;     // Opcode 1: shiftRows
                3'd2: state_temp = mixColumnsResult;    // Opcode 2: mixColumns
                3'd3: state_temp = stateIn ^ round_keys[round[3:0]]; // Opcode 3: addRoundKey
                default: state_temp = 128'h0000000000000000; // Default case to avoid latches
            endcase
        end else begin
            state_temp = stateIn; // Pass through state if AES is not enabled
        end
    end

    // Output State
    always_comb begin
        state_out = state_temp;
    end

endmodule