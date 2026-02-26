`ifndef CMN_SEQ_ITEM_SV
`define CMN_SEQ_ITEM_SV

class cmn_seq_item extends uvm_sequence_item;
  `uvm_object_utils(cmn_seq_item)

  // Randomized fields
  rand bit [31:0] ADDR;           // Address of the transaction
  rand bit [31:0] DATA;           // Data for the transaction
  rand bit [2:0]  SLAVE_NUMBER;   // Slave number selector
  rand bit        HRESP;          // Response status: 0 = OKAY, 1 = ERROR

  // Adding enums for operation types and burst modes
  typedef enum logic {WRITE = 1'b0, READ = 1'b1} operation_e;
  typedef enum logic [2:0] {SINGLE = 3'b000, BURST4 = 3'b001} burstmode_e;

  // Fields for operations and burst modes (removing rand here)
  operation_e operation;          // Operation type (WRITE or READ)
  burstmode_e BURSTMODE;          // Burst mode (SINGLE, BURST4)

  // Placeholder for HSIZE (assuming it's related to transfer size)
  rand bit [1:0] HSIZE;           // Size of the transfer (2 bits, for example)

  function new(string name = "cmn_seq_item");
    super.new(name);
  endfunction

  // Override randomization of the enums
  function void randomize_operation_and_burst();
    // Randomize operation and burst mode
    if (!randomize(operation)) begin
      `uvm_error("RANDOMIZE_ERROR", "Failed to randomize operation.")
    end
    if (!randomize(BURSTMODE)) begin
      `uvm_error("RANDOMIZE_ERROR", "Failed to randomize burst mode.")
    end
    if (!randomize(HSIZE)) begin
      `uvm_error("RANDOMIZE_ERROR", "Failed to randomize HSIZE.")
    end
  endfunction

  // Printing function to display values of the fields
  function void do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_field("ADDR", ADDR, 32);
    printer.print_field("DATA", DATA, 32);
    printer.print_field("SLAVE_NUMBER", SLAVE_NUMBER, 3);
    printer.print_field("operation", operation, 1);
    printer.print_field("BURSTMODE", BURSTMODE, 3);
    printer.print_field("HSIZE", HSIZE, 2);   // Print HSIZE field
    printer.print_field("HRESP", HRESP, 1);   // Print the new field (HRESP)
  endfunction

endclass

`endif
