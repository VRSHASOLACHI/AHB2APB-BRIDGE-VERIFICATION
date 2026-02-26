`define ADDR_WIDTH 32
`define DATA_WIDTH 32



///////////////copied from design.sv



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


