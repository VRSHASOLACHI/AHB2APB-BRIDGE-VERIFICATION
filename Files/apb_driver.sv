`ifndef APB_DRIVER_SV
`define APB_DRIVER_SV

class apb_driver extends uvm_driver #(cmn_seq_item);
  `uvm_component_utils(apb_driver)

  virtual ahb2apb_if vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual ahb2apb_if)::get(this, "", "vif", vif))
      `uvm_fatal("APB_DRIVER", "Virtual interface not set")

    `uvm_info("APB_DRIVER", "Build phase completed", UVM_LOW)
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      seq_item_port.get_next_item(req);
      `uvm_info("APB_DRIVER", $sformatf("Received item: Addr=0x%0h, op=%0s", req.ADDR, (req.operation == req.READ ? "READ" : "WRITE")), UVM_LOW)
      drive_apb(req);
      seq_item_port.item_done();
    end
  endtask

  virtual task drive_apb(cmn_seq_item tr);
    int slave;
    slave = tr.SLAVE_NUMBER;

    @(posedge vif.PCLK);

    if (tr.operation == tr.WRITE) begin
      wait (vif.PSELx[slave] == 1'b1 && vif.PWRITE == 1'b1 && vif.PENABLE == 1'b1);

      `uvm_info("APB_DRIVER", $sformatf("WRITE Detected: Addr=0x%0h Data=0x%0h", vif.PADDR, vif.PWDATA), UVM_LOW);

      @(posedge vif.PCLK);
      vif.PREADY[slave]  <= `READY;
      vif.PSLVERR[slave] <= `NO_ERROR;

      @(posedge vif.PCLK);
      vif.PREADY[slave] <= `NOT_READY;
    end

    else begin
      wait (vif.PSELx[slave] == 1'b1 && vif.PWRITE == 1'b0 && vif.PENABLE == 1'b1);

      vif.PRDATA[slave] <= tr.DATA;

      `uvm_info("APB_DRIVER", $sformatf("READ Detected: Sending PRDATA[Slave %0d]=0x%0h", slave, tr.DATA), UVM_LOW);

      @(posedge vif.PCLK);
      vif.PREADY[slave]  <= `READY;
      vif.PSLVERR[slave] <= `NO_ERROR;

      @(posedge vif.PCLK);
      vif.PREADY[slave] <= `NOT_READY;
    end
  endtask

endclass

`endif
