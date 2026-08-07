
class fifo_rd_sequencers extends uvm_sequencer#(fifo_rd_transaction_item#());
	`uvm_component_utils(fifo_rd_sequencers)
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_name(), $sformatf ("Sequencer build phase ran!"), UVM_MEDIUM);
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info(get_name(), $sformatf ("Sequencer connect phase ran!"), UVM_MEDIUM);
	endfunction

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info(get_name(), $sformatf ("Sequencer run phase ran!"), UVM_MEDIUM);
	endtask
endclass
