module stage_execute_test #(
    parameter vecSize = 4,
    parameter regSize = 8
)();

	logic clk, reset, overwriteFlags, pcWrEnOut;
    logic [2:0] PCWrEn;
    logic [2:0] ExecuteOp;
	logic [vecSize-1:0] [regSize-1:0] vect1, vect2;
	logic [vecSize-1:0] [regSize-1:0] vectOut;
    logic [1:0] NZ_flags;

    execute #(
        .vecSize(vecSize),
        .regSize(regSize)
    ) dut (
        .clk(clk),
        .reset(reset),
        .ExecuteOp(ExecuteOp),
        .pcWrEn(PCWrEn),
        .overwriteFlags(overwriteFlags),
        .vect1(vect1),
        .vect2(vect2),
        .vectOut(vectOut),
        .pcWrEnOut(pcWrEnOut)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 0;
        ExecuteOp = 0;
        PCWrEn = 0;
        overwriteFlags = 1;
        vect1 = 0;
        vect2 = 0;

        #10;
        reset = 1;
        #10;
        reset = 0;

         // Execute operations
        
        // Operation 1: XOR
        ExecuteOp = 3'b001;
        
        vect1[0] = 8'b00110011;
        vect1[1] = 8'b11001100;
        vect1[2] = 8'b10101010;
        vect1[3] = 8'b01010101;
        
        vect2[0] = 8'b00001111;
        vect2[1] = 8'b11110000;
        vect2[2] = 8'b01010101;
        vect2[3] = 8'b10101010;
        
        // Wait for execution
        #20;
        
        // Check results
        assert(vectOut[0] == 8'b00111100) else $error("Operation 1: Incorrect result for vectOut[0] = %b", vectOut[0]);
        assert(vectOut[1] == 8'b00111100) else $error("Operation 1: Incorrect result for vectOut[1] = %b", vectOut[1]);
        assert(vectOut[2] == 8'b11111111) else $error("Operation 1: Incorrect result for vectOut[2] = %b", vectOut[2]);
        assert(vectOut[3] == 8'b11111111) else $error("Operation 1: Incorrect result for vectOut[3] = %b", vectOut[3]);
        
        #10;

        // Operation 2: Addition
        ExecuteOp = 3'b010;
        
        vect1[0] = 8'b00110011;
        vect1[1] = 8'b11001100;
        vect1[2] = 8'b10101010;
        vect1[3] = 8'b01010101;

        vect2[0] = 8'b00001111;
        vect2[1] = 8'b11110000;
        vect2[2] = 8'b01010101;
        vect2[3] = 8'b10101010;
        
        // Wait for execution
        #20;
        
        // Check results
        assert(vectOut[0] == 8'b01000010) else $error("Operation 2: Incorrect result for vectOut[0]");
        assert(vectOut[1] == 8'b10111100) else $error("Operation 2: Incorrect result for vectOut[1]");
        assert(vectOut[2] == 8'b11111111) else $error("Operation 2: Incorrect result for vectOut[2]");
        assert(vectOut[3] == 8'b11111111) else $error("Operation 2: Incorrect result for vectOut[3]");
        
        #10;
        
        // Operation 3: Subtraction
        ExecuteOp = 3'b011;
        
        vect1[0] = 8'b00110011;
        vect1[1] = 8'b11001100;
        vect1[2] = 8'b10101010;
        vect1[3] = 8'b01010101;
        
        vect2[0] = 8'b00001111;
        vect2[1] = 8'b11110000;
        vect2[2] = 8'b01010101;
        vect2[3] = 8'b10101010;
        
        // Wait for execution
        #20;
        
        // Check results
        assert(vectOut[0] == 8'b00100100) else $error("Operation 3: Incorrect result for vectOut[0]");
        assert(vectOut[1] == 8'b11011100) else $error("Operation 3: Incorrect result for vectOut[1]");
        assert(vectOut[2] == 8'b01010101) else $error("Operation 3: Incorrect result for vectOut[2]");
        assert(vectOut[3] == 8'b10101011) else $error("Operation 3: Incorrect result for vectOut[3]");
        
        #10;
        
        // Operation 4: Multiplication
        ExecuteOp = 3'b100;
        
        vect1[0] = 8'b00000011;
        vect1[1] = 8'b00001100;
        vect1[2] = 8'b00001010;
        vect1[3] = 8'b00000101;
        
        vect2[0] = 8'b00001111;
        vect2[1] = 8'b00000000;
        vect2[2] = 8'b00000101;
        vect2[3] = 8'b00001010;
        
        // Wait for execution
        #20;

        // Check results
        assert(vectOut[0] == 8'b00101101) else $error("Operation 4: Incorrect result for vectOut[0]");
        assert(vectOut[1] == 8'b00000000) else $error("Operation 4: Incorrect result for vectOut[1]");
        assert(vectOut[2] == 8'b00110010) else $error("Operation 4: Incorrect result for vectOut[2]");
        assert(vectOut[3] == 8'b00110010) else $error("Operation 4: Incorrect result for vectOut[3]");
        
        #10;
        
        // Operation 5: Right Shift
        ExecuteOp = 3'b101;

        vect1[0] = 8'b10101010;
        vect1[1] = 8'b01010101;
        vect1[2] = 8'b11110000;
        vect1[3] = 8'b00001111;

        vect2[0] = 3'b001;
        vect2[1] = 3'b010;
        vect2[2] = 3'b011;
        vect2[3] = 3'b100;

        // Wait for execution
        #20;

        // Check results
        assert(vectOut[0] == 8'b01010101) else $error("Operation 5: Incorrect result for vectOut[0] = %b", vectOut[0]);
        assert(vectOut[1] == 8'b00010101) else $error("Operation 5: Incorrect result for vectOut[1] = %b", vectOut[1]);
        assert(vectOut[2] == 8'b00011110) else $error("Operation 5: Incorrect result for vectOut[2] = %b", vectOut[2]);
        assert(vectOut[3] == 8'b00000000) else $error("Operation 5: Incorrect result for vectOut[3] = %b", vectOut[3]);

        #10;

        // Operation 6: Left Shift
        ExecuteOp = 3'b110;

        vect1[0] = 8'b10101010;
        vect1[1] = 8'b01010101;
        vect1[2] = 8'b11110000;
        vect1[3] = 8'b00001111;

        vect2[0] = 3'b001;
        vect2[1] = 3'b010;
        vect2[2] = 3'b011;
        vect2[3] = 3'b100;

        // Wait for execution
        #20;

        // Check results
        assert(vectOut[0] == 8'b01010100) else $error("Operation 6: Incorrect result for vectOut[0] = %b", vectOut[0]);
        assert(vectOut[1] == 8'b01010100) else $error("Operation 6: Incorrect result for vectOut[1] = %b", vectOut[1]);
        assert(vectOut[2] == 8'b10000000) else $error("Operation 6: Incorrect result for vectOut[2] = %b", vectOut[2]);
        assert(vectOut[3] == 8'b11110000) else $error("Operation 6: Incorrect result for vectOut[3] = %b", vectOut[3]);

        #10;

        // Test 7: Zero flag
        ExecuteOp = 3'b011;
        
        vect1[0] = 8'b00110011;
        vect1[1] = 8'b11001100;
        vect1[2] = 8'b10101010;
        vect1[3] = 8'b01010101;
        
        vect2[0] = 8'b00110011;
        vect2[1] = 8'b11001100;
        vect2[2] = 8'b10101010;
        vect2[3] = 8'b01010101;
        #10;
        // Check results
        assert(vectOut[0] == 0) else $error("Test 7: Incorrect result for vectOut[0]");
        assert(vectOut[1] == 0) else $error("Test 7: Incorrect result for vectOut[1]");
        assert(vectOut[2] == 0) else $error("Test 7: Incorrect result for vectOut[2]");
        assert(vectOut[3] == 0) else $error("Test 7: Incorrect result for vectOut[3]");

        #10;

        // Test 8 : Inconditional jump
        PCWrEn = 3'b100;
        #10;
        assert(pcWrEnOut == 1) else $error("Test 8: Incorrect pcWrEnOut");
        #10;
        
        // Test 9: Jump on Zero
        PCWrEn = 3'b010;
        ExecuteOp = 3'b011;
        
        vect1[0] = 8'b00110011;
        vect1[1] = 8'b11001100;
        vect1[2] = 8'b10101010;
        vect1[3] = 8'b01010101;
        
        vect2[0] = 8'b00110011;
        vect2[1] = 8'b11001100;
        vect2[2] = 8'b10101010;
        vect2[3] = 8'b01010101;
        #10;
        // Check results
        assert(vectOut[0] == 0) else $error("Test 7: Incorrect result for vectOut[0]");
        assert(vectOut[1] == 0) else $error("Test 7: Incorrect result for vectOut[1]");
        assert(vectOut[2] == 0) else $error("Test 7: Incorrect result for vectOut[2]");
        assert(vectOut[3] == 0) else $error("Test 7: Incorrect result for vectOut[3]");

        assert(pcWrEnOut == 1) else $error("Test 9: Incorrect pcWrEnOut");

        // Test 10: Jump on negative
        PCWrEn = 3'b001;
        ExecuteOp = 3'b011;
        
        vect1[0] = 8'b00110011;
        vect1[1] = 8'b11001100;
        vect1[2] = 8'b10101010;
        vect1[3] = 8'b01010101;
        
        vect2[0] = 8'b00001111;
        vect2[1] = 8'b11110000;
        vect2[2] = 8'b01010101;
        vect2[3] = 8'b10101010;
        
        // Wait for execution
        #10;
        
        // Check results
        assert(vectOut[0] == 8'b00100100) else $error("Operation 3: Incorrect result for vectOut[0]");
        assert(vectOut[1] == 8'b11011100) else $error("Operation 3: Incorrect result for vectOut[1]");
        assert(vectOut[2] == 8'b01010101) else $error("Operation 3: Incorrect result for vectOut[2]");
        assert(vectOut[3] == 8'b10101011) else $error("Operation 3: Incorrect result for vectOut[3]");

        assert(pcWrEnOut == 1) else $error("Test 10: Incorrect pcWrEnOut");

        #20;

        // Finish simulation
        $display("All test cases finished");
        $finish;
    end


endmodule