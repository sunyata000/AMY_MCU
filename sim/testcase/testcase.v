//******************************************************************************
//
//******************************************************************************


`include "PODES_M0A_reg_define.h"
`include "AMY_reg_define.h"


module testcase (sim_done);
output sim_done;

reg sim_done = 0;

//program runs from boot space.
initial
 begin
    #1ns;
	testbench.boot_reg = 1'b0; //0: boot space; 1: normal rom space.
 end

endmodule
