module tb_top;

	// parameter DATA_WIDTH = 4;
	// parameter ADDR_WIDTH = 4;

	import tb_params_pkg::*;

	import uvm_pkg::*;
	import fifo_tests_pkg::*;


	logic clk, rst_n, expected_full, expected_empty, reset_has_passed;

	fifo_wr_if #(.DATA_WIDTH_P(DATA_WIDTH_P)) wr_if (.clk(clk), .rst_n(rst_n));
	fifo_rd_if #(.DATA_WIDTH_P(DATA_WIDTH_P)) rd_if (.clk(clk), .rst_n(rst_n));

	initial begin
		uvm_config_db#(virtual fifo_wr_if#(DATA_WIDTH_P))::set(null, "", "wr_if", wr_if);
		uvm_config_db#(virtual fifo_rd_if#(DATA_WIDTH_P))::set(null, "", "rd_if", rd_if);
	end

	fifo #(
		.ADDR_WIDTH(ADDR_WIDTH_P),
		.DATA_WIDTH(DATA_WIDTH_P)
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

	checker #(.ADDR_WIDTH(ADDR_WIDTH_P)) my_checker(
		.clk(clk),
		.rst(~rst_n),
		.wr_en(wr_if.we),
		.rd_en(rd_if.re),
		.full(expected_full),
		.empty(expected_empty)	
	);

	initial begin
		clk = 0;
		rst_n <= 1;
		reset_has_passed <=0;
		repeat(1)@(posedge clk);
		rst_n <= 0;
		repeat(1)@(posedge clk);
		reset_has_passed <= 1;
		rst_n <= 1;
	end

	always begin
		#5ns clk = ~clk;
	end


	initial begin
		run_test("fifo_full_to_empty_test");
	end

	always @(posedge clk) begin
		if(reset_has_passed) begin
			if(expected_empty != rd_if.empty) begin
				`uvm_info("TB_TOP", $sformatf("CHECKER MISMATCH: expected_empty %b actual empty %b", expected_empty, rd_if.empty), UVM_LOW);
			end
			if(expected_full != wr_if.full) begin
				`uvm_info("TB_TOP", $sformatf("CHECKER MISMATCH: expected_full %b actual full %b", expected_full, wr_if.full), UVM_LOW);
			end
		end
	end


endmodule
