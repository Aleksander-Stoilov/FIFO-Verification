class fifo_rd_monitor extends uvm_monitor;
	`uvm_component_utils(fifo_rd_monitor)
	uvm_analysis_port#(fifo_rd_transaction_item) ap;

	virtual fifo_rd_if#() internal_vif;

	function new (string name, uvm_component parent);
		super.new(name, parent);
		ap = new("rd_analysis_port", this);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual fifo_rd_if#())::get(this, "", "rd_vif", internal_vif)) begin
			`uvm_fatal("No vif", "there was no interface found in the cfg_db for read monitor");
		end

		`uvm_info(get_name(), $sformatf ("Monitor build phase ran!"), UVM_MEDIUM);
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info(get_name(), $sformatf ("Monitor connect phase ran!"), UVM_MEDIUM);
	endfunction

	virtual task run_phase(uvm_phase phase);
		fifo_rd_transaction_item tr;
		super.run_phase(phase);

		`uvm_info(get_name(), $sformatf ("Monitor run phase ran!"), UVM_MEDIUM);

		@(negedge internal_vif.rst_n) begin
			`uvm_info(get_type_name(), "Reset asserted, from rd_monitor", UVM_LOW)
		end

		@(posedge internal_vif.rst_n) begin
			`uvm_info(get_type_name(), "Reset de-asserted, from rd_monitor", UVM_LOW)
		end

		forever begin
			@(posedge internal_vif.clk) begin
				if(internal_vif.rst_n && internal_vif.re) begin
					@(posedge internal_vif.clk);
					tr = fifo_rd_transaction_item#()::type_id::create("ap transaction");
					tr.re = internal_vif.re;
					tr.rdata = internal_vif.rdata;
					tr.empty = internal_vif.empty;
					ap.write(tr);
					`uvm_info(get_name(), $sformatf("\nrd_transaction passed, \nrd_en=%0b, \nrdata=%b, \nempty=%b", tr.re, tr.rdata, tr.empty), UVM_HIGH);
				end	
			end
		end

	endtask

endclass