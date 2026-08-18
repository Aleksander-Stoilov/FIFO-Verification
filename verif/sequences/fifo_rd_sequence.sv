class fifo_rd_sequence extends uvm_sequence #(fifo_rd_transaction_item#());
    `uvm_object_utils(fifo_rd_sequence)

    int rd_en_distribution;
    int number_of_transactions;
    int count;
    fifo_rd_transaction_item#() tr;

    function new(string name = "rd_sequence");
        super.new(name);
    endfunction

    virtual task body();
        count = 0;
        while(count < number_of_transactions) begin
            tr = fifo_rd_transaction_item#()::type_id::create("read_tr");
            tr.rd_en_distribution = rd_en_distribution;

            start_item(tr);

            assert(tr.randomize())
                else `uvm_fatal("FAILED RANDOMIZATION", "Failed to randomize read transaction");

            finish_item(tr);

            `uvm_info(get_type_name(), $sformatf("Number of rd transactions passed: %d, number of total read transactions: %d", count, number_of_transactions), UVM_HIGH);
            if(tr.re) begin
                count++;
            end
       end
    endtask

endclass 