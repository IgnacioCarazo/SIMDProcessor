module reg_file #(
    parameter regSize = 16,
    parameter regQuantity = 4,
    parameter selBits = 2, // 3 for 8 registers, 2 for 4 registers, and so on
    parameter vectorSize = 4)
(
    input clk, reset,
    input regWrEnSc, regWrEnVec,
    input [selBits-1:0] rSel1, rSel2,
    input [selBits-1:0] regToWrite,

    input [vectorSize-1:0] [regSize-1:0] dataIn,
    output [vectorSize-1:0] [regSize-1:0] operand1, operand2
);

    logic [regSize-1:0] scalar_reg1Out, scalar_reg2Out;
    logic [vectorSize-1:0] [regSize-1:0] vector_reg1Out, vector_reg2Out;
    logic [vectorSize-1:0] [regSize-1:0] vectorized_scalar_reg1Out, vectorized_scalar_reg2Out;

    scalar_reg_file #(regSize, 16, selBits) scalarRegisters(
        .clk(clk), .reset(reset),
        .regWrEn(regWrEnSc), .rSel1(rSel1), .rSel2(rSel2),
        .regToWrite(regToWrite), .dataIn(dataIn[0]), // For scalars we will just take in consideration the first element
        .reg1Out(scalar_reg1Out), .reg2Out(scalar_reg2Out)
    );

    vector_extender #(vectorSize, regSize) scalar_reg1_extender(
        .inData(scalar_reg1Out), .outData(vectorized_scalar_reg1Out)
    );
    vector_extender #(vectorSize, regSize) scalar_reg2_extender(
        .inData(scalar_reg2Out), .outData(vectorized_scalar_reg2Out)
    );

    vector_reg_file #(
        regSize, regQuantity, selBits-1, vectorSize
    ) vectorialRegisters(
        .clk(clk), .reset(reset),
        .regWrEn(regWrEnVec), .rSel1(rSel1), .rSel2(rSel2), 
        .regToWrite(regToWrite), .regWriteData(dataIn),
        .reg1Out(vector_reg1Out), .reg2Out(vector_reg2Out)
    );

    // MSB as selector for vector/scalar
    assign operand1 = rSel1[selBits-2] ? vectorized_scalar_reg1Out : vector_reg1Out;
    assign operand2 = rSel2[selBits-2] ? vectorized_scalar_reg2Out : vector_reg2Out;
endmodule