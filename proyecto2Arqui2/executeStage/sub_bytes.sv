module sub_bytes #(
    parameter regSize = 32,               // Size of each register (32 bits)
    parameter vecSize = 4                 // Size of the vector (number of registers)
) (
    input logic [vecSize-1:0][regSize-1:0] state,             // Input: vecSize x regSize bit state matrix
    output logic [vecSize-1:0][regSize-1:0] new_state         // Output: vecSize x regSize bit new state matrix
);
    // Define the S-Box as a local lookup table (LUT)
    logic [7:0] sbox_data [255:0] = {
        8'h63, 8'h7c, 8'h77, 8'h7b, 8'hf2, 8'h6b, 8'h6f, 8'hc5,
        8'h30, 8'h01, 8'h67, 8'h2b, 8'hfe, 8'hd7, 8'hab, 8'h76,
        8'hca, 8'h82, 8'hc9, 8'h7d, 8'hfa, 8'h59, 8'h47, 8'hf0,
        8'had, 8'hd4, 8'ha2, 8'haf, 8'h9c, 8'ha4, 8'h72, 8'hc0,
        8'hb7, 8'hfd, 8'h93, 8'h26, 8'h36, 8'h3f, 8'hf7, 8'hcc,
        8'h34, 8'ha5, 8'he5, 8'hf1, 8'h71, 8'hd8, 8'h31, 8'h15,
        8'h04, 8'hc7, 8'h23, 8'hc3, 8'h18, 8'h96, 8'h05, 8'h9a,
        8'h07, 8'h12, 8'h80, 8'he2, 8'heb, 8'h27, 8'hb2, 8'h75,
        8'h09, 8'h83, 8'h2c, 8'h1a, 8'h1b, 8'h6e, 8'h5a, 8'ha0,
        8'h52, 8'h3b, 8'hd6, 8'hb3, 8'h29, 8'he3, 8'h2f, 8'h84,
        8'h53, 8'hd1, 8'h00, 8'hed, 8'h20, 8'hfc, 8'hb1, 8'h5b,
        8'h6a, 8'hcb, 8'hbe, 8'h39, 8'h4a, 8'h4c, 8'h58, 8'hcf,
        8'hd0, 8'hef, 8'haa, 8'hfb, 8'h43, 8'h4d, 8'h33, 8'h85,
        8'h45, 8'hf9, 8'h02, 8'h7f, 8'h50, 8'h3c, 8'h9f, 8'ha8,
        8'h51, 8'ha3, 8'h40, 8'h8f, 8'h92, 8'h9d, 8'h38, 8'hf5,
        8'hbc, 8'hb6, 8'hda, 8'h21, 8'h10, 8'hff, 8'hf3, 8'hd2,
        8'hcd, 8'h0c, 8'h13, 8'he0, 8'hef, 8'hb0, 8'h3e, 8'h4f,
        8'hc6, 8'h28, 8'hd3, 8'h2a, 8'h83, 8'hbc, 8'h4e, 8'h9e,
        8'hc0, 8'h9c, 8'h1c, 8'h7b, 8'h6f, 8'h31, 8'h93, 8'h75,
        8'h90, 8'h7d, 8'h5c, 8'h5d, 8'h61, 8'h79, 8'h16, 8'h71,
        8'h2b, 8'h26, 8'hc5, 8'h8d, 8'hc8, 8'h8a, 8'h3f, 8'h39,
        8'h8f, 8'h18, 8'h3c, 8'h6e, 8'h5c, 8'h5b, 8'h7f, 8'h81,
        8'hb8, 8'h5c, 8'h8e, 8'h80, 8'h6e, 8'h73, 8'h8e, 8'h5c
    };

    always_comb begin
        for (int i = 0; i < vecSize; i++) begin
            // For each 32-bit register, apply the S-Box to each byte
            new_state[i] = {sbox_data[state[i][31:24]], // Byte 0
                             sbox_data[state[i][23:16]], // Byte 1
                             sbox_data[state[i][15:8]],  // Byte 2
                             sbox_data[state[i][7:0]]};   // Byte 3
        end
    end
endmodule