module dual_port_register_memory#(
	parameter ADDR_WIDTH = 3,
	parameter DATA_WIDTH = 8
)
(
	input clk,
	input [DATA_WIDTH-1:0] wdata0, 
	input [ADDR_WIDTH-1:0] addr0,
	input we0, 
	input [DATA_WIDTH-1:0] wdata1, 
	input [ADDR_WIDTH-1:0] addr1, 
	input we1, 
	output reg [DATA_WIDTH-1:0] rdata0, 
	output reg [DATA_WIDTH-1:0] rdata1  
);

	parameter MEMORY_DEPTH = 2**ADDR_WIDTH;

	reg [DATA_WIDTH-1:0] memory [MEMORY_DEPTH-1:0]; 

    generate
        genvar i;

        for (i = 0; i < MEMORY_DEPTH; i = i + 1) begin 
            always@(posedge clk) begin 
                if (we0 == 1) begin	
                    if (addr0 == i) begin
                        memory[i] <= wdata0;
                    end
                end
            end
        end
	endgenerate 

    // This is the reading block
    always@(posedge clk) begin
        // if (we0 == 0) begin
            rdata1 <= memory[addr1];
        // end
        // else begin
        //     rdata1 = 0;
        // end
    end

endmodule