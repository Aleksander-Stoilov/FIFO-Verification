class fifo_write_read_test extends fifo_base_test;
    `uvm_component_utils(fifo_write_read_test)

    fifo_rd_sequence rd_seq;
    fifo_wr_sequence wr_seq;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Create write sequence
        wr_seq = fifo_wr_sequence::type_id::create("wr_sequence");
        if(!$value$plusargs("wr_tr_num=%d", wr_seq.number_of_transactions))
            wr_seq.number_of_transactions = 16;

        if(!$value$plusargs("wr_en_dist=%d", wr_seq.wr_en_distribution))
            wr_seq.wr_en_distribution = 53;

        // Create read sequenece
        rd_seq = fifo_rd_sequence::type_id::create("rd_sequence");
        if(!$value$plusargs("rd_tr_num=%d", rd_seq.number_of_transactions))
            rd_seq.number_of_transactions = 16;
        if(!$value$plusargs("rd_en_dist=%d", rd_seq.rd_en_distribution)) 
            rd_seq.rd_en_distribution = 80;

    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        phase.raise_objection(this);
        fork 
            wr_seq.start(env.wr_agent.wr_sequencers);
            rd_seq.start(env.rd_agent.rd_sequencers);
        join
        phase.drop_objection(this);

    endtask

endclass