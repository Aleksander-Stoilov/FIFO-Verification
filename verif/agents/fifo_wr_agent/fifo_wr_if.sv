interface fifo_wr_if #(parameter DATA_WIDTH = 4) ( 
	input logic clk,
	input logic rst
);

	logic we;
	logic [DATA_WIDTH-1:0] wrdata;
	logic full;

endinterface : fifo_wr_if
