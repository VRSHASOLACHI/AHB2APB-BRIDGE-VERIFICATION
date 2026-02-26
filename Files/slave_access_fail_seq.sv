`ifndef SLAVE_ACCESS_FAIL_SEQ_SV
`define SLAVE_ACCESS_FAIL_SEQ_SV

class slave_access_fail_seq extends uvm_sequence #(cmn_seq_item);
  `uvm_object_utils(slave_access_fail_seq)

  function new(string name = "slave_access_fail_seq");
    super.new(name);
  endfunction

  task body();
    cmn_seq_item tr = cmn_seq_item::type_id::create("tr");
    start_item(tr);

    tr.ADDR = 32'hFFF;  // Out-of-range address (forces default slave or error)
    tr.operation = tr.READ;
    tr.BURSTMODE = tr.SINGLE;
    tr.SLAVE_NUMBER = 3'd7; // Intentionally pointing to the last slave

    finish_item(tr);
    `uvm_info("SEQUENCE", $sformatf("Slave Access Fail Test: Addr=0x%0h Slave=%0d", tr.ADDR, tr.SLAVE_NUMBER), UVM_LOW)
  endtask

endclass

`endif
