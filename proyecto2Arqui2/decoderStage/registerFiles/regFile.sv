module regFile #(
    parameter registerSize = 8,
    parameter registerQuantity = 4,
    parameter selectionBits = 2, 
    parameter vecSize = 16)
(
    input clk, reset,
    input regWrEnSc, regWrEnVec, // Enable signals for writing to scalar and vector registers.
    input [selectionBits-1:0] rSel1, rSel2, // Register selection signal for reading.
    input [selectionBits-1:0] regToWrite, // Register where the new data will be written.

    input [vecSize-1:0] [registerSize-1:0] dataIn, // Input data for the registers, with a vector size. Scalars just first element
    output [vecSize-1:0] [registerSize-1:0] operand1, operand2 // First output data for the read operands, with a vector size.
);

    logic [registerSize-1:0] scalar_reg1Out, scalar_reg2Out;
    logic [vecSize-1:0] [registerSize-1:0] vector_reg1Out, vector_reg2Out; 
    logic [vecSize-1:0] [registerSize-1:0] vectorized_scalar_reg1Out, vectorized_scalar_reg2Out;

    scalar_reg_file #(registerSize, 16, selectionBits) scalarRegisters(
        .clk(clk), .reset(reset),
        .regWrEn(regWrEnSc), .rSel1(rSel1), .rSel2(rSel2),
        .regToWrite(regToWrite), .dataIn(dataIn[0]),
        .reg1Out(scalar_reg1Out), .reg2Out(scalar_reg2Out)
    );

    vector_extender #(vecSize, registerSize) scalar_reg1Executetender(
        .inData(scalar_reg1Out), .outData(vectorized_scalar_reg1Out) // Vectorizes the scalar across all elements of a vector
    );
    vector_extender #(vecSize, registerSize) scalar_reg2Executetender(
        .inData(scalar_reg2Out), .outData(vectorized_scalar_reg2Out) // Vectorizes the scalar across all elements of a vector
    );

    
    vector_reg_file #(
        registerSize, registerQuantity, selectionBits-1, vecSize
    ) vectorialRegisters(
        .clk(clk), .reset(reset),
        .regWrEn(regWrEnVec), .rSel1(rSel1), .rSel2(rSel2), 
        .regToWrite(regToWrite), .regWriteData(dataIn),
        .reg1Out(vector_reg1Out), .reg2Out(vector_reg2Out)
    );

     // MSB selects between vector and scalar
    assign operand1 = rSel1[selectionBits-2] ? vectorized_scalar_reg1Out : vector_reg1Out;
    assign operand2 = rSel2[selectionBits-2] ? vectorized_scalar_reg2Out : vector_reg2Out;
endmodule