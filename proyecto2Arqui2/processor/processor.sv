module processor #(
	 parameter instSize = 24,
    parameter regSize = 16,
    parameter regQuantity = 4,
    parameter selBits = 4,
    parameter vecSize = 4
) (input clk, rst);

	//Global variables
	logic [instSize -1:0] instructionDecode;
	logic [vecSize-1:0] [regSize-1:0] writeBackDataMem, writeBackDataChip;
	logic regWriteEnScChip, regWriteEnVecChip;	
	logic [3:0] RegToWriteChip;
  

	// Matriz de ceros
	// Inicializar la matriz a cero
	logic [vecSize-1:0] [regSize-1:0] matrix_zero, matrix_zero_b, matrix_zero_c, matrix_zero_d, matrix_zero_e, matrix_zero_f;
	
	
    // Fetch Stage
	 
	 logic PCWrEnMem;
    logic [instSize-1:0] instructionFetch;
	fetch fetch_stage(
        .clk(clk), .reset(rst), .newPc(writeBackDataMem[0]),
        .pcWrEn(PCWrEnMem), .instruction(instructionFetch)
			);
	
	pipe #(instSize) p_fetchDecode(clk, rst, instructionFetch, instructionDecode);
	
    // Decode Stage
	 
    logic [2:0] pcWrEnDecode;
    logic OverWriteNzDecode, MemoryWriteDecode, regWriteEnScDecode,
          regWriteEnVecDecode, writeMemFromDecode;
    logic [1:0] writeRegFromDecode;
    logic [3:0] RegToWriteDecode;
    logic [regSize-1:0] ImmediateDecode;
    logic [2:0] AluOpCodeDecode;
	 logic [vecSize-1:0] [regSize-1:0] operand1Decode, operand2Decode;

	decoder #(instSize, regSize) decoder_stage
			(
        .instruction(instructionDecode), .MemoryWrite(MemoryWriteDecode),
        .WriteRegFrom(writeRegFromDecode), .RegToWrite(RegToWriteDecode),
        .Immediate(ImmediateDecode), .RegWriteEnSc(regWriteEnScDecode),
        .RegWriteEnVec(regWriteEnVecDecode), .PcWriteEn(pcWrEnDecode),
        .OverWriteNz(OverWriteNzDecode), .AluOpCode(AluOpCodeDecode),
        .writeMemFrom(writeMemFromDecode));

    
    reg_file #(
        .regSize(regSize), .regQuantity(regQuantity),
        .selBits(selBits), .vecSize(vecSize)
    ) registerFile(
        .clk(clk), .reset(rst), .regWrEnScalar(regWriteEnScChip),
        .regWrEnVector(regWriteEnVecChip), .rSel1(instructionDecode[instSize - 5: instSize - 8]),
        .rSel2(instructionDecode[instSize - 9: instSize - 12]), .regToWrite(RegToWriteChip),
        .dataIn(writeBackDataMem), .operand1(operand1Decode), .operand2(operand2Decode)
    );
	 
	// Pipe between Decode and Execute
	logic [regSize-1+17:0] condensedDecodeIn, condensedDecodeOut;
	assign condensedDecodeIn = {MemoryWriteDecode, writeRegFromDecode,
                                  RegToWriteDecode, ImmediateDecode,
                                  regWriteEnScDecode, regWriteEnVecDecode,
                                  pcWrEnDecode, OverWriteNzDecode,
                                  AluOpCodeDecode, writeMemFromDecode};
	logic [vecSize-1:0] [regSize-1:0] operand1Execute, operand2Execute;

 	pipe_vect #(
        regSize+17, regSize, vecSize
    ) pDecodeExecute(
        clk, rst, condensedDecodeIn, operand1Decode, operand2Decode, matrix_zero,
        condensedDecodeOut, operand1Execute, operand2Execute, matrix_zero
    );
	
	
    // Execute Stage
	 
	 logic MemoryWriteExecute, regWriteEnScExecute, regWriteEnVecExecute, OverWriteNzExecute,
          writeMemFromExecute;
    logic [1:0] writeRegFromExecute;
    logic [2:0] pcWrEnExecute, AluOpCodeExecute;
    logic [3:0] RegToWriteExecute;
    logic [regSize-1:0] ImmediateExecute;
	assign {MemoryWriteExecute, writeRegFromExecute,
            RegToWriteExecute, ImmediateExecute,
            regWriteEnScExecute, regWriteEnVecExecute,
            pcWrEnExecute, OverWriteNzExecute,
            AluOpCodeExecute, writeMemFromExecute} = condensedDecodeOut;
	logic [vecSize-1:0] [regSize-1:0] resultExecute, aluResultMem;
   logic pcWrEnExecuteOut;
	execute #(.regSize(regSize),.vecSize(vecSize)) execute_stage
	(   
        .clk(clk), .reset(rst), .overwriteFlags(OverWriteNzExecute),
        .ExecuteOp(AluOpCodeExecute), .pcWrEn(pcWrEnExecute), .vect1(operand1Execute), 
        .vect2(operand2Execute), .vectOut(resultExecute), .pcWrEnOut(pcWrEnExecuteOut)
    );
	
	
	 //Pipe between Execute and Memory-Writeback
	 
	 logic [regSize-1+11:0] condensedMemoryIn, condensedMemoryOut;
	 logic [vecSize-1:0] [regSize-1:0] operand1Memory, operand2Memory;
	 assign condensedMemoryIn =  {MemoryWriteExecute, ImmediateExecute, writeRegFromExecute,
                                 RegToWriteExecute, pcWrEnExecuteOut, regWriteEnScExecute, 
                                 regWriteEnVecExecute, writeMemFromExecute};
	 pipe_vect #(regSize+11, regSize, vecSize) pExecuteMemory(clk, rst, condensedMemoryIn, resultExecute, operand2Execute, operand1Execute, 
																						condensedMemoryOut, aluResultMem, operand2Memory, operand1Memory);
						
	
    // Writeback Stage
	 
	logic MemoryWriteMemory, regWriteEnScMemory, regWriteEnVecMemory, writeMemFromMemory;
	logic [1:0] WriteRegFromMemory; 
	logic [3:0] RegToWriteMemory;
	logic [regSize-1:0] ImmediateMemory;

    assign {MemoryWriteMemory, ImmediateMemory, WriteRegFromMemory, RegToWriteMemory,
			PCWrEnMem, regWriteEnScMemory, regWriteEnVecMemory,
            writeMemFromMemory} = condensedMemoryOut;
    writeback #(
        .vecSize(vecSize), .regSize(regSize)
    ) writeback_stage (
        .clk(clk), .reset(rst), .writeEnable(MemoryWriteMemory), .aluOperand2(operand2Memory),
        .writeRegFrom(WriteRegFromMemory),
        .imm(ImmediateMemory), .aluOperand1(operand1Memory), .writeMemFrom(writeMemFromMemory),
        .aluResult(aluResultMem), .writeBackData(writeBackDataMem)
    );
	 
	 
	 
	 // Pipe between Memory-Writeback and Chip
	 logic [5:0] condensedChipIn, condensedChipOut;
	 assign condensedChipIn = {RegToWriteMemory, regWriteEnVecMemory, regWriteEnScMemory};
	 pipe_vect #(6, regSize, vecSize) pMemory_chip(clk, rst, condensedChipIn, writeBackDataMem, matrix_zero_b, matrix_zero_c,
																			condensedChipOut, writeBackDataChip, matrix_zero_b, matrix_zero_c);

	 assign {RegToWriteChip, regWriteEnVecChip, regWriteEnScChip} = condensedChipOut;

	 
endmodule