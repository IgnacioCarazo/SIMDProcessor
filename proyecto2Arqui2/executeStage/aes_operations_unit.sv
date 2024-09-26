module aes_operations_unit (
    input logic [127:0] stateIn,   // 128-bit input state matrix
    input logic [127:0] round,     // 128-bit round input (4-bit index within)
    input logic [2:0] opcode,      // 3-bit opcode to select AES operation
    input logic aesInstEn,         // AES Instruction Enable
    input logic [127:0] roundKey,  // 128-bit round key (for key expansion)
    output logic [127:0] state_out // 128-bit output state matrix
);
   
endmodule