`ifndef AHB_MONITOR_SV
`define AHB_MONITOR_SV

class ahb_monitor extends uvm_monitor;
  `uvm_component_utils(ahb_monitor)

  virtual ahb2apb_if vif;
  uvm_analysis_port #(cmn_seq_item) item_collected_port;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual ahb2apb_if)::get(this, "", "vif", vif))
      `uvm_fatal("AHB_MONITOR", "Virtual interface not set!")

    `uvm_info("AHB_MONITOR", "Build phase completed", UVM_LOW)
  endfunction

  task run_phase(uvm_phase phase);
    cmn_seq_item tr;
    forever begin
      @(posedge vif.HCLK);

      assert_AHB_valid_transfer: assert (!(vif.HSELAHB && vif.HREADY) || 
                                        ((vif.HTRANS == 2'b10) || (vif.HTRANS == 2'b11))) 
        else `uvm_error("AHB_ASSERTION", $sformatf("Invalid AHB transfer! HSEL=%0b, HTRANS=%0b at time %0t", vif.HSELAHB, vif.HTRANS, $time));

      if (vif.HSELAHB && vif.HREADY) begin
        tr = cmn_seq_item::type_id::create("tr", this);
        tr.ADDR = vif.HADDR;
        tr.operation = cmn_seq_item::operation_e'(vif.HWRITE);// vif.HWRITE;
        tr.HRESP = vif.HRESP;

        if (vif.HWRITE == tr.WRITE) begin
          tr.DATA = vif.HWDATA;
          `uvm_info("AHB_MONITOR", $sformatf("Captured WRITE transaction: Addr=0x%0h, Data=0x%0h, HRESP=%0b", tr.ADDR, tr.DATA, tr.HRESP), UVM_LOW)
        end else begin
          tr.DATA = vif.HRDATA;
          `uvm_info("AHB_MONITOR", $sformatf("Captured READ transaction: Addr=0x%0h, Data=0x%0h, HRESP=%0b", tr.ADDR, tr.DATA, tr.HRESP), UVM_LOW)
        end

        item_collected_port.write(tr);
      end
    end
  endtask

endclass

`endif
