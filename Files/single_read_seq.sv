`ifndef SINGLE_READ_SEQ_SV
`define SINGLE_READ_SEQ_SV

class single_read_seq extends uvm_sequence #(cmn_seq_item);
  `uvm_object_utils(single_read_seq)

  function new(string name = "single_read_seq");
    super.new(name);
  endfunction

  task body();
    cmn_seq_item tr = cmn_seq_item::type_id::create("tr");
    start_item(tr);

    tr.ADDR      = $urandom_range(32'h000, 32'h7FF);
    tr.operation = tr.READ;
    tr.BURSTMODE = tr.SINGLE;
    tr.SLAVE_NUMBER = (tr.ADDR >> 8) & 3'd7;

    finish_item(tr);
    `uvm_info("SEQUENCE", $sformatf("Single Read: Addr=0x%0h Slave=%0d", tr.ADDR, tr.SLAVE_NUMBER), UVM_LOW)
  endtask

endclass

`endif
