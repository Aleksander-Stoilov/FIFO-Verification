class fifo_wr_monitor extends uvm_monitor;
	`uvm_component_utils(fifo_wr_monitor)
	uvm_analysis_port#(fifo_wr_transaction_item) ap;

	virtual fifo_wr_if#() internal_vif;

	function new (string name, uvm_component parent);
		super.new(name, parent);
		ap = new("analysis_port", this);
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
		fifo_wr_transaction_item#() tr;
		super.run_phase(phase);
		`uvm_info(get_name(), $sformatf ("Monitor run phase ran!"), UVM_MEDIUM);

		@(negedge internal_vif.rst_n) begin
			`uvm_info(get_type_name(), "Reset asserted, from wr_monitor", UVM_LOW)
		end

		@(posedge internal_vif.rst_n) begin
			`uvm_info(get_type_name(), "Reset de-asserted, from wr_monitor", UVM_LOW)
		end

			forever begin
				@(posedge internal_vif.clk) begin
					if(internal_vif.rst_n && internal_vif.we) begin
						tr = fifo_wr_transaction_item#()::type_id::create("ap transaction");
						tr.wr_en = internal_vif.we;
						tr.wdata = internal_vif.wrdata;
						tr.full = internal_vif.full;
						ap.write(tr);
						`uvm_info(get_name(), $sformatf("\nwr_transaction passed, \nwr_en=%0b, \nwdata=%b, \nfull=%b", tr.wr_en, tr.wdata, tr.full), UVM_HIGH);
					end	
				end
			end
	endtask
endclass
