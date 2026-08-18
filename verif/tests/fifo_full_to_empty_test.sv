class fifo_full_to_empty_test extends fifo_base_test;
    `uvm_component_utils(fifo_full_to_empty_test)

    fifo_wr_sequence wr_seq;
    fifo_rd_sequence rd_seq;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        wr_seq = fifo_wr_sequence::type_id::create("wr_sequence");
        rd_seq = fifo_rd_sequence::type_id::create("rd_sequence");

    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        phase.raise_objection(this);
        for (int i=0; i<=1; ++i) begin    
            case (i)
                0: begin
                   wr_seq.wr_en_distribution = 100;
                   wr_seq.number_of_transactions = 100; 
                   rd_seq.number_of_transactions = 1;
                   rd_seq.rd_en_distribution = 1;
                end 

                1: begin
                    wr_seq.wr_en_distribution = 1;
                    wr_seq.number_of_transactions = 1;
                    rd_seq.number_of_transactions = 100;
                    rd_seq.rd_en_distribution = 100;
                end
            endcase
            fork 
                wr_seq.start(env.wr_agent.wr_sequencers);
                rd_seq.start(env.rd_agent.rd_sequencers);
            join
        end
        phase.drop_objection(this);

    endtask

endclass