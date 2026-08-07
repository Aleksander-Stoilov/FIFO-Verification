class fifo_rd_agent_config extends uvm_object;
    `uvm_object_utils(fifo_rd_agent_config)

    virtual fifo_rd_if#(DATA_WIDTH_P) rd_vif;

    function new(string name = "rd_agent_config");
        super.new(name);
    endfunction 

endclass //fifo_rd_agent_config extends uvm_object
