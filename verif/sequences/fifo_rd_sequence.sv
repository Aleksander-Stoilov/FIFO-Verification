class fifo_rd_sequence extends uvm_sequence #(fifo_rd_transaction_item#());
    `uvm_object_utils(fifo_rd_sequence)

    int rd_en_distribution;
    int number_of_transactions;
    int count = 0;
    fifo_rd_transaction_item#() tr;


    function new(string name = "rd_sequence");
        super.new(name);
    endfunction

    virtual task body();
       while(count < number_of_transactions) begin
            tr = fifo_rd_transaction_item#()::type_id::create("tr");
            tr.rd_en_distribution = rd_en_distribution;

            start_item(tr);

            assert(tr.randomize())
                else `uvm_fatal("FAILED RANDOMIZATION", "Failed to randomize read transaction");

            finish_item(tr);
            if(tr.re) begin
                count++;
            end
       end
    endtask

endclass 