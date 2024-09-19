module execute #(
	parameter regSize = 32,
	parameter vecSize = 4
)
(
	input logic clk, reset, overwriteFlags,
    input logic [2:0] pcWrEn,
    input logic [2:0] ExecuteOp,
    // input [regSize-1:0] scalar1, scalar2
    // input [regSize-1:0] scalarOut
	input logic [vecSize-1:0] [regSize-1:0] vect1, vect2,
	output logic [vecSize-1:0] [regSize-1:0] vectOut,
    output logic pcWrEnOut
);

    logic [1:0] NZ_flags;
    logic [vecSize-1:0] negativeFlags, zeroFlags;

    generate // Se crean alus igual al numero de vecSize, una para cada posición del vector.
        genvar i;
        for (i = 0; i < vecSize; i = i + 1) begin : alu_block
            alu #(
                .dataSize(regSize)
            ) alu (
                .operation_select(ExecuteOp), .operand1(vect1[i]),
                .operand2(vect2[i]), .result(vectOut[i]),
                .negFlag(negativeFlags[i]), .zeroFlag(zeroFlags[i])
            );
        end
    endgenerate
    
    register #(1) negative_flag_register (
        .clk(clk & overwriteFlags), .reset(reset),
        .dataIn(|negativeFlags), .dataOut(NZ_flags[0])
    );

    register #(1) zeroFlag_register (
        .clk(clk & overwriteFlags), .reset(reset),
        .dataIn(&zeroFlags), .dataOut(NZ_flags[1])
    );

    assign pcWrEnOut = pcWrEn == 3'b100 ? ~NZ_flags[1] :
                        pcWrEn == 3'b010 ? NZ_flags[1] :
                        pcWrEn == 3'b001 ? NZ_flags[0] :
                        0;

endmodule