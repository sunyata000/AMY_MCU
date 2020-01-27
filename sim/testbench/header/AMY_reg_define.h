
//-----------------------------
//register address
//-----------------------------

`define UART0_DATA      32'h40000000
`define UART0_STATUS    32'h40000004
`define UART0_CTRL      32'h40000008
`define UART0_SCALER    32'h4000000C
`define UART0_FIFO      32'h40000010


//----------------------------------
//register default value
//----------------------------------
`define INIT_VAL_UART0_DATA        32'h00000000
`define INIT_VAL_UART0_STATUS      32'h00000000
`define INIT_VAL_UART0_CTRL        32'h00000000
`define INIT_VAL_UART0_SCALER      32'h00000000
`define INIT_VAL_UART0_FIFO        32'h00000000