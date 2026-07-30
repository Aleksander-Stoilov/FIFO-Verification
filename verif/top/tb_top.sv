module tb_top;

	parameter DATA_WIDTH = 8;
	parameter ADDR_WIDTH = 4;
	parameter TR_NUM = ADDR_WIDTH;

	import uvm_pkg::*;
	import fifo_tests_pkg::*;


	logic clk, rst_n;

	fifo_wr_if #(.DATA_WIDTH(DATA_WIDTH)) wr_if (.clk(clk), .rst_n(rst_n));
	fifo_rd_if #(.DATA_WIDTH(DATA_WIDTH)) rd_if (.clk(clk), .rst_n(rst_n));

	initial begin
		uvm_config_db#(int)::set(null, "", "TR_NUM", TR_NUM);
		uvm_config_db#(virtual fifo_wr_if#())::set(null, "uvm_test_top", "wr_if", wr_if);
		uvm_config_db#(virtual fifo_rd_if#())::set(null, "uvm_test_top", "rd_if", rd_if);
		run_test("fifo_write_test");
	end

	fifo #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.DATA_WIDTH(DATA_WIDTH)
	) DUT(
		.clk(clk),
		.we(wr_if.we),
		.rst(~rst_n),
		.re(rd_if.re),
		.wrdata(wr_if.wrdata),
		.full(wr_if.full),
		.empty(rd_if.empty),
		.rddata(rd_if.rdata)
	);

	initial begin
		clk = 0;
		rst_n <= 1;
		repeat(1)@(posedge clk);
		rst_n <= 0;
		repeat(1)@(posedge clk);
		rst_n <= 1;
	end

	always begin
		#800ps clk = ~clk;
	end

 	initial begin
		#200000 $fatal();
	end

endmodule
