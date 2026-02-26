// Code your design here

// MACROS
`define T_IDLE        2'b00
`define T_BUSY        2'b01
`define T_NONSEQ      2'b10
`define T_SEQ         2'b11

`define PSELx_Default 8'b0

`define VALID         1'b1
`define INVALID       1'b0

`define ENABLE        1'b1
`define DISABLE_      1'b0
`define READY         1'b1
`define NOT_READY     1'b0

`define WRITE         1'b1
`define READ          1'b0

`define RESET         1'b0

`define ERROR         1'b1
`define NO_ERROR      1'b0

`define SLAVE_1       8'h01
`define SLAVE_2       8'h02
`define SLAVE_3       8'h04
`define SLAVE_4       8'h08
`define SLAVE_5       8'h10
`define SLAVE_6       8'h20
`define SLAVE_7       8'h40
`define SLAVE_8       8'h80
`define SLAVE_DEFAULT 8'h01

`define SLAVE_NO_1    3'd0
`define SLAVE_NO_2    3'd1
`define SLAVE_NO_3    3'd2
`define SLAVE_NO_4    3'd3
`define SLAVE_NO_5    3'd4
`define SLAVE_NO_6    3'd5
`define SLAVE_NO_7    3'd6
`define SLAVE_NO_8    3'd7
`define SLAVE_NO_DEFAULT 3'd0


