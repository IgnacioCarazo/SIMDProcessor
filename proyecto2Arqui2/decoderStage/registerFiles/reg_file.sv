module reg_file #(
    parameter regSize = 128, // Change to 128 bits
    parameter regQuantity = 16,
    parameter selBits = 4
)
(
    input clk, reset,
    input reWrEn, // Only scalar write enable
    input [selBits-1:0] rSel1, rSel2, // Register selection signal for reading.
    input [selBits-1:0] regToWrite, // Register where the new data will be written.

    input [regSize-1:0] dataIn, // 128-bit scalar input data for the registers.
    output [regSize-1:0] operand1, operand2 // 128-bit outputs for the read operands.
);

    logic [regSize-1:0] scalar_reg1Out, scalar_reg2Out;

    scalar_reg_file #(regSize, regQuantity, selBits) scalarRegisters(
        .clk(clk), .reset(reset),
        .regWrEn(reWrEn), .rSel1(rSel1), .rSel2(rSel2),
        .regToWrite(regToWrite), .dataIn(dataIn),
        .reg1Out(scalar_reg1Out), .reg2Out(scalar_reg2Out)
    );

    assign operand1 = scalar_reg1Out;
    assign operand2 = scalar_reg2Out;

endmodule

