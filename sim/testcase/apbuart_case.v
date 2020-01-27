//******************************************************************************
//
//******************************************************************************


`include "PODES_M0A_reg_define.h"
`include "AMY_reg_define.h"


module testcase (sim_done);
output sim_done;

reg sim_done = 0;
reg [31:0] rd_data;
reg c_halt;

initial
begin
    ahb_idle (20);
//===============================================
//Hold on CPU
//===============================================
  c_halt = 1'b1;
  ahb_reg_read (`DHCSR   , 4'b1111, rd_data );
  rd_data[1] = c_halt;
  rd_data[31:16] = 16'ha05f;
  ahb_reg_write (`DHCSR , 4'b1111, rd_data);
  

//====================================================    
//read back all registers' default value
//====================================================    

//UART0
    ahb_reg_read_cmp (`UART0_DATA     , 4'b1111, `INIT_VAL_UART0_DATA   );
    ahb_reg_read_cmp (`UART0_STATUS   , 4'b1111, `INIT_VAL_UART0_STATUS );
    ahb_reg_read_cmp (`UART0_CTRL     , 4'b1111, `INIT_VAL_UART0_CTRL   );
    ahb_reg_read_cmp (`UART0_SCALER   , 4'b1111, `INIT_VAL_UART0_SCALER );
    
   $display ("[TESTCASE] Register default value checking is done!, @%0d", $time); 
  

//====================================================    
//Initialize the UART 
//====================================================   
    ahb_reg_write (`UART0_SCALER   , 4'b1111, 32'd53 ); //115200baud rate under 50Mhz clock
    ahb_reg_write (`UART0_CTRL     , 4'b1111, 32'h0000_008f   );
    ahb_reg_write (`UART0_STATUS   , 4'b1111, 32'b0 );
    //write one char
	ahb_reg_write (`UART0_DATA     , 4'b1111, 32'h0000_0055   );
	rd_data[2] = 1'b0;
	while (!rd_data[2])
	ahb_reg_read (`UART0_STATUS   , 4'b1111, rd_data );
	//write another char
    ahb_reg_write (`UART0_DATA     , 4'b1111, 32'h0000_0066   );
	rd_data[1] = 1'b0;
	while (!rd_data[1])
	ahb_reg_read (`UART0_STATUS   , 4'b1111, rd_data );
	
    sim_done = 1'b1;
  
end


endmodule
