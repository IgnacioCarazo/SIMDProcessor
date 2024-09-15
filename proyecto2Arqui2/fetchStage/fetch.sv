module fetch #(
	 parameter instructionSize = 24)
	 (
    input logic clk, input logic reset, input logic pcWrEn,
    input logic [instructionSize + 7:0] newPc,
    output logic [instructionSize - 1:0] instruction
	);

    logic [instructionSize + 7:0] pcM4, chosenPc, pc;

    register pcReg(		//PC register
        .clk(clk),
        .reset(reset),
        .data_in(chosenPc),
        .data_out(pc) );

	logic pcWrEnDelayed;
	register #(1) pcWr_delay(clk, reset, pcWrEn, pcWrEnDelayed);
	
    assign chosenPc = pcWrEnDelayed ? newPc : pcM4; //Mux
	instruction_memory rom(.address(chosenPc),.rdata(instruction)); //ROM
	assign pcM4 = pc + 4;						  //PC + 4	

endmodule