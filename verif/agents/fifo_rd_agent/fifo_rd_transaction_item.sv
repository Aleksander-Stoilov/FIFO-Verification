class fifo_rd_transaction_item#(parameter DATA_WIDTH_P = 4) extends uvm_sequence_item;

	rand bit re;
	rand bit [DATA_WIDTH_P-1:0] rdata;
	bit empty;
	int rd_en_distribution;

	constraint re_constraint {
		re dist {
			0:= 100 - rd_en_distribution,
			1:= rd_en_distribution
		};
	}

	`uvm_object_utils_begin(fifo_rd_transaction_item#(DATA_WIDTH_P))
		`uvm_field_int(re, UVM_ALL_ON)
		`uvm_field_int(rdata, UVM_ALL_ON)
		`uvm_field_int(empty, UVM_ALL_ON)
		`uvm_field_int(rd_en_distribution, UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name="fifo_rd_transaction_item");
		super.new(name);
	endfunction

	function void post_randomize();
		if(!(rd_en_distribution >= 0 && rd_en_distribution <= 100)) begin
			`uvm_fatal("RD_EN_DISTRIBUTION", "variable outside of scope");
		end
	endfunction
	
endclass
