module fetch #(
	 parameter instSize = 24)
	 (
    input logic clk, input logic reset, input logic pcWrEn,
    input logic [instSize - 9:0] newPc,
    output logic [instSize - 1:0] instruction
	);

    logic [instSize - 9:0] pcM4, chosenPc, pc;

    register pcReg(		//PC register
        .clk(clk),
        .reset(reset),
        .dataIn(chosenPc),
        .dataOut(pc) );

	logic pcWrEnDelayed;
	register #(1) pcWr_delay(clk, reset, pcWrEn, pcWrEnDelayed);
	
   assign chosenPc = pcWrEnDelayed ? newPc : pcM4; //Mux
	instruction_memory rom(.address(chosenPc),.rdata(instruction)); //ROM
	assign pcM4 = pc + 4;						  //PC + 4	

endmodule