module register #
(
    parameter N = 32 // default register size is 8
)
(
    input clk,
    input rst,
    input [N-1:0] dataIn,
    output [N-1:0] dataOut
);

    reg [N-1:0] my_register; // declare a N-bit register

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            my_register <= 0; // rst the register to 0
        end
        else begin
            my_register <= dataIn; // update the register with input data
        end
    end

    assign dataOut = my_register; // assign register value to output

endmodule