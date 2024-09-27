module tb_shift_rows; 
    // Parameters for the testbench
    parameter regSize = 32;   // Size of each register (32 bits)
    parameter vecSize = 4;    // Number of registers (rows)

    // Declare input and output signals for the shift_rows module
    
    logic [vecSize-1:0][regSize-1:0] vect_in;    
    logic [vecSize-1:0][regSize-1:0] vect_out;  

    // Instantiate the shift_rows module
    shift_rows #(regSize, vecSize) uut (
        .vect_in(vect_in),
        .vect_out(vect_out)
    );
  

    // Initial block to apply test vectors
    initial begin
        // Test case 1
        vect_in[0] = 32'h63637c7c;          
        vect_in[1] = 32'h7b7bc5c5;  
        vect_in[2] = 32'h7676c0c0;              
        vect_in[3] = 32'h7575d2d2;  
        
        // Wait for a small delay for the output to stabilize
        #10; // Wait for one clock cycle to ensure input is sampled

        // Assertions for expected output values
        assert(vect_out[0] == 32'h637bc0d2)  else $error("Test Case 1 Failed: Expected 637bc0d2 but got %h", vect_out[0]);
        assert(vect_out[1] == 32'h7b76d27c) else $error("Test Case 2 Failed: Expected 7b76d27c but got %h", vect_out[1]);        
        assert(vect_out[2] == 32'h76757cc5) else $error("Test Case 3 Failed: Expected 76757cc5 but got %h", vect_out[2]);
        assert(vect_out[3] == 32'h7563c5c0) else $error("Test Case 4 Failed: Expected 7563c5c0 but got %h", vect_out[3]);
        
        // Add more test cases as needed

        // Finish the simulation
        $finish;
    end
endmodule