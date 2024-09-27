module stage_decoder_test();
	// Variables del testbench
	logic [23:0] instruction;
	logic MemoryWrite;
	logic [1:0] WriteRegFrom;
	logic [3:0] RegToWrite;
	logic [15:0] Immediate;
	logic writeMemFrom;
	logic RegWriteEnSc;
	logic RegWriteEnVec;
	logic OverWriteNz;
	logic [2:0] PcWriteEn;
	logic [2:0] AluOpCode;

	// Instancia del módulo decoderStage
	decoder Decoder(.instruction(instruction),
                    .MemoryWrite(MemoryWrite),
                    .WriteRegFrom(WriteRegFrom),
                    .RegToWrite(RegToWrite),
                    .Immediate(Immediate),
                    .writeMemFrom(writeMemFrom),
                    .RegWriteEnSc(RegWriteEnSc),
                    .RegWriteEnVec(RegWriteEnVec),
                    .PcWriteEn(PcWriteEn),
                    .AluOpCode(AluOpCode),
                    .OverWriteNz(OverWriteNz));
	initial begin
		instruction = 0;
      // Tests:
      #10;
		// Test LMEM
		instruction = 24'b111100001111000011110000;  // Instrucción para LMEM
		#10;
		$display("LMEM -> PcWriteEn: %b, MemoryWrite: %b, WriteRegFrom: %b, OverWriteNz: %b, RegToWrite: %b, Immediate: %d, RegWriteEnSc: %b, RegWriteEnVec: %b, writeMemFrom: %b",
		PcWriteEn, MemoryWrite, WriteRegFrom, OverWriteNz, RegToWrite, Immediate, RegWriteEnSc, RegWriteEnVec, writeMemFrom);

		// Test LOSC
		instruction = 24'b000000001111000000000010;  // Instrucción para LOSC
		#10;
		$display("LOSC -> PcWriteEn: %b, MemoryWrite: %b, WriteRegFrom: %b, OverWriteNz: %b, RegToWrite: %b, Immediate: %d, RegWriteEnSc: %b, RegWriteEnVec: %b, writeMemFrom: %b",
		PcWriteEn, MemoryWrite, WriteRegFrom, OverWriteNz, RegToWrite, Immediate, RegWriteEnSc, RegWriteEnVec, writeMemFrom);

		// Test DCAE (SUB)
		instruction = 24'b001100001010001100110011;  // Instrucción para SUB (DCAE)
		#10;
		$display("DCAE -> PcWriteEn: %b, MemoryWrite: %b, AluOpCode: %b, WriteRegFrom: %b, OverWriteNz: %b, RegToWrite: %b, RegWriteEnSc: %b, RegWriteEnVec: %b, writeMemFrom: %b",
		PcWriteEn, MemoryWrite, AluOpCode, WriteRegFrom, OverWriteNz, RegToWrite, RegWriteEnSc, RegWriteEnVec, writeMemFrom);

		// Test JMP
		instruction = 24'b101000000101000000010101;  // Instrucción para JMP
		#10;
		$display("JMP -> PcWriteEn: %b, MemoryWrite: %b, OverWriteNz: %b, Immediate: %d, RegWriteEnSc: %b, RegWriteEnVec: %b, writeMemFrom: %b",
		PcWriteEn, MemoryWrite, OverWriteNz, Immediate, RegWriteEnSc, RegWriteEnVec, writeMemFrom);

		// Test JE
		instruction = 24'b100000000100000000010000;  // Instrucción para JE
		#10;
		$display("JE -> PcWriteEn: %b, MemoryWrite: %b, OverWriteNz: %b, Immediate: %d, RegWriteEnSc: %b, RegWriteEnVec: %b, writeMemFrom: %b",
		PcWriteEn, MemoryWrite, OverWriteNz, Immediate, RegWriteEnSc, RegWriteEnVec, writeMemFrom);

		// Test JNE
		instruction = 24'b100100000100000000110010;  // Instrucción para JNE
		#10;
		$display("JNE -> PcWriteEn: %b, MemoryWrite: %b, OverWriteNz: %b, Immediate: %d, RegWriteEnSc: %b, RegWriteEnVec: %b, writeMemFrom: %b",
		PcWriteEn, MemoryWrite, OverWriteNz, Immediate, RegWriteEnSc, RegWriteEnVec, writeMemFrom);

		// Test XOR
		instruction = 24'b000100001010000100010011;  // Instrucción para XOR
		#10;
		$display("XOR -> PcWriteEn: %b, MemoryWrite: %b, AluOpCode: %b, WriteRegFrom: %b, OverWriteNz: %b, RegToWrite: %b, RegWriteEnSc: %b, RegWriteEnVec: %b, writeMemFrom: %b",
		PcWriteEn, MemoryWrite, AluOpCode, WriteRegFrom, OverWriteNz, RegToWrite, RegWriteEnSc, RegWriteEnVec, writeMemFrom);

		// Test ECAE (ADD)
		instruction = 24'b001000001001000000110010;  // Instrucción para ADD (ECAE)
		#10;
		$display("ECAE -> PcWriteEn: %b, MemoryWrite: %b, AluOpCode: %b, WriteRegFrom: %b, OverWriteNz: %b, RegToWrite: %b, RegWriteEnSc: %b, RegWriteEnVec: %b, writeMemFrom: %b",
		PcWriteEn, MemoryWrite, AluOpCode, WriteRegFrom, OverWriteNz, RegToWrite, RegWriteEnSc, RegWriteEnVec, writeMemFrom);

		// Test MUL
		instruction = 24'b010000001010000000100100;  // Instrucción para MUL
		#10;
		$display("MUL -> PcWriteEn: %b, MemoryWrite: %b, AluOpCode: %b, WriteRegFrom: %b, OverWriteNz: %b, RegToWrite: %b, RegWriteEnSc: %b, RegWriteEnVec: %b, writeMemFrom: %b",
		PcWriteEn, MemoryWrite, AluOpCode, WriteRegFrom, OverWriteNz, RegToWrite, RegWriteEnSc, RegWriteEnVec, writeMemFrom);

		// Test RSHF
		instruction = 24'b010100001010000100100101;  // Instrucción para RSHF
		#10;
		$display("RSHF -> PcWriteEn: %b, MemoryWrite: %b, AluOpCode: %b, WriteRegFrom: %b, OverWriteNz: %b, RegToWrite: %b, RegWriteEnSc: %b, RegWriteEnVec: %b, writeMemFrom: %b",
		PcWriteEn, MemoryWrite, AluOpCode, WriteRegFrom, OverWriteNz, RegToWrite, RegWriteEnSc, RegWriteEnVec, writeMemFrom);

		// Test LSHF
		instruction = 24'b011000001011000100100110;  // Instrucción para LSHF
		#10;
		$display("LSHF -> PcWriteEn: %b, MemoryWrite: %b, AluOpCode: %b, WriteRegFrom: %b, OverWriteNz: %b, RegToWrite: %b, RegWriteEnSc: %b, RegWriteEnVec: %b, writeMemFrom: %b",
		PcWriteEn, MemoryWrite, AluOpCode, WriteRegFrom, OverWriteNz, RegToWrite, RegWriteEnSc, RegWriteEnVec, writeMemFrom);

		// Test INC
		instruction = 24'b011100000111000111100111;  // Instrucción para INC
		#10;
		$display("INC -> PcWriteEn: %b, MemoryWrite: %b, AluOpCode: %b, WriteRegFrom: %b, OverWriteNz: %b, RegToWrite: %b, RegWriteEnSc: %b, RegWriteEnVec: %b",
		PcWriteEn, MemoryWrite, AluOpCode, WriteRegFrom, OverWriteNz, RegToWrite, RegWriteEnSc, RegWriteEnVec);

		// Test LOPIX
		instruction = 24'b110100001010000010100101;  // Instrucción para LOPIX
		#10;
		$display("LOPIX -> PcWriteEn: %b, MemoryWrite: %b, WriteRegFrom: %b, OverWriteNz: %b, RegToWrite: %b, RegWriteEnSc: %b, RegWriteEnVec: %b, writeMemFrom: %b",
		PcWriteEn, MemoryWrite, AluOpCode, WriteRegFrom, OverWriteNz, RegToWrite, RegWriteEnSc, RegWriteEnVec);

		#20;
		$finish;
    end
endmodule
