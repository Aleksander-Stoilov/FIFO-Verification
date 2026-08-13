class fifo_env extends uvm_env;
	`uvm_component_utils(fifo_env)

	virtual fifo_wr_if#(DATA_WIDTH_P) wr_vif;
	virtual fifo_rd_if#(DATA_WIDTH_P) rd_vif;

	fifo_wr_agent wr_agent;
	fifo_rd_agent rd_agent;

	fifo_wr_agent_config wr_agt_conf;
	fifo_rd_agent_config rd_agt_conf;

	fifo_scoreboard scoreboard;

	fifo_coverage fifo_cg_instance;

	fifo_env_config env_cfg;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		wr_agent = fifo_wr_agent::type_id::create("wr_agent", this);
		rd_agent = fifo_rd_agent::type_id::create("rd_agent", this);
		scoreboard = fifo_scoreboard::type_id::create("scoreboard", this);
		fifo_cg_instance = fifo_coverage::type_id::create("coverage", this);

		if(!uvm_config_db#(fifo_env_config)::get(this, "", "env_cfg", env_cfg)) begin
			`uvm_fatal("NOVIF", "no environment config found");
		end

		uvm_config_db#(fifo_wr_agent_config)::set(this, "wr_agent", "wr_agent_cfg", env_cfg.wr_cfg);
		uvm_config_db#(fifo_rd_agent_config)::set(this, "rd_agent", "rd_agent_cfg", env_cfg.rd_cfg);

		// Get set virtual interfaces in c onfig db

		if(!uvm_config_db#(virtual fifo_wr_if#(DATA_WIDTH_P))::get(this, "", "wr_if", wr_vif))
			`uvm_fatal("No vif", "there was no write interface found in the cfg_db for the environment");
		if(!uvm_config_db#(virtual fifo_rd_if#(DATA_WIDTH_P))::get(this, "", "rd_if", rd_vif))
			`uvm_fatal("No vif", "there was no read interface found in the cfg_db for the environment");

		uvm_config_db#(virtual fifo_wr_if#(DATA_WIDTH_P))::set(this, "coverage", "wr_if", fifo_cg_instance.write_if);
		uvm_config_db#(virtual fifo_rd_if#(DATA_WIDTH_P))::set(this, "coverage", "rd_if", fifo_cg_instance.read_if);

		`uvm_info(get_name(), $sformatf ("Build phase ran!"), UVM_MEDIUM);
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info(get_name(), $sformatf ("Connect Phase Ran"), UVM_MEDIUM);

		wr_agent.wr_monitor.ap.connect(scoreboard.wr_ap_imp);
		rd_agent.rd_monitor.ap.connect(scoreboard.rd_ap_imp);
	endfunction

	virtual task run_phase(uvm_phase phase);
		`uvm_info(get_name(), $sformatf ("Run Phase Ran"), UVM_MEDIUM);
	endtask

endclass : fifo_env
