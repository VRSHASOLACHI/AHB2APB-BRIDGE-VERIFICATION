`ifndef SINGLE_WRITE_SEQ_SV
`define SINGLE_WRITE_SEQ_SV

class single_write_seq extends uvm_sequence #(cmn_seq_item);
  `uvm_object_utils(single_write_seq)

  function new(string name = "single_write_seq");
    super.new(name);
  endfunction

  task body();
    cmn_seq_item tr = cmn_seq_item::type_id::create("tr");
    start_item(tr);

    tr.ADDR      = $urandom_range(32'h000, 32'h7FF); // Match your address space
    tr.DATA      = $urandom();
    tr.operation = tr.WRITE;
    tr.BURSTMODE = tr.SINGLE;
    tr.SLAVE_NUMBER = (tr.ADDR >> 8) & 3'd7;  // Slave selector

    finish_item(tr);
    `uvm_info("SEQUENCE", $sformatf("Single Write: Addr=0x%0h Data=0x%0h Slave=%0d", tr.ADDR, tr.DATA, tr.SLAVE_NUMBER), UVM_LOW)
  endtask

endclass

`endif
