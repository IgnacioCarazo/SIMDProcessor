module mix_columns(
    input logic [127:0] stateIn,  // 128-bit state matrix input
    input logic inverseSelect,    // Control signal: 0 for mix_columns, 1 for Inverse mix_columns
    output logic [127:0] stateOut // 128-bit state matrix output
);
    // This operation works by columns (4 bytes) of the state matrix instead of bytes

    // Encryption mix_columns matrix lookup
    logic [7:0] mixMatrixEncrypt [0:3][0:3] = '{ 
        '{8'h02, 8'h03, 8'h01, 8'h01}, 
        '{8'h01, 8'h02, 8'h03, 8'h01}, 
        '{8'h01, 8'h01, 8'h02, 8'h03}, 
        '{8'h03, 8'h01, 8'h01, 8'h02} 
    };

    // Decryption Inverse mix_columns matrix lookup
    
    logic [7:0] mixMatrixDecrypt [0:3][0:3] = '{ 
        '{8'h0E, 8'h0B, 8'h0D, 8'h09}, 
        '{8'h09, 8'h0E, 8'h0B, 8'h0D}, 
        '{8'h0D, 8'h09, 8'h0E, 8'h0B}, 
        '{8'h0B, 8'h0D, 8'h09, 8'h0E} 
    };

    // Select matrix based on the control signal
    logic [7:0] mixMatrix [0:3][0:3];

    always_comb begin
        if (inverseSelect) begin
            mixMatrix = mixMatrixDecrypt;
        end else begin
            mixMatrix = mixMatrixEncrypt;
        end
    end

    // Internal wires for finite field multiplication
    logic [7:0] result[0:3][0:3];
    logic [7:0] state_col[0:3][0:3]; // Columns of the state matrix

    // Extract columns from the state matrix
    always_comb begin
        state_col[0] = stateIn[127:96];
        state_col[1] = stateIn[95:64];
        state_col[2] = stateIn[63:32];
        state_col[3] = stateIn[31:0];
    end

    // Instantiate gf_mult modules for each multiplication operation
    gf_mult gf_mult_inst[0:3] (
        .a(state_col[0][7:0]), .mult(mixMatrix[0][0]), .result(result[0][0]),
        .a(state_col[1][7:0]), .mult(mixMatrix[1][0]), .result(result[1][0]),
        .a(state_col[2][7:0]), .mult(mixMatrix[2][0]), .result(result[2][0]),
        .a(state_col[3][7:0]), .mult(mixMatrix[3][0]), .result(result[3][0])
    );

    // Combine results to form the output state matrix
    always_comb begin
        stateOut[127:96] = {result[0][0], result[1][0], result[2][0], result[3][0]};
        stateOut[95:64] = {result[0][1], result[1][1], result[2][1], result[3][1]};
        stateOut[63:32] = {result[0][2], result[1][2], result[2][2], result[3][2]};
        stateOut[31:0] = {result[0][3], result[1][3], result[2][3], result[3][3]};
    end

endmodule