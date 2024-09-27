module tb_add_round_key;
    // Parameters for the add_round_key module
    parameter regSize = 32;
    parameter vecSize = 4;

    // Inputs and outputs for the add_round_key module
    logic [vecSize-1:0][regSize-1:0] state;        // Input: state matrix columns
    logic [vecSize-1:0][regSize-1:0] round_key;    // Input: round key matrix columns
    logic [vecSize-1:0][regSize-1:0] new_state;    // Output: transformed state matrix columns

    // Instantiate the add_round_key module
    add_round_key #(
        .vecSize(vecSize)
    ) uut (
        .state(state),
        .round_key(round_key),
        .new_state(new_state)
    );
	 


    // Test procedure
    initial begin
        // Test case 1
        state[0] = 32'h591ceea1;    // First column of the state matrix
        state[1] = 32'hc28636d1;    // Second column of the state matrix
        state[2] = 32'hcaddaf02;    // Third column of the state matrix
        state[3] = 32'h4a27dca2;    // Fourth column of the state matrix

        round_key[0] = 32'h62636363; // First column of the round key
        round_key[1] = 32'h62636363; // Second column of the round key
        round_key[2] = 32'h62636363; // Third column of the round key
        round_key[3] = 32'h62636363; // Fourth column of the round key
        
        // Wait for some time for results to be generated
        #10;

        // Assertions based on expected values
        assert(new_state[0] == (state[0] ^ round_key[0])) else $error("Test Case 1 Failed: Expected %h but got %h", (state[0] ^ round_key[0]), new_state[0]);
        assert(new_state[1] == (state[1] ^ round_key[1])) else $error("Test Case 1 Failed: Expected %h but got %h", (state[1] ^ round_key[1]), new_state[1]);
        assert(new_state[2] == (state[2] ^ round_key[2])) else $error("Test Case 1 Failed: Expected %h but got %h", (state[2] ^ round_key[2]), new_state[2]);
        assert(new_state[3] == (state[3] ^ round_key[3])) else $error("Test Case 1 Failed: Expected %h but got %h", (state[3] ^ round_key[3]), new_state[3]);

        // End the simulation
        $finish;
    end
endmodule