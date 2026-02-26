`ifndef BURST_READ_SEQ_SV
`define BURST_READ_SEQ_SV

class burst_read_seq extends uvm_sequence #(cmn_seq_item);
  `uvm_object_utils(burst_read_seq)

  function new(string name = "burst_read_seq");
    super.new(name);
  endfunction

  task body();
    // Change 'foreach' to 'for' loop
    integer i;
    for (i = 0; i < 4; i = i + 1) begin
      cmn_seq_item tr = cmn_seq_item::type_id::create($sformatf("burst_rd_tr[%0d]", i));
      start_item(tr);

      tr.ADDR         = $urandom_range(32'h000, 32'h7FF);
      tr.operation    = tr.READ;
      tr.BURSTMODE    = tr.BURST4;
      tr.SLAVE_NUMBER = (tr.ADDR >> 8) & 3'd7;

      finish_item(tr);
      `uvm_info("SEQUENCE", $sformatf("Burst Read [%0d]: Addr=0x%0h Slave=%0d", i, tr.ADDR, tr.SLAVE_NUMBER), UVM_LOW)
    end
  endtask

endclass

`endif
