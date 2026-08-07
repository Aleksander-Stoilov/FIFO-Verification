module  checker#(
    parameter ADDR_WIDTH = 4
    )(
    input logic clk,
    input logic rst,
    input logic wr_en,
    input logic rd_en,
    output logic full,
    output logic empty
);
    // Combinational logic to determine expected empty
    // and expected full

    logic [ADDR_WIDTH:0] write_counter;

    always_comb begin: expected_full_logic
        if (write_counter == 2 ** ADDR_WIDTH)
            full = 1;
        else 
            full = 0; 
    end

    always_comb begin: expected_empty_logic
        if (write_counter == 0)
            empty = 1;
        else
            empty = 0;
    end

    // Sequential logic to keep track of the write count.
    always_ff @(posedge clk) begin: Write_conter_controller
        if (rst) begin
            write_counter <= 0;
        end
        else if (wr_en && rd_en && !empty && !full) begin
            write_counter <= write_counter;
        end
        else if (wr_en && !full) begin
            write_counter <= write_counter + 1;
        end
        else if (rd_en && !empty) begin
            write_counter <= write_counter - 1;
        end
        else begin
            write_counter <= write_counter;
        end
        
    end
    
endmodule
