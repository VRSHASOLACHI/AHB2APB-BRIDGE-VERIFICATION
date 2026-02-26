class virtual_sequence extends uvm_sequence#(cmn_seq_item);
  `uvm_object_utils(virtual_sequence)

  ahb_sequencer ahb_seqr;
  apb_sequencer apb_seqr;

  function new(string name="virtual_sequence");
    super.new(name);
  endfunction

  task body();
    ahb_sequence ahb_seq;
    apb_sequence apb_seq;
    
    // Create the AHB and APB sequences
    ahb_seq = ahb_sequence::type_id::create("ahb_seq");
    apb_seq = apb_sequence::type_id::create("apb_seq");

    // Optional: randomize sequence items here if needed

    // Start AHB and APB sequences concurrently
    fork
      ahb_seq.start(ahb_seqr); // Start AHB sequence on AHB sequencer
      apb_seq.start(apb_seqr); // Start APB sequence on APB sequencer
    join
  endtask
endclass
