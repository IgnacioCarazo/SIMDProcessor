module gf_mult (
    input [7:0] a,    // Byte to multiply
    input [3:0] mult, // Multiplier constant (2, 3, 9, 11, 13, 14)
    output reg [7:0] result
);

    // Intermediate variables for multiplication results
    wire [7:0] a2;  // a multiplied by 2
    wire [7:0] a3;  // a multiplied by 3
    wire [7:0] a9;  // a multiplied by 9
    wire [7:0] a11; // a multiplied by 11
    wire [7:0] a13; // a multiplied by 13
    wire [7:0] a14; // a multiplied by 14

    // Multiply by 2 in GF(2^8)
    assign a2 = (a << 1) ^ ((a[7] == 1'b1) ? 8'h1B : 8'h00);

    // Multiply by 3 in GF(2^8)
    assign a3 = a2 ^ a; // Multiply by 2, then add the original

    // Multiply by 9 in GF(2^8)
    assign a9 = (a << 3) ^ a2; // a * 2^3 + a^2

    // Multiply by 11 in GF(2^8)
    assign a11 = (a << 3) ^ a2 ^ a; // a * 2^3 + a^2 + a

    // Multiply by 13 in GF(2^8)
    assign a13 = (a << 4) ^ a2 ^ (a << 1); // a * 2^4 + a^2 + a * 2

    // Multiply by 14 in GF(2^8)
    assign a14 = (a << 4) ^ a2 ^ (a << 1) ^ a; // a * 2^4 + a^2 + a * 2 + a

    // Select result based on multiplier
    always @(*) begin
        case (mult)
            4'd2:  result = a2;
            4'd3:  result = a3;
            4'd9:  result = a9;
            4'd11: result = a11;
            4'd13: result = a13;
            4'd14: result = a14;
            default: result = 8'h00; // Default case to avoid latches
        endcase
    end
endmodule