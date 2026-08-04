package fifo_tests_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
    import fifo_wr_agent_config_pkg::*;
    import fifo_rd_agent_config_pkg::*;
	import fifo_env_config_pkg::*;
	import fifo_env_package::*;
	import fifo_sequence_pkg::*;
	`include "fifo_base_test.sv"
	`include "fifo_write_test.sv"
	`include "fifo_write_read_test.sv"
endpackage
