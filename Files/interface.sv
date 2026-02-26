`ifndef AHB2APB_IF_SV
`define AHB2APB_IF_SV

interface ahb2apb_if #(parameter NO_OF_SLAVES = 8) (input bit HCLK, input bit PCLK);

  // Clock & Reset
  logic HRESETn;

  // AHB signals
  logic [31:0] HADDR;
  logic [1:0]  HTRANS;
  logic HWRITE;
  logic [31:0] HWDATA;
  logic HSELAHB;
  logic [31:0] HRDATA;
  logic HREADY;
  logic HRESP;

  // APB signals
  logic [31:0] PRDATA [NO_OF_SLAVES-1:0];
  logic [NO_OF_SLAVES-1:0] PSLVERR;
  logic [NO_OF_SLAVES-1:0] PREADY;
  logic [31:0] PWDATA;
  logic PENABLE;
  logic [7:0]  PSELx;
  logic [31:0] PADDR;
  logic PWRITE;

  // APB Driver modport
  modport apb_drv_mp (
    input  PCLK, PADDR, PENABLE, PSELx, PWRITE,
    output PREADY, PSLVERR, PRDATA
  );

endinterface

`endif
