module vector_extender #(parameter vecSize = 1, parameter dataSize = 8) (
    input [dataSize-1:0] inData,
    output [vecSize-1:0] [dataSize-1:0] outData
);
    generate
        genvar i;
        for (i = 0; i < vecSize; i = i + 1) begin : VECTOR_BLOCK
            assign outData[i] = inData;
        end
    endgenerate
endmodule