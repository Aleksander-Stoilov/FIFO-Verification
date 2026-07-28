`include "uvm_macros.svh"

module tb_top;

	import uvm_pkg::*;
	import fifo_tests_pkg::*;

	parameter DATA_WIDTH = 4;
	parameter ADDR_WIDTH = 2;

	logic clk, rst;

	fifo_wr_if #(.DATA_WIDTH(DATA_WIDTH)) wr_if (.clk(clk), .rst(rst));
	fifo_rd_if #(.DATA_WIDTH(DATA_WIDTH)) rd_if (.clk(clk), .rst(rst));

	initial begin
		uvm_config_db#(virtual fifo_wr_if)::set(null, "uvm_test_top", "wr_if", wr_if);
		uvm_config_db#(virtual fifo_rd_if)::set(null, "uvm_test_top", "rd_if", rd_if);
	end

	fifo #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.DATA_WIDTH(DATA_WIDTH)
	) DUT(
		.clk(clk),
		.we(wr_if.we),
		.rst(rst),
		.re(rd_if.re),
		.wrdata(wr_if.wrdata),
		.full(wr_if.full),
		.empty(rd_if.empty),
		.rddata(rd_if.rdata)
	);

	initial begin
		rst <= 0;
		repeat(2)@(posedge clk);
		rst <= 1;
		repeat(1)@(posedge clk);
		rst <= 0;
	end

	always begin
		#5 clk = ~clk;
	end

	initial begin
		run_test("fifo_base_test");
		// +UVM_TESTNAME <TESTNAME>
	end

	initial begin
		#150	$finish;
	end

endmodule
