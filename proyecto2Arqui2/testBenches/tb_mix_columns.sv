module tb_mix_columns;

    // Parameters for the mix_columns module
    parameter regSize = 32;
    parameter vecSize = 4;

    // Inputs and outputs for the mix_columns module
    logic [vecSize-1:0][regSize-1:0] vect;
    logic [vecSize-1:0][regSize-1:0] new_vect;

    // Instantiate the mix_columns module
    mix_columns #(
        .regSize(regSize),
        .vecSize(vecSize)
    ) uut (
        .vect(vect),
        .new_vect(new_vect)
    );

    // Test procedure
    initial begin
        // Test case 1        
        vect[0] = 32'h637BC0D2;   // First column of the state matrix         
        vect[1] = 32'h7B76D27C;   // Second column of the state matrix       
        vect[2] = 32'h76757CC5;   // Third column of the state matrix  
        vect[3] = 32'h7563c5c0;   // Fourth column of the state matrix
        
        // Wait for some time for results to be generated
        #10;

        // Display the results for debugging
        $display("Test case 1: Input state matrix columns:");
        $display("vect[0] = %h", vect[0]);
        $display("vect[1] = %h", vect[1]);
        $display("vect[2] = %h", vect[2]);
        $display("vect[3] = %h", vect[3]);
        
        $display("Test case 1: Output after MixColumns transformation:");
        $display("new_vect[0] = %h", new_vect[0]);
        $display("new_vect[1] = %h", new_vect[1]);
        $display("new_vect[2] = %h", new_vect[2]);
        $display("new_vect[3] = %h", new_vect[3]);
        
		  
		  
		  assert(new_vect[0] == 32'h591CEEA1) else $error("Test Case 1 Failed: Expected 591CEEA1 but got %h", new_vect[0]);
        assert(new_vect[1] == 32'hC28636D1) else $error("Test Case 1 Failed: Expected C28636D1 but got %h", new_vect[1]);
        assert(new_vect[2] == 32'hCADDAF02) else $error("Test Case 1 Failed: Expected CADDAF02 but got %h", new_vect[2]);
        assert(new_vect[3] == 32'h4A27DCA2) else $error("Test Case 1 Failed: Expected 4A27DCA2 but got %h", new_vect[3]);


        // End the simulation
        $finish;
    end

endmodule