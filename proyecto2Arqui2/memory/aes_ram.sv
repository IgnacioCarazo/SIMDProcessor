module aes_ram (
    input logic clk,
    input logic we,  // Write enable
    input logic [7:0] addr,  // Address input
    input logic [31:0] data_in,  // Data input (4 bytes per line)
    output logic [31:0] data_out  // Data output
);

    // Declare RAM (44 entries, each 4 bytes)
    logic [31:0] ram [0:43];  // Example size: 44 entries for state matrix and round keys

    // Load RAM from an external file at the start
    initial begin
        $readmemh("DATA_RAM.mem", ram);  // Load the state matrix and round keys from file
    end

    // Read/Write Logic
    always_ff @(posedge clk) begin
        if (we) begin
            ram[addr] <= data_in;  // Write data into RAM
        end else begin
            data_out <= ram[addr];  // Read data from RAM
        end
    end

endmodule
