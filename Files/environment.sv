`ifndef CMN_ENV_SV
`define CMN_ENV_SV

//`include "scoreboard.sv"
//`include "apb_agent.sv"
//`include "ahb_agent.sv"

class cmn_env extends uvm_env;
  `uvm_component_utils(cmn_env)

  ahb_agent ahb_agnt;
  apb_agent apb_agnt;      
  scoreboard scb;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction 

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ahb_agnt = ahb_agent::type_id::create("ahb_agnt", this);
    apb_agnt = apb_agent::type_id::create("apb_agnt", this);
    scb      = scoreboard::type_id::create("scb", this);
  endfunction 

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    ahb_agnt.hmonitor.item_collected_port.connect(scb.ahb_port);
    apb_agnt.pmonitor.item_collected_port.connect(scb.apb_port);
  endfunction 

endclass 

`endif
