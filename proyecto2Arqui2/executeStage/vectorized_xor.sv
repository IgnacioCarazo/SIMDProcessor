module vectorized_xor #(
    parameter regSize = 8, 
    parameter vecSize = 16 
) (
    input logic [regSize-1:0] vectA[vecSize-1:0], 
    input logic [regSize-1:0] vectB[vecSize-1:0], 
    output logic [regSize-1:0] result[vecSize-1:0] 
);

    always_comb begin
        for (int i = 0; i < vecSize; i++) begin
            result[i] = vectA[i] ^ vectB[i]; // XOR each row
        end
    end
endmodule
