module xor_32bit (
    input logic [31:0] a,      // First 32-bit input
    input logic [31:0] b,      // Second 32-bit input
    output logic [31:0] result  // 32-bit output
);

    always_comb begin
        result = a ^ b; // Perform bitwise XOR
    end

endmodule