module aes_operations_unit #(
    parameter regSize = 32,         
    parameter vecSize = 4           
) (
    input logic [vecSize-1:0][regSize-1:0] operand1, 
    input logic [vecSize-1:0][regSize-1:0] operand2, 
    input logic [2:0] operation_select,
    output logic [vecSize-1:0][regSize-1:0] result
);


    // Internal signals for outputs from sub_bytes, shift_rows, mix_columns, add_round_key, and key_expansion operations
    logic [vecSize-1:0][regSize-1:0] outputSubBytes;
    logic [vecSize-1:0][regSize-1:0] outputShiftRows;
    logic [vecSize-1:0][regSize-1:0] outputMixColumns;
    logic [vecSize-1:0][regSize-1:0] outputAddRoundKey;
    logic [vecSize-1:0][regSize-1:0] expandedKey;

    // Instantiate the sub_bytes module
    sub_bytes #(
        .regSize(regSize),
        .vecSize(vecSize)
    ) sub_bytes_inst (
        .state(operand1),    
        .new_state(outputSubBytes) 
    );
	 
    

	
    // Instantiate the shift_rows module
    shift_rows #(
        .regSize(regSize),
        .vecSize(vecSize)
    ) shift_rows_inst (
        .vect_in(operand1), // Use operand1 as input
        .vect_out(outputShiftRows) // Output new state from shift_rows
    );

    // Instantiate the mix_columns module
    mix_columns #(
        .regSize(regSize),
        .vecSize(vecSize)
    ) mix_columns_inst (
        .vect(operand1), // Use operand1 as input
        .new_vect(outputMixColumns) // Output transformed columns from mix_columns
    );

    // Instantiate the add_round_key module
    add_round_key #(
        .vecSize(vecSize)
    ) add_round_key_inst (
        .state(operand1),        // Use operand1 as state input
        .round_key(operand2),    // Use operand2 as round key input
        .new_state(outputAddRoundKey) // Output new state from add_round_key
    );

    // TODO Hay que ver como hacemos funcionar este modulo
    key_expansion #(
        .regSize(regSize),
        .vecSize(vecSize)
    ) key_expansion_inst (
        .current_key(operand1), 
        .round(operand2),        
        .next_key(expandedKey)  
    );

    // Continuous assignment for result based on operation_select
    // TODO Faltan las inversas para el decrypt
                    
		assign result = (operation_select == 3'b001) ? expandedKey :
						    (operation_select == 3'b010) ? outputSubBytes :
                      (operation_select == 3'b011) ? outputShiftRows :
                      (operation_select == 3'b100) ? outputMixColumns :
                      (operation_select == 3'b101) ? outputAddRoundKey :
                      // 110
                      // 111
                      '0; // Default case

endmodule