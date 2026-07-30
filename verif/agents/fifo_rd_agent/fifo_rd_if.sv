interface fifo_rd_if #(parameter DATA_WIDTH = 8)(
	input logic clk,
	input logic rst_n
);

	logic re, empty;
	logic [DATA_WIDTH - 1 : 0] rdata;


endinterface : fifo_rd_if
