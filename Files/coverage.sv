`ifndef MYCOVERAGE_SV
`define MYCOVERAGE_SV

class mycoverage extends uvm_object;
  `uvm_object_utils(mycoverage)

  cmn_seq_item ahb_item;
  cmn_seq_item apb_item;

  // Define coverage group
  covergroup A;
    
    // Coverpoint for AHB operation (read/write)
    operation: coverpoint ahb_item.operation {
      bins x1[] = {0, 1};    // 0: Read, 1: Write
    }
    
    // Coverpoint for AHB HSIZE (size of the data transfer)
    HSIZE: coverpoint ahb_item.HSIZE {
      bins x2[] = {0, 1, 2};    // 0: 8-bit, 1: 16-bit, 2: 32-bit
    }
    
    // Coverpoint for address values (boundary, normal values)
    address: coverpoint ahb_item.ADDR {  // Changed from address to ADDR
      bins addr_normal[] = {32'h00000000, 32'hFFFF0000};   // Normal addresses
      bins addr_edge[] = {32'h00000000, 32'hFFFFFFFF};     // Edge case addresses
    }
    
    // Cross coverage between operation and HSIZE
    CROSS: cross operation, HSIZE;
    
    // Cross coverage between address and operation
    CROSS_ADDR_OP: cross address, operation;
    
    // Cross coverage between address and HSIZE
    CROSS_ADDR_HSIZE: cross address, HSIZE;

    // Functional coverage for read/write cycles
    read_write_cycles: coverpoint ahb_item.operation {
      bins rw[] = {0, 1};   // Read (0) / Write (1)
    }
    address_ranges: coverpoint ahb_item.ADDR {  // Changed from address to ADDR
      bins addr_range[] = {32'h00000000, 32'hFFFF0000, 32'h80000000};  // Common ranges in AHB
    }
  
  endgroup

  // Constructor
  function new(string name="mycoverage");
    super.new(name);
    ahb_item = cmn_seq_item::type_id::create("ahb_item");
    apb_item = cmn_seq_item::type_id::create("apb_item");
    A = new;  // Create coverage group
  endfunction

  // Sample function to capture coverage data
  function void sample();
    A.sample();  // This would be called during simulation to capture the coverage data
  endfunction

endclass

`endif
