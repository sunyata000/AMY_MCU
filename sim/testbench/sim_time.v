//******************************************************************************
//
//******************************************************************************


`include "PODES_M0A_reg_define.h"
`include "AMY_reg_define.h"


module testcase ();

integer sim_time_limitation = (20*50*1000*20); //20ms
wire        cpu_clk = testbench.AMY_u0.clk;

//---------------------------------------------------------
//simulation time is expired.
//---------------------------------------------------------
initial
 begin
     repeat (50*1000*2) @(posedge cpu_clk); 
    #20;
    $display ("[AMY]:========simulation time is expired.=========");
    repeat (10) @(posedge cpu_clk);
    $finish(1);
 end


endmodule