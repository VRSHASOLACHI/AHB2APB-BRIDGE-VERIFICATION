`ifndef AHB_DRIVER_SV
`define AHB_DRIVER_SV

class ahb_driver extends uvm_driver #(cmn_seq_item);
  `uvm_component_utils(ahb_driver)

  virtual ahb2apb_if vif;
  logic resetn;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual ahb2apb_if)::get(this, "", "vif", vif))
      `uvm_fatal("AHB_DRIVER", "Virtual interface not set")
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      seq_item_port.get_next_item(req);
      drive_ahb(req);
      seq_item_port.item_done();
      assert_ahb_transaction(req);
    end
  endtask

  virtual task drive_ahb(cmn_seq_item tr);
    @(posedge vif.HCLK);
    wait (vif.HREADY == 1'b1);

    vif.HSELAHB <= 1'b1;
    vif.HADDR <= tr.ADDR;
    vif.HWRITE <= tr.operation;
    vif.HTRANS <= (tr.operation == tr.READ) ? `T_NONSEQ : `T_SEQ;
    vif.HWDATA <= tr.DATA;

    `uvm_info("AHB_DRIVER", $sformatf("Transaction started: Addr=0x%0h, Data=0x%0h, op=%0s, HREADY=%0h, HRESP=%0h",
      tr.ADDR, tr.DATA, (tr.operation == tr.READ ? "READ" : "WRITE"), vif.HREADY, vif.HRESP), UVM_LOW);

    wait (vif.HREADY == 1'b1);

    if (vif.HRESP == `ERROR) begin
      `uvm_warning("AHB_DRIVER", $sformatf("Warning: Error Response at Address 0x%0h, HRESP=%0h", tr.ADDR, vif.HRESP));
    end else begin
      if (tr.operation == tr.READ) begin
        tr.DATA = vif.HRDATA;
        `uvm_info("AHB_DRIVER", $sformatf("Read Data: Addr=0x%0h, Data=0x%0h", tr.ADDR, tr.DATA), UVM_LOW);
      end

      `uvm_info("AHB_DRIVER", $sformatf("Transaction completed: Addr=0x%0h, Data=0x%0h", tr.ADDR, tr.DATA), UVM_LOW);
    end
  endtask

  virtual task assert_ahb_transaction(cmn_seq_item tr);
    @(posedge vif.HCLK);
    if (vif.HREADY && (vif.HRESP != 2'b00)) begin
      `uvm_warning("AHB_DRIVER", $sformatf("Warning: Invalid HRESP or HREADY signal during transaction. Addr=0x%0h, HRESP=%0h", tr.ADDR, vif.HRESP));
    end
  endtask

endclass

`endif
