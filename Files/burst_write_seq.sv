`ifndef BURST_WRITE_SEQ_SV
`define BURST_WRITE_SEQ_SV

class burst_write_seq extends uvm_sequence #(cmn_seq_item);
  `uvm_object_utils(burst_write_seq)

  function new(string name = "burst_write_seq");
    super.new(name);
  endfunction

  task body();
    // Define the array for loop iteration
    integer i;
    integer indices[4]; // Array of size 4
    
    // Initialize the array (you can set it to a range if needed)
    foreach (indices[i]) begin
      indices[i] = i;  // Set indices[i] to i
    end

    // Loop over the indices array
    foreach (indices[i]) begin
      cmn_seq_item tr = cmn_seq_item::type_id::create($sformatf("burst_wr_tr[%0d]", i));
      start_item(tr);

      tr.ADDR         = $urandom_range(32'h000, 32'h7FF);
      tr.DATA         = $urandom();
      tr.operation    = tr.WRITE;
      tr.BURSTMODE    = tr.BURST4;
      tr.SLAVE_NUMBER = (tr.ADDR >> 8) & 3'd7;

      finish_item(tr);
      `uvm_info("SEQUENCE", $sformatf("Burst Write [%0d]: Addr=0x%0h Data=0x%0h Slave=%0d", i, tr.ADDR, tr.DATA, tr.SLAVE_NUMBER), UVM_LOW)
    end
  endtask

endclass

`endif
