module data_memory #(
    parameter dataSize = 32,
    parameter addressingSize = 32,
    parameter memorySize = 10020,
    parameter vecSize = 1
) (
    input logic clk, writeEnable,
    input logic [addressingSize-1:0] DataAdr,
    input logic [vecSize-1:0] [dataSize-1:0] toWrite_data,
    output logic [vecSize-1:0] [dataSize-1:0] read_data
);
    parameter bytesIn_addr = dataSize / 8;
    parameter bits_to_address_bytesIn_addr = $clog2(bytesIn_addr);

    logic [7:0] RAM [memorySize-1:0];
  initial begin
   // $readmemb("RAM.txt", RAM);
  end
    
    always_ff @(posedge clk) begin
        if (writeEnable) begin 
            for (int i = 0; i < vecSize; i = i + 1) begin
                for (int j = 0; j < bytesIn_addr; j = j + 1)
                    RAM[DataAdr[addressingSize-1:bits_to_address_bytesIn_addr] +
                        i * bytesIn_addr + j] <=
                        toWrite_data[i][j*8 +: 8];
            end
        end else begin 
            for (int i = 0; i < vecSize; i = i + 1) begin
                for (int j = 0; j < bytesIn_addr; j = j + 1)
                    read_data[i][j*8 +: 8] <= 
                        RAM[DataAdr[addressingSize-1:
                                    bits_to_address_bytesIn_addr] + 
                                    i * bytesIn_addr + j];
            end
        end
    end
   
   always_ff @(negedge clk)begin
     if (writeEnable) begin 
      $writememb("RAM.txt",RAM);
     end
   end
endmodule