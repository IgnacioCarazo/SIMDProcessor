module scalarRegFile #(
    parameter registerSize=32, 
    parameter registerQuantity=4,
    parameter selectionBits=2
) (
    input clk, reset,
    input regWrEn,
    input [selectionBits-1:0] rSel1, rSel2, regToWrite,
    input [registerSize-1:0] dataIn,
    output [registerSize-1:0] reg1Out, reg2Out
);
    logic [registerQuantity-1:0] reg_N_WrEn;
    logic [registerQuantity-1:0] [registerSize-1:0] reg_N_Out;

    logicDecoder #(.in(selectionBits), .out(registerQuantity)) regWrDecoder(
        .sel(regToWrite), .data_out(reg_N_WrEn)
    );

    generate
        genvar i;
        for (i = 0; i < registerQuantity; i = i + 1) begin: REGISTER_BLOCK
            register_en #(registerSize) r (
                .clk(clk), .reset(reset), .enable(reg_N_WrEn[i] & regWrEn),
                .data_in(dataIn), .data_out(reg_N_Out[i])
            );
        end
    endgenerate

    assign reg1Out = reg_N_Out[rSel1];
    assign reg2Out = reg_N_Out[rSel2];

endmodule