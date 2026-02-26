package pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  //constants
  `include "define.sv"


  // Common sequence item
  `include "cmn_seq_item.sv"

  // Sequencers
  `include "ahb_sequencer.sv"
  `include "apb_sequencer.sv"

//coverage
	`include "coverage.sv"


  // Drivers, Monitors
  `include "ahb_driver.sv"
  `include "apb_driver.sv"
  `include "ahb_monitor.sv"
  `include "apb_monitor.sv"

  // Agents
  `include "ahb_agent.sv"
  `include "apb_agent.sv"

  // Scoreboard
  `include "scoreboard.sv"

  // Sequences
  `include "ahb_sequence.sv"          // ✅ This is likely missing
  `include "single_write_seq.sv"
  `include "single_read_seq.sv"
  `include "burst_write_seq.sv"
  `include "burst_read_seq.sv"
  `include "slave_access_fail_seq.sv"

  // Environment
  `include "environment.sv"

  // Test
  `include "my_test.sv"
endpackage
