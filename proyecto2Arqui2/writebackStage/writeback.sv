module writeback #(
    parameter vecSize = 4,
    parameter regSize = 16
) (
   input clk, reset, writeEnable, writeMemFrom,
   input [1:0] writeRegFrom,
   input [regSize-1:0] imm,
   input [vecSize-1:0] [regSize-1:0] aluResult, aluOperand2, aluOperand1,
   output [vecSize-1:0] [regSize-1:0] writeBackData
);
    
    logic [vecSize-1:0] [regSize-1:0] extended_imm, imm_delayed,
        writeData_delayed, writeData, matrix_zero;
    logic [vecSize-1:0] [7:0] readData;
    logic [regSize-1:0] address;
	logic [1:0] writeRegFrom_delayed;

	  // TODO: Does this aluOperand2 has to be delayed as well?
    assign address = writeMemFrom ? aluOperand2[0] : imm;
	assign writeData = writeMemFrom ? aluOperand1 : aluResult;
	 
	 
	pipe_vect #(2, regSize, vecSize) pMemory_chip(clk, rst, writeRegFrom, writeData, extended_imm, matrix_zero,
													 writeRegFrom_delayed, writeData_delayed, imm_delayed, matrix_zero);

    dataMemoryory #(
        .dataSize(8),
        .addressingSize(regSize),
        .vecSize(vecSize)
    ) dataMemory (
        .clk(clk),
        .write_enable(writeEnable), .DataAdr(address),
        .toWrite_data({
            writeData[3][7:0], writeData[2][7:0],
            writeData[1][7:0], writeData[0][7:0]
        }),
        .read_data(readData)
    );

    vector_extender #(
        .vecSize(vecSize), .dataSize(regSize)
    ) immExtender (
        .inData(imm), .outData(extended_imm)
    );
	  
	  logic [vecSize-1:0] [regSize-1:0] writeBackDataTMP;
	 always_comb begin
		case (writeRegFrom_delayed)
			0:begin 
                writeBackDataTMP[0][7:0] = readData[0];
                writeBackDataTMP[1][7:0] = readData[1];
                writeBackDataTMP[2][7:0] = readData[2];
                writeBackDataTMP[3][7:0] = readData[3];
            end 
			1: writeBackDataTMP = writeData_delayed;
			2: writeBackDataTMP = imm_delayed;
		endcase
	 end 
	 assign writeBackData = writeBackDataTMP;

endmodule