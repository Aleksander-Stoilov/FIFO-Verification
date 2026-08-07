package fifo_wr_agent_pkg;

	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import fifo_wr_agent_config_pkg::*;
	import tb_params_pkg::*;
	`include "fifo_wr_transaction_item.sv"
	`include "fifo_wr_sequencers.sv"
	`include "fifo_wr_monitor.sv"
	`include "fifo_wr_driver.sv"
	`include "fifo_wr_agent.sv"
	
endpackage
