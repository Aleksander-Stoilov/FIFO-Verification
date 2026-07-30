class fifo_wr_transaction_item#( parameter DATA_WIDTH = 4) extends uvm_sequence_item;

	rand bit wr_en;
	int wr_en_distribution;
	rand bit [DATA_WIDTH-1:0] wdata;
	bit full;

	`uvm_object_utils_begin(fifo_wr_transaction_item#(DATA_WIDTH))
		`uvm_field_int(wr_en, UVM_ALL_ON)
		`uvm_field_int(wdata, UVM_ALL_ON)
		`uvm_field_int(full, UVM_ALL_ON)
		`uvm_field_int(wr_en_distribution, UVM_ALL_ON)
	`uvm_object_utils_end

	constraint wr_en_constr {
		wr_en dist {0:= 100 - wr_en_distribution,
					1:= wr_en_distribution
		};
	}

	function void pre_randomize();
		if(!(wr_en_distribution >= 0 && wr_en_distribution <= 100)) begin
			`uvm_fatal("WR_EN_DISTRIBUTION", "variable not within scope (0 to 100)");
		end
	endfunction

	function new(string name="fifo_wr_transaction_item");
		super.new(name);
	endfunction
endclass
