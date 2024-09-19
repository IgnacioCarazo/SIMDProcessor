module pipe #(parameter WIDTH = 8)
			  ( input logic 	         clk, rst,
			    input logic  [WIDTH-1:0] in,
				output logic [WIDTH-1:0] out );

	always_ff @( posedge clk, posedge rst )
	begin
		if (rst) 	    out <= 0;
		else begin 
			out<= in;
		end		
	end
endmodule