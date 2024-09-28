module vector_reg_file #(
    parameter regSize = 16,
    parameter regQuantity = 4,
    parameter selBits = 2,
    parameter vecSize = 4
) (
    input clk, reset,
    input regWrEn,
    input [selBits-1:0] rSel1, rSel2, regToWrite,
    input [vecSize-1:0] [regSize-1:0] regWriteData,
    output [vecSize-1:0] [regSize-1:0] reg1Out,
    output [vecSize-1:0] [regSize-1:0] reg2Out
);
    logic [regQuantity-1:0] reg_N_WrEn;
    logic [regQuantity-1:0] [vecSize-1:0] [regSize-1:0] reg_NOut;

    logic_decoder #(.in(selBits), .out(regQuantity)) regWrDecoder(
        .sel(regToWrite), .dataOut(reg_N_WrEn)
    );

    generate
        genvar j;
        genvar i;
        for (j = 0; j < vecSize; j = j + 1) begin: VECTOR_BLOCK
            for (i = 0; i < regQuantity; i = i + 1) begin: REGISTER_BLOCK
                register #(regSize) r (
                    .clk(clk & reg_N_WrEn[i] & regWrEn), .reset(reset),
                    .dataIn(regWriteData[j]), .dataOut(reg_NOut[i][j])
                );
            end
        end
    endgenerate


    generate
        genvar k;
        for (k = 0; k < vecSize; k = k + 1) begin: OUT_VECTOR_BLOCK
            assign reg1Out[k] = reg_NOut[rSel1][k];
            assign reg2Out[k] = reg_NOut[rSel2][k];
        end
    endgenerate

endmodule