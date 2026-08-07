interface fifo_wr_if #(parameter DATA_WIDTH_P = 4) ( 
	input logic clk,
	input logic rst_n
);

	logic we;
	logic [DATA_WIDTH_P - 1:0] wrdata;
	logic full;

endinterface : fifo_wr_if
