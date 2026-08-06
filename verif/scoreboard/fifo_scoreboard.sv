class fifo_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(fifo_scoreboard);

    `uvm_analysis_imp_decl(_WR)
    `uvm_analysis_imp_decl(_RD)

    uvm_analysis_imp_WR#(fifo_wr_transaction_item, fifo_scoreboard) wr_ap_imp;
    uvm_analysis_imp_RD#(fifo_rd_transaction_item, fifo_scoreboard) rd_ap_imp;

    logic [7:0] tr_data[$];
    int wr_count;
    int rd_count;

    function new(string name, uvm_component parent);
       super.new(name, parent);
       wr_count = 0;
       rd_count = 0;
    endfunction

    virtual function void build_phase(uvm_phase phase);
       super.build_phase(phase);

       wr_ap_imp = new("wr_ap_imp", this);
       rd_ap_imp = new("rd_ap_imp", this);
    endfunction

    virtual function void report_phase(uvm_phase phase);
       super.report_phase(phase);

       `uvm_info(get_type_name(), $sformatf("Write Transaction Count: %d", wr_count), UVM_NONE);
       `uvm_info(get_type_name(), $sformatf("Read Transaction Count: %d", rd_count), UVM_NONE);
    endfunction

    virtual function void check_phase(uvm_phase phase);
       super.connect_phase(phase); 

        if(rd_count) begin
            `uvm_info(get_type_name(), "There was at least 1 valid read tr", UVM_NONE);
        end
    endfunction

    function void write_WR(fifo_wr_transaction_item tr);
        `uvm_info("SCB", $sformatf("Transaction write data: %h", tr.wdata), UVM_LOW);
        wr_count++;
        tr_data.push_front(tr.wdata);
    endfunction

    logic [7:0] data;
    function void write_RD(fifo_rd_transaction_item tr);
        `uvm_info("SCB", $sformatf("Transaction read data: %h", tr.rdata), UVM_LOW);
        rd_count++;
        data = tr_data.pop_back();
        if(tr.rdata != data) begin
            `uvm_error(get_type_name(), $sformatf("Mismatch. Expected: %h DUT %h", data, tr.rdata));
        end
    endfunction

endclass : fifo_scoreboard