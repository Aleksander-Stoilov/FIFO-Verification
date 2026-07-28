class fifo_base_test extends uvm_test;

	`uvm_component_utils(fifo_base_test)

	// Instancirame vsichki obekti koito sa nujni na testa
	// env -> env_cfg -> wr_cfg/rd_cfg -> v_write/read_if;
	fifo_env env;

	fifo_env_config env_cfg;
	fifo_wr_agent_config wr_cfg;
	fifo_rd_agent_config rd_cfg;

	virtual fifo_wr_if v_write_if;
	virtual fifo_rd_if v_read_if;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_name(), $sformatf ("Base test Build phase ran!"), UVM_MEDIUM);

		// Deklarirame env_cfg predi samiq env creationg
		env_cfg = fifo_env_config::type_id::create("env_cfg");
	
		// Proverqvai za greshki kogato izvikvash "uvm_config_db get";
		if(!uvm_config_db#(virtual fifo_wr_if)::get(this, "", "wr_if", v_write_if)) begin
			`uvm_fatal("NOVIF:", "no virtual write interface found");
		end

		if(!uvm_config_db#(virtual fifo_rd_if)::get(this, "", "rd_if", v_read_if)) begin
			`uvm_fatal("NOVIF:", "no virtual read interface found");
		end

		wr_cfg = fifo_wr_agent_config::type_id::create("wr_cfg");
		rd_cfg = fifo_rd_agent_config::type_id::create("rd_cfg");

		wr_cfg.my_vif = v_write_if;
		rd_cfg.rd_vif = v_read_if;

		env_cfg.wr_cfg = wr_cfg;
		env_cfg.rd_cfg = rd_cfg;

		env = fifo_env::type_id::create("env", this);
		
		uvm_config_db#(fifo_env_config)::set(this, "env", "env_cfg", env_cfg);

	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info(get_name(), $sformatf ("Base test Connect Phase Ran"), UVM_MEDIUM);
	endfunction

	virtual task run_phase(uvm_phase phase);
		`uvm_info(get_name(), $sformatf ("Base test Run Phase Ran"), UVM_MEDIUM);
	endtask
endclass : fifo_base_test
