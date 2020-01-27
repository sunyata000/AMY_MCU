//******************************************************************************
//
//******************************************************************************


`include "PODES_M0A_reg_define.h"
`include "AMY_reg_define.h"


module uart_monitor (normal_done);

output normal_done;

wire [31:0] cpu_haddr     = testbench.AMY_M0O_TOP_u0.AMY_M0O_u0.peri_shaddr;
wire [1:0]  cpu_htrans    = testbench.AMY_M0O_TOP_u0.AMY_M0O_u0.peri_shtrans;
wire        cpu_hready_in = testbench.AMY_M0O_TOP_u0.AMY_M0O_u0.peri_shready_in;
wire        cpu_hwrite    = testbench.AMY_M0O_TOP_u0.AMY_M0O_u0.peri_shwrite;
wire [31:0] cpu_hwdata    = testbench.AMY_M0O_TOP_u0.AMY_M0O_u0.peri_shwdata;
wire        cpu_clk       = testbench.AMY_M0O_TOP_u0.AMY_M0O_u0.clk;
wire        rst_n         = testbench.AMY_M0O_TOP_u0.AMY_M0O_u0.rst_n;


reg normal_done = 0;



//========================================================
//Monitor UART data by checking the internal data bus
//========================================================

reg uart_write;

string str_base = "";
integer f2;

//initial
//begin
// f2 = $fopen ("uart0_monitor.log", "w");
// wait (normal_done);
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
    begin	
        str_base = {str_base, string'(cpu_hwdata[7:0])};
 //       $display ("%s", str_base);
	end	
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
    normal_done  = 1;
 end
end


endmodule