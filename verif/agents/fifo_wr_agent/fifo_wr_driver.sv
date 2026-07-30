class fifo_wr_driver extends uvm_driver#(fifo_wr_transaction_item#());
	`uvm_component_utils(fifo_wr_driver)	
	
	virtual fifo_wr_if#() internal_vif;
	fifo_wr_transaction_item#() tr;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual fifo_wr_if#())::get(this, "", "wr_vif", internal_vif)) begin
			`uvm_fatal("No vif", "there was no interface found in the cfg_db for write driver");
		end

		`uvm_info(get_name(), $sformatf ("Driver build phase ran!"), UVM_MEDIUM);
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info(get_name(), $sformatf ("Driver connection phase ran!"), UVM_MEDIUM);
	endfunction

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info(get_name(), $sformatf ("Driver run phase ran"), UVM_MEDIUM);

		while(!internal_vif.rst_n)
			@(posedge internal_vif.clk);

		forever begin
		//`uvm_info("DRIVER", $sformatf ("RESET VALUE IS: %0b !!!!!!!!!!!!!!!!!!!!!", internal_vif.rst_n), UVM_MEDIUM); 
			seq_item_port.get_next_item(tr);
			@(posedge internal_vif.clk);
			while(!internal_vif.rst_n) begin
				internal_vif.we <= 0;
				internal_vif.wrdata <= 0;
				@(posedge internal_vif.clk);
			end

			if(!tr.wr_en) begin
				internal_vif.we <= 0;
			end
			else begin
				while(internal_vif.full)
					@(posedge internal_vif.clk);

				internal_vif.we <= 1;
				internal_vif.wrdata <= tr.wdata;
			end
			seq_item_port.item_done();
		end

	endtask
endclass