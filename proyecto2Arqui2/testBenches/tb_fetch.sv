module tb_fetch;
    logic clk, reset, pcWrEn;
    logic [15:0] newPc;  
    logic [23:0] instruction;

    fetch uut(
        .clk(clk), 
        .reset(reset),
        .pcWrEn(pcWrEn), 
        .newPc(newPc),  // Pass the correct size for newPc
        .instruction(instruction)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        pcWrEn = 0;
		  
        #10 
        reset = 0;
		  
		  assert(instruction == 24'h123456) else $error("Test Case 1 Failed: Expected 123456 but got %h", instruction);
            
        #10
		  
        assert(instruction == 24'h789101) else $error("Test Case 2 Failed: Expected 789101 but got %h", instruction);
        
		  #5
        pcWrEn = 1;
        newPc = 16'h01;        
		  #5
		  
        assert(instruction == 24'h112131) else $error("Test Case 3 Failed: Instruction override wrong", instruction);        
        #5        
		  
		  pcWrEn = 0;
		  #50;
		  $finish;
        
    end

endmodule