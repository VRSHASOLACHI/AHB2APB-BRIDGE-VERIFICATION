`ifndef APB_AGENT_SV
`define APB_AGENT_SV

class apb_agent extends uvm_agent;
  `uvm_component_utils(apb_agent)

  apb_driver     pdriver;
  apb_monitor    pmonitor;
  apb_sequencer  psequencer;
  virtual ahb2apb_if vif;  // ← matches your real interface

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info("APB_AGENT", "Starting build phase...", UVM_LOW)

    if (!uvm_config_db#(virtual ahb2apb_if)::get(this, "", "vif", vif))
      `uvm_fatal("AGENT", "Cannot get() ahb2apb_if from config DB");

    pmonitor    = apb_monitor::type_id::create("pmonitor", this);
    pdriver     = apb_driver::type_id::create("pdriver", this);
    psequencer  = apb_sequencer::type_id::create("psequencer", this);

    `uvm_info("APB_AGENT", "Build phase completed", UVM_LOW)
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    `uvm_info("APB_AGENT", "Connecting driver and sequencer...", UVM_LOW)

    pdriver.seq_item_port.connect(psequencer.seq_item_export);

    `uvm_info("APB_AGENT", "Driver and sequencer connected", UVM_LOW)
  endfunction

endclass

`endif
