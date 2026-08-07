package tb_params_pkg;
    `ifdef DATA_WIDTH
        parameter int DATA_WIDTH_P = `DATA_WIDTH;
    `else
        parameter int DATA_WIDTH_P = 8;
    `endif 
    
    `ifdef ADDR_WIDTH
        parameter int ADDR_WIDTH_P = `ADDR_WIDTH;
    `else
        parameter int ADDR_WIDTH_P = 3;
    `endif 
endpackage