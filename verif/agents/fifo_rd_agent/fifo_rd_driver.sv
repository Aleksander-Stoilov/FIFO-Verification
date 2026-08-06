class fifo_rd_driver extends uvm_driver#(fifo_rd_transaction_item#());
	`uvm_component_utils(fifo_rd_driver)	

	virtual fifo_rd_if#() internal_vif;
	fifo_rd_transaction_item#() tr;
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual fifo_rd_if#())::get(this, "", "rd_vif", internal_vif)) begin
			`uvm_fatal("No vif", "there was no interface found in the cfg_db for read driver");
		end
		`uvm_info(get_name(), $sformatf ("Driver build phase ran!"), UVM_MEDIUM);
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info(get_name(), $sformatf ("Driver connection phase ran!"), UVM_MEDIUM);
	endfunction

	task update_delay_signals();
			@(posedge internal_vif.clk);

			if(!internal_vif.rst_n) begin
				internal_vif.re_delayed <= 0;
				internal_vif.empty_delayed <= 1;
			end	
			else begin
				internal_vif.re_delayed <= internal_vif.re;
				internal_vif.empty_delayed <= internal_vif.empty;
			end
	endtask

	virtual task run_phase(uvm_phase phase);
		`uvm_info(get_name(), $sformatf ("Driver run phase ran"), UVM_MEDIUM);

		@(negedge internal_vif.rst_n) begin
			`uvm_info(get_type_name(), "Reset asserted, from rd_drive", UVM_LOW);
			internal_vif.re <= 0;
			internal_vif.re_delayed <= 0;
			internal_vif.empty <= 1;
			internal_vif.empty_delayed <= 1;
		end

		@(posedge internal_vif.rst_n) begin
			`uvm_info(get_type_name(), "Reset de-asserted, from rd_drive", UVM_LOW);
		end

		forever begin
			seq_item_port.try_next_item(tr);
			if(tr != null) begin	
				@(posedge internal_vif.clk);

				update_delay_signals();

				while(!internal_vif.rst_n) begin
					internal_vif.re <= 0;
					internal_vif.rdata <= 0;
					@(posedge internal_vif.clk);
				end

				if(!tr.re) begin
					internal_vif.re <= 0;
				end
				else begin
					while(internal_vif.empty)
						@(posedge internal_vif.clk);

					internal_vif.re <= 1;
					internal_vif.rdata <= tr.rdata;
				end

				
				seq_item_port.item_done();
			end
			else begin
				internal_vif.re <= 0;
			end
		end

	endtask
endclass
