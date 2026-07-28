class fifo_wr_transaction_item extends uvm_sequence_item;

	`uvm_object_utils(fifo_wr_transaction_item)

	function new(string name="fifo_wr_transaction_item");
		super.new(name);
	endfunction
endclass
