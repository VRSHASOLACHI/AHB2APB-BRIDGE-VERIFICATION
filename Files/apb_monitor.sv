`ifndef APB_MONITOR_SV
`define APB_MONITOR_SV

class apb_monitor extends uvm_monitor;
  `uvm_component_utils(apb_monitor)

  virtual ahb2apb_if vif;
  uvm_analysis_port #(cmn_seq_item) item_collected_port;

  function new(string name = "apb_monitor", uvm_component parent = null);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual ahb2apb_if)::get(this, "", "vif", vif))
      `uvm_fatal("APB_MONITOR", "Virtual interface not set!")

    `uvm_info("APB_MONITOR", "Build phase completed", UVM_LOW)
  endfunction

  task run_phase(uvm_phase phase);
    cmn_seq_item tr;
    forever begin
      @(posedge vif.PCLK);

      foreach (vif.PSELx[slave]) begin
        if (vif.PSELx[slave] && vif.PENABLE) begin
          tr = cmn_seq_item::type_id::create("tr", this);
          tr.operation = cmn_seq_item::operation_e'(vif.PWRITE);

          if (vif.PWRITE == tr.WRITE) begin
            tr.DATA = vif.PWDATA;
            `uvm_info("APB_MONITOR", $sformatf("WRITE Detected: Slave=%0d Addr=0x%0h Data=0x%0h", slave, vif.PADDR, tr.DATA), UVM_LOW)
          end else begin
            tr.DATA = vif.PRDATA[slave];
            `uvm_info("APB_MONITOR", $sformatf("READ Detected: Slave=%0d Addr=0x%0h Data=0x%0h", slave, vif.PADDR, tr.DATA), UVM_LOW)
          end

          tr.SLAVE_NUMBER = slave;
          item_collected_port.write(tr);
        end
      end

      assert (vif.PSELx != 0) else `uvm_error("APB_MONITOR", "PSELx is not set for any slave while PENABLE is high!");
      assert (vif.PWRITE == 0 || vif.PWDATA != '0) else `uvm_error("APB_MONITOR", $sformatf("Write operation with zero data at Addr=0x%0h", vif.PADDR));
    end
  endtask

endclass

`endif
