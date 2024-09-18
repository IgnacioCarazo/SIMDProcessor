module aes_rom (
    input logic [7:0] addr,  // Address input
    output logic [31:0] data_out  // Data output
);

    // Declare ROM (e.g., 266 entries for R-Con, S-Box, Inverse S-Box)
    logic [31:0] rom [0:265];  // Adjust size based on your memory layout

    // Load ROM from an external file at the start
    initial begin
        $readmemh("DATA_ROM.mem", rom);  // Load R-Con, S-Box, Inverse S-Box from file
    end

    // ROM is read-only, just output the data at the given address
    assign data_out = rom[addr];

endmodule
