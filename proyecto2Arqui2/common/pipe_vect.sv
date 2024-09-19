module pipe_vect #(parameter WIDTH = 8,
				  parameter regSize = 16,
				  parameter vecSize = 4)
			  ( input logic 	         clk, rst,
			    input logic  [WIDTH-1:0] in,
				 input logic [vecSize-1:0] [regSize-1:0] vect1, vect2 , vect3,
				output logic [WIDTH-1:0] out,
				output logic [vecSize-1:0] [regSize-1:0] vect1Out, vect2Out, vect3Out);

	always_ff @( posedge clk, posedge rst )
	begin
		if (rst) 	 begin
			out <= 0;
			vect1Out <=0;
			vect2Out <=0;
		end
		else begin 
			out<= in;
			vect1Out <=vect1;
			vect2Out <=vect2;
			vect3Out <=vect3;
		end		
	end
endmodule