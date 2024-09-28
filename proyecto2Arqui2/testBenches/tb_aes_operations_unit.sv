module tb_aes_operations_unit;
  parameter regSize = 32;
  parameter vecSize = 4;

  // Declare input and output signals for the aes_operations_unit module
  logic [vecSize-1:0][regSize-1:0] operand1;
  logic [vecSize-1:0][regSize-1:0] operand2;
  logic [2:0] operation_select;
  logic [vecSize-1:0][regSize-1:0] result;

  // Instantiate the aes_operations_unit
  aes_operations_unit #(regSize, vecSize) uut (
      .operand1(operand1),
      .operand2(operand2),
      .operation_select(operation_select),
      .result(result)
  );

  // Initial block to apply test vectors
  initial begin
  
	 // Test case: KeyExpansion operation (operation_select = 3'b010)
    operation_select = 3'b001;  // Set operation to KeyExpansion
    // Input state for KeyExpansion operation
    operand1[0] = 32'h00000000;    // First word of the key
    operand1[1] = 32'h00000000;    // Second word of the key
    operand1[2] = 32'h00000000;    // Third word of the key
    operand1[3] = 32'h00000000;    // Fourth word of the key

        // Set the round value in the 2D array (use specific round for each word if necessary)
        // Example: Set the round value to 1 in all words (you can customize this if needed)
    operand2[0] = 32'h00000000;  // First word has the round value 1
    operand2[1] = 32'h00000000;  // Second word has the round value 1
    operand2[2] = 32'h00000000;  // Third word has the round value 1
    operand2[3] = 32'h00000000;  // Fourth word has the round value 1
    
    #10;  // Wait for the result to settle

    // Display results
    $display("Test Case: KeyExpansion operation");
    $display("Result = %h", result);

    // Assertions for expected KeyExpansion output
    assert(result[0] == 32'h63637c7c) else $error("KeyExpansion Test Case 1 Failed: Expected 63637c7c but got %h", result[0]);
    assert(result[1] == 32'h7b7bc5c5) else $error("KeyExpansion Test Case 2 Failed: Expected 7b7bc5c5 but got %h", result[1]);
    assert(result[2] == 32'h7676c0c0) else $error("KeyExpansion Test Case 3 Failed: Expected 7676c0c0 but got %h", result[2]);
    assert(result[3] == 32'h7575d2d2) else $error("KeyExpansion Test Case 4 Failed: Expected 7575d2d2 but got %h", result[3]);

  
    // Test case: SubBytes operation (operation_select = 3'b010)
    operation_select = 3'b010;  // Set operation to SubBytes
    // Input state for SubBytes operation
    operand1[0] = 32'h00000101;
    operand1[1] = 32'h03030707;
    operand1[2] = 32'h0f0f1f1f;
    operand1[3] = 32'h3f3f7f7f;
    #10;  // Wait for the result to settle

    // Display results
    $display("Test Case: SubBytes operation");
    $display("Result = %h", result);

    // Assertions for expected SubBytes output
    assert(result[0] == 32'h63637c7c) else $error("SubBytes Test Case 1 Failed: Expected 63637c7c but got %h", result[0]);
    assert(result[1] == 32'h7b7bc5c5) else $error("SubBytes Test Case 2 Failed: Expected 7b7bc5c5 but got %h", result[1]);
    assert(result[2] == 32'h7676c0c0) else $error("SubBytes Test Case 3 Failed: Expected 7676c0c0 but got %h", result[2]);
    assert(result[3] == 32'h7575d2d2) else $error("SubBytes Test Case 4 Failed: Expected 7575d2d2 but got %h", result[3]);

    // Test case: ShiftRows operation (operation_select = 3'b011)
    operation_select = 3'b011;  // Set operation to ShiftRows
    // Input state for ShiftRows operation (using the result from SubBytes)
    operand1[0] = result[0];
    operand1[1] = result[1];
    operand1[2] = result[2];
    operand1[3] = result[3];
    operand2 = '0;  // No round key used in this test
    #10;  // Wait for the result to settle

    // Display results
    $display("Test Case: ShiftRows operation");
    $display("Result = %h", result);

    // Assertions for expected ShiftRows output
    assert(result[0] == 32'h637bc0d2) else $error("ShiftRows Test Case 1 Failed: Expected 637bc0d2 but got %h", result[0]);
    assert(result[1] == 32'h7b76d27c) else $error("ShiftRows Test Case 2 Failed: Expected 7b76d27c but got %h", result[1]);
    assert(result[2] == 32'h76757cc5) else $error("ShiftRows Test Case 3 Failed: Expected 76757cc5 but got %h", result[2]);
    assert(result[3] == 32'h7563c5c0) else $error("ShiftRows Test Case 4 Failed: Expected 7563c5c0 but got %h", result[3]);

    // Test case: MixColumns operation (operation_select = 3'b100)
    operation_select = 3'b100;  // Set operation to MixColumns
    // Input state for MixColumns operation (using the result from ShiftRows)
    operand1[0] = result[0];
    operand1[1] = result[1];
    operand1[2] = result[2];
    operand1[3] = result[3];
    operand2 = '0;  // No round key used in this test
    #10;  // Wait for the result to settle

    // Display results
    $display("Test Case: MixColumns operation");
    $display("Result = %h", result);

    // Assertions for expected MixColumns output (replace these with correct expected values)
    assert(result[0] == 32'h591CEEA1) else $error("ShiftRows Test Case 1 Failed: Expected 591CEEA1 but got %h", result[0]);
    assert(result[1] == 32'hC28636D1) else $error("ShiftRows Test Case 2 Failed: Expected C28636D1 but got %h", result[1]);
    assert(result[2] == 32'hCADDAF02) else $error("ShiftRows Test Case 3 Failed: Expected CADDAF02 but got %h", result[2]);
    assert(result[3] == 32'h4A27DCA2) else $error("ShiftRows Test Case 4 Failed: Expected 4A27DCA2 but got %h", result[3]);
	 
	 // Test case: AddRoundKey operation (operation_select = 3'b101)
    operation_select = 3'b101;  // Set operation to AddRoundKey
	 
    // Input state for AddRoundKey operation (using the result from MixColumns)
    operand1[0] = result[0];
    operand1[1] = result[1];
    operand1[2] = result[2];
    operand1[3] = result[3];
    operand2[0] = 32'h62636363;  // Example round key
    operand2[1] = 32'h62636363;
    operand2[2] = 32'h62636363;
    operand2[3] = 32'h62636363;
    #10;  // Wait for the result to settle

    // Display results
    $display("Test Case: AddRoundKey operation");
    $display("Result = %h", result);

    // Assertions for expected AddRoundKey output (replace with expected values)
    assert(result[0] == (operand1[0] ^ operand2[0])) else $error("AddRoundKey Test Case 1 Failed: Expected %h but got %h", (operand1[0] ^ operand2[0]), result[0]);
    assert(result[1] == (operand1[1] ^ operand2[1])) else $error("AddRoundKey Test Case 2 Failed: Expected %h but got %h", (operand1[1] ^ operand2[1]), result[1]);
    assert(result[2] == (operand1[2] ^ operand2[2])) else $error("AddRoundKey Test Case 3 Failed: Expected %h but got %h", (operand1[2] ^ operand2[2]), result[2]);
    assert(result[3] == (operand1[3] ^ operand2[3])) else $error("AddRoundKey Test Case 4 Failed: Expected %h but got %h", (operand1[3] ^ operand2[3]), result[3]);

    $finish;  // End the simulation
  end
endmodule