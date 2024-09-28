module logic_decoder #(parameter in=4, parameter out=16) (
    input [in-1:0] sel,
    output [out-1:0] dataOut
);

    logic [out-1:0] decoded;

    genvar i;
    generate
        for (i = 0; i < out; i = i + 1) begin : DECODE_LOOP
            assign decoded[i] = (i == sel);
        end
    endgenerate

    assign dataOut = decoded;

endmodule