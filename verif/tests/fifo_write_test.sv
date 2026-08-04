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
        if($value$plusargs("wr_tr_num=%d", seq.number_of_transactions));
        else begin
            seq.number_of_transactions = 50;
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
