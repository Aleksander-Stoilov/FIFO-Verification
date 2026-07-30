class fifo_wr_monitor extends uvm_monitor;
	`uvm_component_utils(fifo_wr_monitor)

	virtual fifo_wr_if#() internal_vif;

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual fifo_wr_if#())::get(this, "", "wr_vif", internal_vif)) begin
			`uvm_fatal("No vif", "No interface found in the cfg_db for the write monitor");
		end
		`uvm_info(get_name(), $sformatf ("Monitor build phase ran!"), UVM_MEDIUM);
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info(get_name(), $sformatf ("Monitor connect phase ran!"), UVM_MEDIUM);
	endfunction

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		@(negedge internal_vif.rst_n) begin
			`uvm_info(get_type_name(), "Reset asserted, from wr_monitor", UVM_LOW)
		end

		@(posedge internal_vif.rst_n) begin
			`uvm_info(get_type_name(), "Reset de-asserted, from wr_monitor", UVM_LOW)
		end
		`uvm_info(get_name(), $sformatf ("Monitor run phase ran!"), UVM_MEDIUM);
	endtask

endclass
