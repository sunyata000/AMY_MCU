//******************************************************************************
//
//******************************************************************************


`include "PODES_M0A_reg_define.h"
`include "AMY_reg_define.h"


module uart_monitor (test_done);

output test_done;

wire [31:0] cpu_haddr = testbench.AMY_u0.ext_shaddr;
wire [1:0]  cpu_htrans = testbench.AMY_u0.ext_shtrans;
wire        cpu_hready_in = testbench.AMY_u0.ext_shready_in;
wire        cpu_hwrite   = testbench.AMY_u0.ext_shwrite;
wire [31:0] cpu_hwdata = testbench.AMY_u0.ext_shwdata;
wire        cpu_clk = testbench.AMY_u0.clk;
wire        rst_n = testbench.AMY_u0.rst_n;


reg test_done = 0;

initial
begin
    ahb_idle (20);    
    $display ("[AMY] Start the simulation", $time); 
    wait (test_done);
    repeat (10) @(posedge cpu_clk);
    $finish(0);
      
end



//========================================================
//Monitor UART data by checking the internal data bus
//========================================================

reg uart_write;

string str_base = "";
integer f2;

//initial
//begin
// f2 = $fopen ("uart0_monitor.log", "w");
// wait (test_done);
// $fclose (f2);
//end


always @(posedge cpu_clk or negedge rst_n)
begin
    if (~rst_n)
    begin
       uart_write      <= 1'b0;
    end
    else 
    begin 
    uart_write <= (cpu_haddr == 32'h4000_0000) & cpu_htrans[1] & cpu_hready_in & cpu_hwrite;
    end                                 
end


//display the UART data
always @(posedge cpu_clk)
begin
 if (uart_write) 
 begin
    if (cpu_hwdata[7:0] == 8'h0a)
    begin
//        $fdisplay (f2, "%s", str_base);
        $display ("%s", str_base);
        str_base ="";
    end
    else      
        str_base = {str_base, string'(cpu_hwdata[7:0])};
    #10;
 end
end

//---------------------------------------------------------
//8'h7e from UART is the flag of that test program is ended.
//---------------------------------------------------------
always @(posedge cpu_clk)
begin
 if ((uart_write) && (cpu_hwdata[7:0] == 8'h7e))
 begin
    #2000;
    $display ("[AMY]:=================");
    $display ("[AMY]: Test is done! %d", $time);
    $display ("[AMY]:=================");
    #10;
    repeat (50) @(posedge cpu_clk);
    test_done  = 1;
 end
end


endmodule