module reg_file #(
    parameter regSize = 16,
    parameter regQuantity = 4,
    parameter selBits = 2, 
    parameter vecSize = 1)
(
    input clk, rst,
    input regWrEnScalar, regWrEnVector, // Enable signals for writing to scalar and vector registers.
    input [selBits-1:0] rSel1, rSel2, // Register selection signal for reading.
    input [selBits-1:0] regToWrite, // Register where the new data will be written.

    input [vecSize-1:0] [regSize-1:0] dataIn, // Input data for the registers, with a vector size. Scalars just first element
    output [vecSize-1:0] [regSize-1:0] operand1, operand2 // First output data for the read operands, with a vector size.
);

    logic [regSize-1:0] scalar_reg1Out, scalar_reg2Out;
    logic [vecSize-1:0] [regSize-1:0] vector_reg1Out, vector_reg2Out; 
    logic [vecSize-1:0] [regSize-1:0] vectorized_scalar_reg1Out, vectorized_scalar_reg2Out;

    scalar_reg_file #(regSize, 16, selBits) scalarRegisters(
        .clk(clk), .rst(rst),
        .regWrEn(regWrEnScalar), .rSel1(rSel1), .rSel2(rSel2),
        .regToWrite(regToWrite), .dataIn(dataIn[0]),
        .reg1Out(scalar_reg1Out), .reg2Out(scalar_reg2Out)
    );

    vector_extender #(vecSize, regSize) scalar_reg1_extender(
        .inData(scalar_reg1Out), .outData(vectorized_scalar_reg1Out) // Vectorizes the scalar across all elements of a vector
    );
    vector_extender #(vecSize, regSize) scalar_reg2_extender(
        .inData(scalar_reg2Out), .outData(vectorized_scalar_reg2Out) // Vectorizes the scalar across all elements of a vector
    );

    vector_reg_file #(
        regSize, regQuantity, selBits-1, vecSize
    ) vectorialRegisters(
        .clk(clk), .rst(rst),
        .regWrEn(regWrEnVector), .rSel1(rSel1), .rSel2(rSel2), 
        .regToWrite(regToWrite), .regWriteData(dataIn),
        .reg1Out(vector_reg1Out), .reg2Out(vector_reg2Out)
    );

     // MSB selects between vector and scalar
    assign operand1 = rSel1[selBits-2] ? vectorized_scalar_reg1Out : vector_reg1Out;
    assign operand2 = rSel2[selBits-2] ? vectorized_scalar_reg2Out : vector_reg2Out;
endmodule