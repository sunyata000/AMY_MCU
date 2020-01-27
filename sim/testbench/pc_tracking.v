//******************************************************************************
//
//******************************************************************************


module pc_tracking (test_done);

input test_done;


wire [31:0] ie_pc = testbench.AMY_M0O_TOP_u0.AMY_M0O_u0.PODES_M0O_u0.inst_unit_u0.inst_exe_u0.ie_pc;



//========================================================
//Monitor the IE PC
//========================================================

integer f2;

initial
begin
 f2 = $fopen ("pc_tracking.log", "w");
 wait (test_done);
 $fclose (f2);
end


always @(ie_pc)
begin
    $fdisplay (f2, "%h", (ie_pc));                         
end



endmodule
