module tb_shift_rows;        
    // Parameters for the testbench
    parameter regSize = 32;   // Size of each register (32 bits)
    parameter vecSize = 4;    // Number of registers (rows)

    // Declare input and output signals for the shift_rows module
    logic [regSize-1:0] vect_in [vecSize-1:0];      // Input: vecSize x regSize bit matrix
    logic [regSize-1:0] vect_out [vecSize-1:0];     // Output: vecSize x regSize bit matrix

    // Instantiate the shift_rows module
    shift_rows #(regSize, vecSize) uut (
        .vect_in(vect_in),
        .vect_out(vect_out)
    );

    // Initial block to apply test vectors
    initial begin
        // Test case 1
        vect_in[0] = 32'h7b5b5465;  
        vect_in[1] = 32'h73745665;  
        vect_in[2] = 32'h63746f72;      
        vect_in[3] = 32'h5d53475d;  

        // Wait for a small delay for the output to stabilize
        #10;

        // Assertions for expected output values
        assert(vect_out[0] == 32'h7b746f5d)  else $error("Test Case 1 Failed: Expected 7b746f5d but got %h", vect_out[0]);
        assert(vect_out[1] == 32'h73744765) else $error("Test Case 2 Failed: Expected 73744765 but got %h", vect_out[1]);
        assert(vect_out[2] == 32'h63535465) else $error("Test Case 3 Failed: Expected 63535465 but got %h", vect_out[2]);
        assert(vect_out[3] == 32'h5d5b5672) else $error("Test Case 4 Failed: Expected 5d5b5672 but got %h", vect_out[3]);

        // Add more test cases as needed

        // Finish the simulation
        $finish;
    end
endmodule