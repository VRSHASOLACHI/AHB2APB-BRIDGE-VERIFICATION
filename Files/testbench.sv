`ifndef TB_TOP_SV
`define TB_TOP_SV

`include "interface.sv"
`include "package.sv"

module tb_top;

  import uvm_pkg::*; 
  import pkg::*; 

  bit HCLK = 0;
  bit PCLK = 0;

  always #5 HCLK = ~HCLK;
  always #5 PCLK = ~PCLK;

  // Instantiate interface
  ahb2apb_if #(8) hpvif(HCLK, PCLK);

  // Define MAX_VALID_ADDR (you should replace this with your actual valid address range)
  localparam MAX_VALID_ADDR = 32'hFFFF_FFFF;  // Example: Maximum address for your design

  // Instantiate DUT and connect ports to interface
  ahb2apb DUT (
    .HCLK     (hpvif.HCLK),
    .HRESETn  (hpvif.HRESETn),
    .HADDR    (hpvif.HADDR),
    .HTRANS   (hpvif.HTRANS),
    .HWRITE   (hpvif.HWRITE),
    .HWDATA   (hpvif.HWDATA),
    .HSELAHB  (hpvif.HSELAHB),
    .HRDATA   (hpvif.HRDATA),
    .HREADY   (hpvif.HREADY),
    .HRESP    (hpvif.HRESP),
    .PRDATA   (hpvif.PRDATA),
    .PSLVERR  (hpvif.PSLVERR),
    .PREADY   (hpvif.PREADY),
    .PWDATA   (hpvif.PWDATA),
    .PENABLE  (hpvif.PENABLE),
    .PSELx    (hpvif.PSELx),
    .PADDR    (hpvif.PADDR),
    .PWRITE   (hpvif.PWRITE)
  );

  // Pass the interface to UVM world
  initial begin
    uvm_config_db#(virtual ahb2apb_if)::set(null, "*", "vif", hpvif);
    run_test("my_test");
  end

  // Dump waveforms
  initial begin
  $dumpfile("ahb2apb_wave.vcd");
  $dumpvars(0, tb_top);  // Dump waveforms for signals inside tb_top
end
always @(posedge HCLK) begin
  // Check for out-of-range address but don't directly assign HRESP here
  if (hpvif.HADDR > MAX_VALID_ADDR) begin
    $display("Error: Address 0x%h is out of range. Expected address <= 0x%h", hpvif.HADDR, MAX_VALID_ADDR);
    // Do not drive HRESP here; let the DUT handle it
  end else begin
    // Let the DUT handle HRESP
  end
end


endmodule

`endif
