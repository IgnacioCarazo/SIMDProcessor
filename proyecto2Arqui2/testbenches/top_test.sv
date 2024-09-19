module top_test();
	logic clk;
	logic rst;

	// instantiate device to be tested
	//Device under test
	top dut(clk, rst);
	// initialize test
	initial begin
		rst <= 1; #5; 
		rst <= 0;
	end
	// generate clock to sequence tests
	always begin
		clk <= 1; # 5; clk <= 0; # 5;
	end

endmodule