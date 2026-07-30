class fifo_wr_sequence extends uvm_sequence #(fifo_wr_transaction_item);
    `uvm_object_utils(fifo_wr_sequence)

    int wr_en_distribution;
    int number_of_transactions;

    function new(string name = "fifo_wr_sequence");
        super.new(name);
    endfunction

    fifo_wr_transaction_item#() tr;
    virtual task body();
        while (number_of_transactions > 0) begin
 
            tr = fifo_wr_transaction_item#()::type_id::create("tr");
            tr.wr_en_distribution = wr_en_distribution;
            start_item(tr); 
            assert (tr.randomize())begin
                `uvm_info("SEQ", $sformatf("wr_en=%0d wdata=%08h", tr.wr_en, tr.wdata), UVM_MEDIUM);
            end
            else `uvm_fatal("RANDOMIZATION ERR", "transaction failed randomization");

            `uvm_info("SEQ", "Before finish_item", UVM_LOW);
            finish_item(tr);
            if(tr.wr_en) begin
                number_of_transactions--;
            end
            `uvm_info("SEQ", "After finish_item", UVM_LOW);
       end
    endtask //body


endclass : fifo_wr_sequence