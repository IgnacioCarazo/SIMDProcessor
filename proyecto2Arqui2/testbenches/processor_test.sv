module processor_test();

    logic clk, rst;

	 processor dut(clk, rst);
	 

    always #5 clk = ~clk;
    initial begin
        clk = 0;
        rst = 1; # 10 ;
		  rst = 0;

        
    end

endmodule