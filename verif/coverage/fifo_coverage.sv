class fifo_coverage extends uvm_component;
	`uvm_component_utils(fifo_coverage);

	// Subtask 1 variables
	bit [1:0] we_full_controller = 2'b00;
	int we_0_full_0_cntr = 0;
	int we_0_full_1_cntr = 0;
	int we_1_full_0_cntr = 0;
	int we_1_full_1_cntr = 0;

	// Subtask 2 variables
	bit [1:0] re_empty_controller = 2'b00;
	int re_0_empty_0_cntr = 0;
	int re_0_empty_1_cntr = 0;
	int re_1_empty_0_cntr = 0;
	int re_1_empty_1_cntr = 0;

	// Subtask 3, 4, 5 variables
	int we_1_re_1_empty_0_full_0_cntr = 0;
	bit we_1_re_1_empty_1_full_0_flag = 0;
	bit we_1_re_1_empty_0_full_1_flag = 0;
	
	// Subtask 6 flags
	bit went_full = 0;	
	bit went_empty_after_full = 0;

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
		we_0_full_0: coverpoint we_0_full_0_cntr {
			bins b4 = {4};
			bins b8 = {8};
			bins b16 = {16};
			bins b32 = {32};
		}
		we_0_full_1: coverpoint we_0_full_1_cntr{
			bins b4 = {4};
			bins b8 = {8};
			bins b16 = {16};
			bins b32 = {32};
		}
		we_1_full_0: coverpoint we_1_full_0_cntr{
			bins b4 = {4};
			bins b8 = {8};
			bins b16 = {16};
			bins b32 = {32};
		}
		we_1_full_1: coverpoint we_1_full_1_cntr{
			bins b4 = {4};
			bins b8 = {8};
			bins b16 = {16};
			bins b32 = {32};
		}
	// Subtask 2, same as Subtask 1, but for read eanble && empty
		re_0_empty_0: coverpoint re_0_empty_0_cntr {
			bins b4 = {4};
			bins b8 = {8};
			bins b16 = {16};
			bins b32 = {32};
		}
		re_0_empty_1: coverpoint re_0_empty_1_cntr {
			bins b4 = {4};
			bins b8 = {8};
			bins b16 = {16};
			bins b32 = {32};
		}
		re_1_empty_0: coverpoint re_1_empty_0_cntr {
			bins b4 = {4};
			bins b8 = {8};
			bins b16 = {16};
			bins b32 = {32};
		}
		re_1_empty_1: coverpoint re_1_empty_1_cntr {
			bins b4 = {4};
			bins b8 = {8};
			bins b16 = {16};
			bins b32 = {32};
		}
	// Subtask 3, Cover the we = 1, re = 1, full & empty = 0;
		we1_re1_full0_empty0: coverpoint we_1_re_1_empty_0_full_0_cntr {
			bins b4 = {4};
			bins b8 = {8};
			bins b16 = {16};
			bins b32 = {32};
		}
	// Subtask 4, Cover the we = 1, re = 1, full == 0, empty = 1;
		flag_we1_re1_empty1: coverpoint we_1_re_1_empty_1_full_0_flag;
	// Subtask 5, Cover the we = 1, re = 1, full == 1, empty = 0;
		flag_we1_re1_full1: coverpoint we_1_re_1_empty_0_full_1_flag;
	// Subtask 6, cover going from full -> empty
		flag_from_full_to_empty: coverpoint went_empty_after_full;

	// Subtask 7, we transition bins:
		we_transitions_0_to_1: coverpoint write_if.we {
			bins b1 = (0 => 0 => 0 => 1);
			bins b2 = (0 => 0 => 1 => 0);
			bins b3 = (0 => 1 => 0 => 0);
			bins b4 = (1 => 0 => 0 => 0);
		}

		we_transitions_1_to_0: coverpoint write_if.we {
			bins b1 = (1 => 1 => 1 => 0);
			bins b2 = (1 => 1 => 0 => 1);
			bins b3 = (1 => 0 => 1 => 1);
			bins b4 = (0 => 1 => 1 => 1);
		}

	// Subtask 8, same as 7, but for re
		re_transitions_0_to_1: coverpoint read_if.re {
			bins b1 = (0 => 0 => 0 => 1);
			bins b2 = (0 => 0 => 1 => 0);
			bins b3 = (0 => 1 => 0 => 0);
			bins b4 = (1 => 0 => 0 => 0);
		}

		re_transitions_1_to_0: coverpoint read_if.re {
			bins b1 = (1 => 1 => 1 => 0);
			bins b2 = (1 => 1 => 0 => 1);
			bins b3 = (1 => 0 => 1 => 1);
			bins b4 = (0 => 1 => 1 => 1);
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

			// Logic to drive the write && full counters
			we_full_controller = {write_if.we, write_if.full};
			case (we_full_controller)
				2'b00: 
					begin
						we_0_full_0_cntr++;	
						we_0_full_1_cntr = 0;
						we_1_full_0_cntr = 0;	
						we_1_full_1_cntr = 0;	
					end
				2'b01:
					begin
						we_0_full_0_cntr = 0;
						we_0_full_1_cntr++;	
						we_1_full_0_cntr = 0;	
						we_1_full_1_cntr = 0;	
					end
				2'b10:
					begin
						we_0_full_0_cntr = 0;
						we_0_full_1_cntr = 0;
						we_1_full_0_cntr++;	
						we_1_full_1_cntr = 0;		
					end
				2'b11:
					begin
						we_0_full_0_cntr = 0;
						we_0_full_1_cntr = 0;
						we_1_full_0_cntr = 0;	
						we_1_full_1_cntr++;		
					end
			endcase

			// Logic To drive the read && empty counters
			re_empty_controller = {read_if.re, read_if.empty};
			case (re_empty_controller)
				2'b00: begin
					re_0_empty_0_cntr++;	
					re_0_empty_1_cntr = 0;
					re_1_empty_0_cntr = 0;	
					re_1_empty_1_cntr = 0;	
				end
				2'b01:
					begin
						re_0_empty_0_cntr = 0;
						re_0_empty_1_cntr++;
						re_1_empty_0_cntr = 0;	
						re_1_empty_1_cntr = 0;	
					end
				2'b10:
					begin
						re_0_empty_0_cntr = 0;
						re_0_empty_1_cntr = 0;
						re_1_empty_0_cntr++;	
						re_1_empty_1_cntr = 0;	
					end
				2'b11:
					begin
						re_0_empty_0_cntr = 0;
						re_0_empty_1_cntr = 0;
						re_1_empty_0_cntr = 0;	
						re_1_empty_1_cntr++;
					end
			endcase

			// Logic to drive we1_re1_emp_0_full_0 counter
			if (write_if.we == 1 && write_if.full == 0 && read_if.re == 1 && read_if.empty == 0) begin
				we_1_re_1_empty_0_full_0_cntr++;
			end
			else begin
				we_1_re_1_empty_0_full_0_cntr = 0;
			end

			// Subtask 4 observer
			if (write_if.we == 1 && write_if.full == 1 && read_if.re == 1 && read_if.empty == 0) begin
				we_1_re_1_empty_0_full_1_flag = 1;
			end

			// Subtask 5 observer
			if (write_if.we == 1 && write_if.full == 0 && read_if.re == 1 && read_if.empty == 1) begin
				we_1_re_1_empty_1_full_0_flag = 1;
			end

			if(write_if.full) went_full = 1;

			if(went_full && read_if.empty) went_empty_after_full = 1;
		end
	endtask
endclass: fifo_coverage
