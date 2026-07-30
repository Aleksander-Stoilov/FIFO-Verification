class fifo_wr_agent_config extends uvm_object;
    `uvm_object_utils(fifo_wr_agent_config)

    virtual fifo_wr_if#() my_vif;

    function new(string name = "write_agent_config");
        super.new(name);
    endfunction //new()
endclass //fifo_wr_agent_config extends uvm_object