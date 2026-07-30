class fifo_write_test extends fifo_base_test;
    `uvm_component_utils(fifo_write_test)

    fifo_wr_sequence seq;
    int tr_num;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        seq = fifo_wr_sequence::type_id::create("wr_sequence");
        if(!uvm_config_db#(int)::get(this, "", "TR_NUM", tr_num)) begin
            `uvm_fatal("GET_ADDR_ERR", "Failed to get address width from config db");
        end
        else begin
            seq.number_of_transactions = (2 ** tr_num);
        end

        if($value$plusargs("wr_en_dist=%d", seq.wr_en_distribution));
        else begin
            seq.wr_en_distribution = 53;
        end

    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase); 
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        phase.raise_objection(this);
        seq.start(env.wr_agent.wr_sequencers);
        #100;
        phase.drop_objection(this);
    endtask

endclass
