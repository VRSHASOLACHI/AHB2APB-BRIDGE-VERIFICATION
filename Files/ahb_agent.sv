`ifndef AHB_AGENT_SV
`define AHB_AGENT_SV

class ahb_agent extends uvm_agent;
  `uvm_component_utils(ahb_agent)

  ahb_driver     hdriver;
  ahb_monitor    hmonitor;
  ahb_sequencer  hsequencer;
  virtual ahb2apb_if vif;  // ← match your real interface

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual ahb2apb_if)::get(this, "", "vif", vif))
      `uvm_fatal("AGENT", "Cannot get() ahb2apb_if from config DB");

    hmonitor    = ahb_monitor::type_id::create("hmonitor", this);
    hdriver     = ahb_driver::type_id::create("hdriver", this);
    hsequencer  = ahb_sequencer::type_id::create("hsequencer", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    hdriver.seq_item_port.connect(hsequencer.seq_item_export);
  endfunction

endclass

`endif
