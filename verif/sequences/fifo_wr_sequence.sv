class fifo_wr_sequence extends uvm_sequence #(fifo_wr_transaction_item#());
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
            assert (tr.randomize()) 
            	else `uvm_fatal("RANDOMIZATION ERR", "write transaction failed randomization");
                
            finish_item(tr);
            if(tr.wr_en) begin
                number_of_transactions--;
            end
       end
    endtask 


endclass : fifo_wr_sequence
