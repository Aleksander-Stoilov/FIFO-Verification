package fifo_env_package;

	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import fifo_wr_agent_pkg::*;
	import fifo_rd_agent_pkg::*;
    import fifo_wr_agent_config_pkg::*;
    import fifo_rd_agent_config_pkg::*;
	import fifo_env_config_pkg::*;
	`include "fifo_env.sv"
	
endpackage : fifo_env_package
