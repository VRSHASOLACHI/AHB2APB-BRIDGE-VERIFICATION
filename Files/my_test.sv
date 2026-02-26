import uvm_pkg::*;
import pkg::*;

`ifndef MY_TEST_SV
`define MY_TEST_SV

class my_test extends uvm_test;
  `uvm_component_utils(my_test)  // Registering with UVM factory

  cmn_env env;
  mycoverage cov;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = cmn_env::type_id::create("env", this);  // Instantiate environment
    cov = mycoverage::type_id::create("cov", this);  // Instantiate coverage object
  endfunction
  
  task automatic run_phase(uvm_phase phase);

  phase.raise_objection(this);
  `uvm_info("MY_TEST", "AHB2APB UVM Test running sequences!", UVM_LOW)

  begin
    // Create and start sequences
    single_write_seq sw_seq = single_write_seq::type_id::create("sw_seq");
    single_read_seq sr_seq = single_read_seq::type_id::create("sr_seq");
    burst_write_seq bw_seq = burst_write_seq::type_id::create("bw_seq");
    burst_read_seq br_seq = burst_read_seq::type_id::create("br_seq");
    slave_access_fail_seq saf_seq = slave_access_fail_seq::type_id::create("saf_seq");
    ahb_sequence aseq = ahb_sequence::type_id::create("aseq"); // <== Add this!

    // Start sequences
    sw_seq.start(env.ahb_agnt.hsequencer);
    sr_seq.start(env.ahb_agnt.hsequencer);
    bw_seq.start(env.ahb_agnt.hsequencer);
    br_seq.start(env.ahb_agnt.hsequencer);
    saf_seq.start(env.ahb_agnt.hsequencer);
    aseq.start(env.ahb_agnt.hsequencer); // <== And this!
  end

  phase.drop_objection(this);
endtask


endclass

`endif
