`ifndef SCOREBOARD_SV
`define SCOREBOARD_SV

`include "coverage.sv"
typedef class cmn_seq_item;

class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)

  uvm_analysis_imp #(cmn_seq_item, scoreboard) ahb_port;
  uvm_analysis_imp #(cmn_seq_item, scoreboard) apb_port;

  cmn_seq_item ahb_data[$];  // Queue for transactions
  cmn_seq_item apb_data[$];

  mycoverage cov;

  function new(string name = "scoreboard", uvm_component parent = null);
    super.new(name, parent);
    cov = new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ahb_port = new("ahb_port", this);
    apb_port = new("apb_port", this);
  endfunction

  virtual function void write(cmn_seq_item tr);
    if (tr == null) return;

    // Simple way to detect where data came from
    if (tr.operation == tr.WRITE || tr.operation == tr.READ) begin
      ahb_data.push_back(tr);
    end else begin
      apb_data.push_back(tr);
    end

    // Ensure both queues have data before attempting to pop
    if ((ahb_data.size() > 0) && (apb_data.size() > 0)) begin
      cmn_seq_item ahb_tr = ahb_data.pop_front();
      cmn_seq_item apb_tr = apb_data.pop_front();

      cov.ahb_item = ahb_tr;
      cov.apb_item = apb_tr;
      cov.A.sample();

      if (ahb_tr.operation == ahb_tr.WRITE) begin
        if (ahb_tr.DATA === apb_tr.DATA)
          `uvm_info("SCOREBOARD", $sformatf("WRITE MATCH: Addr=0x%0h Data=0x%0h", ahb_tr.ADDR, ahb_tr.DATA), UVM_LOW)
        else
          `uvm_error("SCOREBOARD", $sformatf("WRITE MISMATCH! Expected=0x%0h Got=0x%0h", ahb_tr.DATA, apb_tr.DATA))
      end else begin
        if (apb_tr.DATA === ahb_tr.DATA)
          `uvm_info("SCOREBOARD", $sformatf("READ MATCH: Addr=0x%0h Data=0x%0h", ahb_tr.ADDR, apb_tr.DATA), UVM_LOW)
        else
          `uvm_error("SCOREBOARD", $sformatf("READ MISMATCH! Expected=0x%0h Got=0x%0h", apb_tr.DATA, ahb_tr.DATA))
      end
    end else begin
      // Log if one of the queues is empty when attempting comparison
      if (ahb_data.size() == 0) 
        `uvm_warning("SCOREBOARD", "AHB Queue is empty, no AHB transaction to compare.")
      if (apb_data.size() == 0) 
        `uvm_warning("SCOREBOARD", "APB Queue is empty, no APB transaction to compare.")
    end
  endfunction

endclass

`endif
