class fifo_rd_sequence extends uvm_sequence #(fifo_rd_transaction);
	`uvm_object_utils(fifo_rd_sequence)

	int rd_en_distribution;
	int tr_num;

	function new(string name = "rd_sequence");
		super.new(name);
	endfunction //new()

	fifo_rd_transaction_item#() tr;
	virtual task body();
		while(number_of_transactions > 0) begin
			tr = fifo_rd_transaction_item#()::type_id::create("tr");
			tr.rd_en_distribution = rd_en_distribution;

			start_item(tr);

			re_tr_randomize: assert (!tr.randomize())
				$error("Assertion re_tr_randomize failed!");
			
			finish_item(tr);

			if(!tr.rd_en) begin
				number_of_transactions--;
			end	
		end
	endtask

endclass //fifo_rd_sequence extends uvm_sequenc #(fifo_rd_transaction)