module ahb2apb 
    #(parameter NO_OF_SLAVES = 8,
      parameter ADDR_WIDTH = 32,
      parameter DATA_WIDTH = 32,
      parameter SLAVE_START_ADDR_0 = 32'h000,
      parameter SLAVE_END_ADDR_0 = 32'h0ff,
      parameter SLAVE_START_ADDR_1 = 32'h100,
      parameter SLAVE_END_ADDR_1 = 32'h1ff,
      parameter SLAVE_START_ADDR_2 = 32'h200,
      parameter SLAVE_END_ADDR_2 = 32'h2ff,
      parameter SLAVE_START_ADDR_3 = 32'h300,
      parameter SLAVE_END_ADDR_3 = 32'h3ff,
      parameter SLAVE_START_ADDR_4 = 32'h400,
      parameter SLAVE_END_ADDR_4 = 32'h4ff,
      parameter SLAVE_START_ADDR_5 = 32'h500,
      parameter SLAVE_END_ADDR_5 = 32'h5ff,
      parameter SLAVE_START_ADDR_6 = 32'h600,
      parameter SLAVE_END_ADDR_6 = 32'h6ff,
      parameter SLAVE_START_ADDR_7 = 32'h700,
      parameter SLAVE_END_ADDR_7 = 32'h7ff)

    (input wire HCLK, HRESETn,
     input wire [ADDR_WIDTH-1:0] HADDR,
     input wire [1:0] HTRANS,
     input wire HWRITE,
     input wire [DATA_WIDTH-1:0] HWDATA,
     input wire HSELAHB,
     output reg [DATA_WIDTH-1:0] HRDATA,
     output reg HREADY,
     output reg HRESP,
     input wire [DATA_WIDTH-1:0] PRDATA [NO_OF_SLAVES-1:0],
     input wire [NO_OF_SLAVES-1:0] PSLVERR,
     input wire [NO_OF_SLAVES-1:0] PREADY,
     output reg [DATA_WIDTH-1:0] PWDATA,
     output reg PENABLE,
     output reg [NO_OF_SLAVES-1:0] PSELx,
     output reg [ADDR_WIDTH-1:0] PADDR,
     output reg PWRITE);

    // AHB Signal assignments
    reg [ADDR_WIDTH-1:0] HADDR_Temp;
    reg [ADDR_WIDTH-1:0] HADDR_Temp2;
    reg [DATA_WIDTH-1:0] HWDATA_Temp;
    reg [NO_OF_SLAVES-1:0] PSELx_Temp;
    reg [NO_OF_SLAVES-1:0] PSELx_Curr;
    reg [2:0] Slave_number;

    // States for FSM
    typedef enum {IDLE, READ, W_WAIT, WRITE, WRITE_P, W_ENABLE, W_ENABLE_P, R_ENABLE} states;
    states current_state, next_state;

    // Control signals
    reg valid;
    reg HWRITE_Reg;

    // Valid signal handling
    always @(negedge HCLK) begin
        if (HRESETn == 1'b0)
            valid <= 1'b0;
        else if (HSELAHB && (HTRANS == 2'b10 || HTRANS == 2'b11))
            valid <= 1'b1;
        else
            valid <= 1'b0;
    end

    // State change assignment
    always @(negedge HCLK) begin
        if (PSLVERR[Slave_number] == 1'b0) begin
            if (HRESETn == 1'b0)
                current_state <= IDLE;
            else
                current_state <= next_state;
            HRESP <= 1'b0;
        end else begin
            current_state <= IDLE;
            HRESP <= 1'b1;
        end
    end

    // FSM transitions
    always @(posedge HCLK) begin
        case (current_state)
            IDLE: begin
                PSELx = 8'b0;
                PENABLE = 1'b0;
                HREADY = 1'b1;

                if (valid == 1'b0)
                    next_state <= IDLE;
                else if (valid == 1'b1) begin
                    HADDR_Temp = HADDR;
                    if (HWRITE == 1'b0) // Read
                        next_state <= READ;
                    else // Write
                        next_state <= W_WAIT;
                end
            end
            READ: begin
                PSELx = PSELx_Curr;
                PADDR = HADDR_Temp;
                PWRITE = 1'b0; // Read
                PENABLE = 1'b0;
                HREADY = 1'b1;

                next_state <= R_ENABLE;
            end
            W_WAIT: begin
                PENABLE = 1'b0;
                HWRITE_Reg = HWRITE;
                PSELx_Temp = PSELx_Curr;
                HWDATA_Temp = HWDATA;
                HADDR_Temp2 = HADDR_Temp;

                if (valid == 1'b0) begin
                    HREADY = 1'b1;
                    next_state <= WRITE;
                end else if (valid == 1'b1) begin
                    next_state <= WRITE_P;
                    HADDR_Temp = HADDR;
                    HREADY = 1'b0;
                end
            end
            WRITE: begin
                HREADY = 1'b1;
                PSELx = PSELx_Temp;
                PADDR = HADDR_Temp2;
                PWDATA = HWDATA_Temp;
                PWRITE = 1'b1; // Write
                PENABLE = 1'b0;

                if (valid == 1'b0)
                    next_state <= W_ENABLE;
                else if (valid == 1'b1)
                    next_state <= W_ENABLE_P;
            end
            WRITE_P: begin
                PSELx = PSELx_Temp;
                PADDR = HADDR_Temp2;
                PWDATA = HWDATA_Temp;
                HWDATA_Temp = HWDATA;
                PWRITE = 1'b1; // Write
                PENABLE = 1'b0;
                HREADY = 1'b1;
                next_state <= W_ENABLE_P;
            end
            W_ENABLE: begin
                if (PREADY[Slave_number] == 1'b1) begin
                    PENABLE = 1'b1;
                    HREADY = 1'b0;

                    if (valid == 1'b1 && HWRITE == 1'b0)
                        next_state <= READ;
                    else if (valid == 1'b1 && HWRITE == 1'b1)
                        next_state <= W_WAIT;
                    else if (valid == 1'b0)
                        next_state <= IDLE;
                end else
                    next_state <= W_ENABLE;
            end
            W_ENABLE_P: begin
                if (PREADY[Slave_number] == 1'b1) begin
                    PENABLE = 1'b1;
                    HREADY = 1'b0;
                    PSELx_Temp = PSELx_Curr;
                    HADDR_Temp = HADDR;

                    if (valid == 1'b1 && HWRITE == 1'b1)
                        next_state <= WRITE_P;
                    else if (valid == 1'b0 && HWRITE == 1'b1)
                        next_state <= WRITE;
                    else if (HWRITE == 1'b0)
                        next_state <= READ;
                end else
                    next_state <= W_ENABLE_P;
            end
            R_ENABLE: begin
                if (PREADY[Slave_number] == 1'b1) begin
                    PENABLE = 1'b1;
                    HRDATA = PRDATA[Slave_number];
                    HREADY = 1'b1;
                    HADDR_Temp = HADDR;

                    if (valid == 1'b0)
                        next_state <= IDLE;
                    else if (HWRITE == 1'b0)
                        next_state <= READ;
                    else if (HWRITE == 1'b1)
                        next_state <= W_WAIT;
                end else
                    next_state <= R_ENABLE;
            end
        endcase
    end

    // Slave selection logic
    always @(posedge HCLK) begin
        PSELx_Curr = 8'b0;
        Slave_number = 3'b0;

        if (HADDR_Temp >= SLAVE_START_ADDR_0 && HADDR_Temp <= SLAVE_END_ADDR_0) begin
            PSELx_Curr = 8'h01;
            Slave_number = 3'd0;
        end
        if (HADDR_Temp >= SLAVE_START_ADDR_1 && HADDR_Temp <= SLAVE_END_ADDR_1) begin
            PSELx_Curr = 8'h02;
            Slave_number = 3'd1;
        end
        if (HADDR_Temp >= SLAVE_START_ADDR_2 && HADDR_Temp <= SLAVE_END_ADDR_2) begin
            PSELx_Curr = 8'h04;
            Slave_number = 3'd2;
        end
        if (HADDR_Temp >= SLAVE_START_ADDR_3 && HADDR_Temp <= SLAVE_END_ADDR_3) begin
            PSELx_Curr = 8'h08;
            Slave_number = 3'd3;
        end
        if (HADDR_Temp >= SLAVE_START_ADDR_4 && HADDR_Temp <= SLAVE_END_ADDR_4) begin
            PSELx_Curr = 8'h10;
            Slave_number = 3'd4;
        end
        if (HADDR_Temp >= SLAVE_START_ADDR_5 && HADDR_Temp <= SLAVE_END_ADDR_5) begin
            PSELx_Curr = 8'h20;
            Slave_number = 3'd5;
        end
        if (HADDR_Temp >= SLAVE_START_ADDR_6 && HADDR_Temp <= SLAVE_END_ADDR_6) begin
            PSELx_Curr = 8'h40;
            Slave_number = 3'd6;
        end
        if (HADDR_Temp >= SLAVE_START_ADDR_7 && HADDR_Temp <= SLAVE_END_ADDR_7) begin
            PSELx_Curr = 8'h80;
            Slave_number = 3'd7;
        end
    end
endmodule
