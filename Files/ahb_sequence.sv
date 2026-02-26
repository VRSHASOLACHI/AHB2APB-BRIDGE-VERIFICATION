`ifndef AHB_SEQUENCE_SV
`define AHB_SEQUENCE_SV

class ahb_sequence extends uvm_sequence #(cmn_seq_item);
  `uvm_object_utils(ahb_sequence)

  function new(string name="ahb_sequence");
    super.new(name);
  endfunction

  virtual task body();
    // Make sure cmn_seq_item is properly imported
    cmn_seq_item req;
    req = cmn_seq_item::type_id::create("req");
    start_item(req);

assert(req.randomize()) else
  `uvm_error("AHB_SEQUENCE", "Randomization failed!")

//    req.randomize();
    finish_item(req);

    `uvm_info("AHB_SEQUENCE", $sformatf("Generated transaction:\n%s", req.sprint()), UVM_LOW)
  endtask
endclass

`endif
