/*import uvm_pkg::*;
import my_pkg::*;

`ifndef MY_TEST_SV
`define MY_TEST_SV

class my_test extends uvm_test;
  `uvm_component_utils(my_test)

  cmn_env env;

  function new(string name = "my_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = cmn_env::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("MY_TEST", "Starting AHB2APB Verification Test!", UVM_LOW)

    // === Trigger Single Write ===
    single_write_seq sw_seq = single_write_seq::type_id::create("sw_seq");
    sw_seq.start(env.ahb_agnt.hsequencer);

    // === Trigger Single Read ===
    single_read_seq sr_seq = single_read_seq::type_id::create("sr_seq");
    sr_seq.start(env.ahb_agnt.hsequencer);

    // === Trigger Burst Write ===
    burst_write_seq bw_seq = burst_write_seq::type_id::create("bw_seq");
    bw_seq.start(env.ahb_agnt.hsequencer);

    // === Trigger Burst Read ===
    burst_read_seq br_seq = burst_read_seq::type_id::create("br_seq");
    br_seq.start(env.ahb_agnt.hsequencer);

    // === Trigger APB Slave Access Fail / Idle Handling ===
    slave_access_fail_seq fail_seq = slave_access_fail_seq::type_id::create("fail_seq");
    fail_seq.start(env.ahb_agnt.hsequencer);

    `uvm_info("MY_TEST", "All Sequences Completed!", UVM_LOW)

    phase.drop_objection(this);
  endtask

endclass

`endif
*/
