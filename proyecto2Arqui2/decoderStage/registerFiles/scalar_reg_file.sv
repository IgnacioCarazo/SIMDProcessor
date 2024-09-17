module scalar_reg_file #(
    parameter regSize=32, 
    parameter regQuantity=4,
    parameter selBits=2
) (
    input clk, reset,
    input regWrEn,
    input [selBits-1:0] rSel1, rSel2, regToWrite,
    input [regSize-1:0] dataIn,
    output [regSize-1:0] reg1Out, reg2Out
);
    logic [regQuantity-1:0] reg_N_WrEn;
    logic [regQuantity-1:0] [regSize-1:0] reg_NOut;

    logic_decoder #(.in(selBits), .out(regQuantity)) regWrDecoder(
        .sel(regToWrite), .dataOut(reg_N_WrEn)
    );

    generate
        genvar i;
        for (i = 0; i < regQuantity; i = i + 1) begin: REGISTER_BLOCK
            register_en #(regSize) r (
                .clk(clk), .reset(reset), .enable(reg_N_WrEn[i] & regWrEn),
                .dataIn(dataIn), .dataOut(reg_NOut[i])
            );
        end
    endgenerate

    assign reg1Out = reg_NOut[rSel1];
    assign reg2Out = reg_NOut[rSel2];

endmodule