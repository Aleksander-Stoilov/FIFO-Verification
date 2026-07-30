class fifo_wr_agent extends uvm_agent;
	`uvm_component_utils(fifo_wr_agent)

	fifo_wr_monitor wr_monitor;
	fifo_wr_driver wr_driver;
	fifo_wr_sequencers wr_sequencers;

	virtual fifo_wr_if#() wr_vif;
	fifo_wr_agent_config wr_cfg;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_name(), $sformatf ("Write Agent build phase ran!"), UVM_MEDIUM);

		wr_monitor = fifo_wr_monitor::type_id::create("wr_monitor", this);
		wr_driver = fifo_wr_driver::type_id::create("wr_driver", this);
		wr_sequencers = fifo_wr_sequencers::type_id::create("wr_sequencers", this);

		if(!uvm_config_db#(fifo_wr_agent_config)::get(this, "", "wr_agent_cfg", wr_cfg)) begin
			`uvm_fatal("NOVIF", "no config was found for wr_cfg");
		end

		wr_vif = wr_cfg.my_vif;

		uvm_config_db#(virtual fifo_wr_if#())::set(this, "wr_monitor", "wr_vif", wr_vif);

		uvm_config_db#(virtual fifo_wr_if#())::set(this, "wr_driver", "wr_vif", wr_vif);
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info(get_name(), $sformatf ("Write Agent connection phase ran!"), UVM_MEDIUM);

		wr_driver.seq_item_port.connect(wr_sequencers.seq_item_export);
	endfunction

	virtual task run_phase(uvm_phase phase);
		`uvm_info(get_name(), $sformatf ("Write Agent run phase ran"), UVM_MEDIUM);
	endtask

endclass: fifo_wr_agent;
