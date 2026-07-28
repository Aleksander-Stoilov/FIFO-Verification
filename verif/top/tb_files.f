
        ../../rtl/fifo.v
        ../../rtl/dual_port_register_memory.v

        +incdir+../agents/fifo_rd_agent/
        ../agents/fifo_rd_agent/fifo_rd_if.sv
        ../agents/fifo_rd_agent/fifo_rd_agent_config_pkg.sv
        ../agents/fifo_rd_agent/fifo_rd_agent_pkg.sv

        +incdir+../agents/fifo_wr_agent/
        ../agents/fifo_wr_agent/fifo_wr_if.sv
        ../agents/fifo_wr_agent/fifo_wr_agent_config_pkg.sv 
        ../agents/fifo_wr_agent/fifo_wr_agent_pkg.sv

        +incdir+../env/
        ../env/fifo_env_config_pkg.sv
        ../env/fifo_env_pkg.sv

        +incdir+../tests/
        ../tests/fifo_tests_pkg.sv

        ../top/tb_top.sv
