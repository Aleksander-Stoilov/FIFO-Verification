interface fifo_rd_if #(parameter DATA_WIDTH = 4)(
	input logic clk,
	input logic rst
);

	logic re, empty;
	logic [DATA_WIDTH - 1 : 0] rdata;


endinterface : fifo_rd_if
