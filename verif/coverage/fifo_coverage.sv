class fifo_coverage extends uvm_component;
	`uvm_component_utils(fifo_coverage);

	int we_0_full_0_cntr = 0;
	int we_0_full_1_cntr = 0;
	int we_1_full_0_cntr = 0;
	int we_1_full_1_cntr = 0;

	virtual fifo_wr_if#(DATA_WIDTH_P) write_if;
	virtual fifo_rd_if#(DATA_WIDTH_P) read_if;

	covergroup fifo_cg;
	// Standard nice-to-have coverpoints
		we_cp: coverpoint write_if.we;
		re_cp: coverpoint read_if.re;
		full_cp: coverpoint write_if.full;
		empty_cp: coverpoint read_if.empty;
		wrdata_cp: coverpoint write_if.wrdata;
		rddata_cp: coverpoint read_if.rdata;
		we_re_cp: cross we_cp, re_cp;

	//	Subtask 1. Cover all possible situations of write enable && full
		we0full0: coverpoint we_0_full_0_cntr {
			bins b4 = {4};
			bins b8 = {8};
			bins b16 = {16};
			bins b32 = {32};
		}
		we0full1: coverpoint we_0_full_1_cntr{
			bins b4 = {4};
			bins b8 = {8};
			bins b16 = {16};
			bins b32 = {32};
		}
		we1full0: coverpoint we_1_full_0_cntr{
			bins b4 = {4};
			bins b8 = {8};
			bins b16 = {16};
			bins b32 = {32};
		}
		we1full1: coverpoint we_1_full_1_cntr{
			bins b4 = {4};
			bins b8 = {8};
			bins b16 = {16};
			bins b32 = {32};
		}
	endgroup

	function new(string name="", uvm_component parent);
		super.new(name, parent);
		fifo_cg = new();
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		if(!uvm_config_db#(virtual fifo_wr_if#(DATA_WIDTH_P))::get(this, "", "wr_if", write_if)) begin
			`uvm_fatal("No vif", "there was no write interface found in the cfg_db for coverage file");
		end

		if(!uvm_config_db#(virtual fifo_rd_if#(DATA_WIDTH_P))::get(this, "", "rd_if", read_if)) begin
			`uvm_fatal("No vif", "there was no read interface found in the cfg_db for coverage file");
		end

	endfunction

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			@(posedge write_if.clk);
			if(write_if.rst_n) fifo_cg.sample();
			// Logic to drive the counters
			if(write_if.we == 0 && write_if.full == 0) begin
				we_0_full_0_cntr++;	
			end
			else begin	
				we_0_full_0_cntr = 0;	
			end

			if(write_if.we == 0 && write_if.full == 1) begin
				we_0_full_1_cntr++;	
			end
			else begin	
				we_0_full_1_cntr = 0;	
			end

			if(write_if.we == 1 && write_if.full == 0) begin
				we_1_full_0_cntr++;	
			end
			else begin	
				we_1_full_0_cntr = 0;	
			end
			if(write_if.we == 1 && write_if.full == 0) begin
				we_1_full_1_cntr++;	
			end
			else begin	
				we_1_full_1_cntr = 0;	
			end
		end
	endtask
endclass: fifo_coverage
