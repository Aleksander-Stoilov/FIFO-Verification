class fifo_write_read_test extends fifo_base_test;
    `uvm_component_utils(fifo_write_read_test)

    fifo_wr_sequence wr_seq;
    fifo_rd_sequence rd_seq;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Create write sequence
        wr_seq = fifo_wr_sequence::type_id::create("wr_sequence");
        if($value$plusargs("wr_tr_num=%d", wr_seq.number_of_transactions))begin
            `uvm_info("WRITE_READ_TEST", $sformatf("THE NUMBER OF WRITE TRANSACTIONS IS: %d", wr_seq.number_of_transactions), UVM_LOW)
        end
        else begin 
            wr_seq.number_of_transactions = 16;
            `uvm_info("WRITE_READ_TEST", $sformatf("THE NUMBER OF WRITE TRANSACTIONS IS: %d", wr_seq.number_of_transactions), UVM_LOW)
        end

        if($value$plusargs("wr_en_dist=%d", wr_seq.wr_en_distribution)) begin 
            `uvm_info("WRITE_READ_TEST", $sformatf("THE WR_EN DISTRIBUTION IS: %d %%", wr_seq.wr_en_distribution), UVM_LOW)
        end
        else begin 
            wr_seq.wr_en_distribution = 53;
            `uvm_info("WRITE_READ_TEST", $sformatf("THE WR_EN DISTRIBUTION IS: %d %%", wr_seq.wr_en_distribution), UVM_LOW)
        end

        // Create read sequenece
        rd_seq = fifo_rd_sequence::type_id::create("rd_sequence");
        if($value$plusargs("rd_tr_num=%d", rd_seq.number_of_transactions)) begin
            `uvm_info("WRITE_READ_TEST", $sformatf("THE NUMBER OF READ TRANSACTIONS IS: %d", rd_seq.number_of_transactions), UVM_LOW) 
        end
        else begin 
            rd_seq.number_of_transactions = 16;
            `uvm_info("WRITE_READ_TEST", $sformatf("THE NUMBER OF READ TRANSACTIONS IS: %d", rd_seq.number_of_transactions), UVM_LOW) 
        end
        if($value$plusargs("rd_en_dist=%d", rd_seq.rd_en_distribution)) begin            
            `uvm_info("WRITE_READ_TEST", $sformatf("THE RD_EN DISTRIBUTION IS: %d %%", rd_seq.rd_en_distribution), UVM_LOW)
        end
        else begin                
            rd_seq.rd_en_distribution = 80;
            `uvm_info("WRITE_READ_TEST", $sformatf("THE RD_EN DISTRIBUTION IS: %d %%", rd_seq.rd_en_distribution), UVM_LOW)
        end

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