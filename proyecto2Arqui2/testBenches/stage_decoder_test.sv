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
		
		// Test CRGS
		instruction = 24'b000000001111000000000010;  // Instrucción para CRGS
		#10;
		$display("CRGS -> PcWriteEn: %b, MemoryWrite: %b, WriteRegFrom: %b, OverWriteNz: %b, RegToWrite: %b, Immediate: %d, RegWriteEnSc: %b, RegWriteEnVec: %b, writeMemFrom: %b",
		PcWriteEn, MemoryWrite, WriteRegFrom, OverWriteNz, RegToWrite, Immediate, RegWriteEnSc, RegWriteEnVec, writeMemFrom);

		// Test SUB
		instruction = 24'b001100001010001100110011;  // Instrucción para SUB
		#10;
		$display("SUB -> PcWriteEn: %b, MemoryWrite: %b, AluOpCode: %b, WriteRegFrom: %b, OverWriteNz: %b, RegToWrite: %b, RegWriteEnSc: %b, RegWriteEnVec: %b, writeMemFrom: %b",
		PcWriteEn, MemoryWrite, AluOpCode, WriteRegFrom, OverWriteNz, RegToWrite, RegWriteEnSc, RegWriteEnVec, writeMemFrom);

		// Test J
		instruction = 24'b101000000101000000010101;  // Instrucción para J
		#10;
		$display("J -> PcWriteEn: %b, MemoryWrite: %b, OverWriteNz: %b, Immediate: %d, RegWriteEnSc: %b, RegWriteEnVec: %b, writeMemFrom: %b",
		PcWriteEn, MemoryWrite, OverWriteNz, Immediate, RegWriteEnSc, RegWriteEnVec, writeMemFrom);

		// Test CMP
		instruction = 24'b100000000100000000010000;  // Instrucción para CMP
		#10;
		$display("CMP -> PcWriteEn: %b, MemoryWrite: %b, OverWriteNz: %b, Immediate: %d, RegWriteEnSc: %b, RegWriteEnVec: %b, writeMemFrom: %b",
		PcWriteEn, MemoryWrite, OverWriteNz, Immediate, RegWriteEnSc, RegWriteEnVec, writeMemFrom);

		// Test XOR
		instruction = 24'b000100001010000100010011;  // Instrucción para XOR
		#10;
		$display("XOR -> PcWriteEn: %b, MemoryWrite: %b, AluOpCode: %b, WriteRegFrom: %b, OverWriteNz: %b, RegToWrite: %b, RegWriteEnSc: %b, RegWriteEnVec: %b, writeMemFrom: %b",
		PcWriteEn, MemoryWrite, AluOpCode, WriteRegFrom, OverWriteNz, RegToWrite, RegWriteEnSc, RegWriteEnVec, writeMemFrom);

		// Test SUM
		instruction = 24'b001000001001000000110010;  // Instrucción para SUM
		#10;
		$display("SUM -> PcWriteEn: %b, MemoryWrite: %b, AluOpCode: %b, WriteRegFrom: %b, OverWriteNz: %b, RegToWrite: %b, RegWriteEnSc: %b, RegWriteEnVec: %b, writeMemFrom: %b",
		PcWriteEn, MemoryWrite, AluOpCode, WriteRegFrom, OverWriteNz, RegToWrite, RegWriteEnSc, RegWriteEnVec, writeMemFrom);

		// Test MUL
		instruction = 24'b010000001010000000100100;  // Instrucción para MUL
		#10;
		$display("MUL -> PcWriteEn: %b, MemoryWrite: %b, AluOpCode: %b, WriteRegFrom: %b, OverWriteNz: %b, RegToWrite: %b, RegWriteEnSc: %b, RegWriteEnVec: %b, writeMemFrom: %b",
		PcWriteEn, MemoryWrite, AluOpCode, WriteRegFrom, OverWriteNz, RegToWrite, RegWriteEnSc, RegWriteEnVec, writeMemFrom);

		// Test SHFD
		instruction = 24'b010100001010000100100101;  // Instrucción para SHFD
		#10;
		$display("SHFD -> PcWriteEn: %b, MemoryWrite: %b, AluOpCode: %b, WriteRegFrom: %b, OverWriteNz: %b, RegToWrite: %b, RegWriteEnSc: %b, RegWriteEnVec: %b, writeMemFrom: %b",
		PcWriteEn, MemoryWrite, AluOpCode, WriteRegFrom, OverWriteNz, RegToWrite, RegWriteEnSc, RegWriteEnVec, writeMemFrom);

		// Test SHFI
		instruction = 24'b011000001011000100100110;  // Instrucción para SHFI
		#10;
		$display("SHFI -> PcWriteEn: %b, MemoryWrite: %b, AluOpCode: %b, WriteRegFrom: %b, OverWriteNz: %b, RegToWrite: %b, RegWriteEnSc: %b, RegWriteEnVec: %b, writeMemFrom: %b",
		PcWriteEn, MemoryWrite, AluOpCode, WriteRegFrom, OverWriteNz, RegToWrite, RegWriteEnSc, RegWriteEnVec, writeMemFrom);

		// Test INC
		instruction = 24'b011100000111000111100111;  // Instrucción para INC
		#10;
		$display("INC -> PcWriteEn: %b, MemoryWrite: %b, AluOpCode: %b, WriteRegFrom: %b, OverWriteNz: %b, RegToWrite: %b, RegWriteEnSc: %b, RegWriteEnVec: %b",
		PcWriteEn, MemoryWrite, AluOpCode, WriteRegFrom, OverWriteNz, RegToWrite, RegWriteEnSc, RegWriteEnVec);

		#20;
		$finish;
    end
endmodule
