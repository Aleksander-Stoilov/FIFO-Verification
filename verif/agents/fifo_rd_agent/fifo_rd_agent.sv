class fifo_rd_agent extends uvm_agent;
	`uvm_component_utils(fifo_rd_agent)

	fifo_rd_monitor rd_monitor;
	fifo_rd_driver rd_driver;
	fifo_rd_sequencers rd_sequencers;

	fifo_rd_agent_config rd_cfg;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_name(), $sformatf ("Read Agent build phase ran!"), UVM_MEDIUM);

		rd_monitor = fifo_rd_monitor::type_id::create("rd_monitor", this);
		rd_driver = fifo_rd_driver::type_id::create("rd_driver", this);
		rd_sequencers = fifo_rd_sequencers::type_id::create("rd_sequencers", this);

		if(!uvm_config_db#(fifo_rd_agent_config)::get(this, "", "rd_agent_cfg", rd_cfg)) begin
			`uvm_fatal("NOCFG", "no config found for rd_agent");
		end

		uvm_config_db#(virtual fifo_rd_if#(DATA_WIDTH_P))::set(this, "rd_monitor", "rd_vif", rd_cfg.rd_vif);

		uvm_config_db#(virtual fifo_rd_if#(DATA_WIDTH_P))::set(this, "rd_driver", "rd_vif", rd_cfg.rd_vif);

	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info(get_name(), $sformatf ("Read Agent connection phase ran!"), UVM_MEDIUM);
		rd_driver.seq_item_port.connect(rd_sequencers.seq_item_export);
	endfunction

	virtual task run_phase(uvm_phase phase);
		`uvm_info(get_name(), $sformatf ("Read Agent run phase"), UVM_MEDIUM);
	endtask

endclass: fifo_rd_agent;
