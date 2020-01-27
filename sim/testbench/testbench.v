//******************************************************************************
//
//
//******************************************************************************

`timescale 1ps/1ps

//`ifndef AHB_EMU
//`define AHB_EMU
//`endif



module	testbench(
        );



//-----------------------------------------------------------//
//                          PARAMETERS                       //
//-----------------------------------------------------------//
parameter CLK_PERIOD = 20ns;


//-----------------------------------------------------------//
//                      INPUTS/OUTPUTS                       //
//-----------------------------------------------------------//  


//-----------------------------------------------------------//
//                    REGISTERS & WIRES                      //
//-----------------------------------------------------------//





//-----------------------------------------------------------//
//                          ARCHITECTURE                     //
//-----------------------------------------------------------//

`define TB_TOP     testbench

`define ALTERA

`ifdef ALTERA
`define ROM32x4096 AMY_M0O_TOP_u0.AMY_M0O_u0.srom_model_u0.ram32x4096_u0.ram32x4096_altera_u0.altsyncram_component.mem_data
`define ROM32x256 AMY_M0O_TOP_u0.AMY_M0O_u0.srom_model_u0.ram32x256_u0.ram32x256_altera_u0.altsyncram_component.mem_data
//`elsif XILINX
//
//;
//
//`elsif BEHAV
//
//;
//
`endif





//---------------------------
//reset and clock
//---------------------------
reg  clk = 1'b0;
reg  rst_n;

initial
begin
    forever #(CLK_PERIOD/2) clk <= ~clk;
end

initial
begin
//    #10;
    rst_n = 0;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    #1;
    rst_n = 1;
end

wire CLKIN = clk;
wire RSTN = rst_n;

//---------------------------
//BOOT control
//---------------------------
reg boot_reg = 1'b1;  //0: boot space; 1: normal rom space.

wire BOOT = boot_reg;

//---------------------------
//UART interface
//---------------------------
wire xuart0_txd;
reg xuart0_rxd_reg = 1'b1;
wire xuart1_txd;
reg xuart1_rxd_reg = 1'b1;


wire RXD0 = xuart0_rxd_reg;
wire RXD1 = xuart1_rxd_reg;


//---------------------------
//IIC interface
//---------------------------
//TBD for i2c model
tri1 SCL;
tri1 SDA;


//---------------------------
//KEYPAD interface
//---------------------------
//TBD for keypad model
reg [4:0] col_reg = 5'b0;

wire COL0 = col_reg[0]; 
wire COL1 = col_reg[1]; 
wire COL2 = col_reg[2]; 
wire COL3 = col_reg[3]; 
wire COL4 = col_reg[4]; 


reg       irin_reg = 1'b0;
wire IRIN = irin_reg;

//---------------------------
//GPIO interface
//---------------------------
//TBD for GPIO model
tri1 GPIO0;
tri1 GPIO1;
tri1 GPIO2;
tri1 GPIO3;
tri1 GPIO4;
tri1 GPIO5;
tri1 GPIO6;
tri1 GPIO7;


//---------------------------
//AHB EMU signals
//---------------------------
reg          emu_shready_in = 1'b1;
reg          emu_shsel     = 1'b1 ;
reg [31:0]   emu_shaddr   = 32'h0 ;
reg [1:0]    emu_shtrans  = 3'b0  ;
reg          emu_shwrite  =1'b0   ;
reg [31:0]   emu_shwdata  = 32'h0 ;
reg [2:0]    emu_shsize   = 3'b0  ;  
reg [2:0]    emu_shburst = 3'h0 ;   
reg [3:0]    emu_shprot  = 4'h0 ;  
wire [31:0]   emu_shrdata    ;           
wire          emu_shready_out;
wire          emu_shresp     ;

//---------------------------
//instantiation for top module.
//---------------------------
AMY_M0O_TOP AMY_M0O_TOP_u0( 
         .CLKIN (CLKIN ),
         .RSTN  (RSTN  ),
         .BOOT  (BOOT  ),
                 
         .RXD0  (RXD0  ),
         .TXD0  (TXD0  ),
          
//         .RXD1  (RXD1  ),
//         .TXD1  (TXD1  )
        
//         .SCL   (SCL   ),
//         .SDA   (SDA   ),  
         
//         .ROW0  (ROW0  ),
//         .ROW1  (ROW1  ),
//         .ROW2  (ROW2  ),
//         .ROW3  (ROW3  ),
//         .ROW4  (ROW4  ),
//         .COL0  (COL0  ),
//         .COL1  (COL1  ),
//         .COL2  (COL2  ),
//         .COL3  (COL3  ),
//         .COL4  (COL4  ),
//         .IRIN  (IRIN  ),
//        
         .GPIO0 (GPIO0 ),
         .GPIO1 (GPIO1 ),
         .GPIO2 (GPIO2 ),
         .GPIO3 (GPIO3 ),
         .GPIO4 (GPIO4 ),
         .GPIO5 (GPIO5 ),
         .GPIO6 (GPIO6 ),
         .GPIO7 (GPIO7 )     
        );

		
//----------------------------------------
//Load Program code to ROM
//----------------------------------------
initial 
begin
    @(posedge clk);
    @(posedge clk);
	$readmemh ("boot_test.txt", `ROM32x256);
	$readmemh ("program.txt", `ROM32x4096);
end		


//----------------------------------------
//TASKS used by RTL simulation.
//----------------------------------------
`include "tasks.v"


//--------------------------------------
//test cases for module RTL simulation.
//--------------------------------------
wire sim_done;
testcase testcase_u0 (sim_done);



//--------------------------------------
//Monitor UART message for SW simulation.
//--------------------------------------
wire sw_done;
uart_monitor uart_monitor_u0 (sw_done);



//---------------------------
//dump waveform file
//---------------------------
initial
begin
    $wlfdumpvars ();
 //   $wlfdumpvars(0, testbench.AMY_u0);
end



wire        cpu_clk = testbench.AMY_M0O_TOP_u0.AMY_M0O_u0.clk;


//---------------------------------------------------------
//simulation time is expired.
//---------------------------------------------------------
integer sim_time_limitation = (20*50*1000*100); //100ms
reg abnormal_exit = 0;
initial
 begin
    abnormal_exit = 0;
	repeat (sim_time_limitation/20) @(posedge clk); 
    #20ns;
    $display ("[AMY]:========simulation time is expired.=========");
    repeat (10) @(posedge clk);
    abnormal_exit = 1;
 end


//---------------------------------------------------------
//Finish the simulation
//---------------------------------------------------------
 wire test_done = sim_done |sw_done | abnormal_exit;
initial
begin
    repeat (20) @(posedge cpu_clk);    
    $display ("[AMY] Start the simulation", $time); 
    wait (test_done);
    repeat (20) @(posedge cpu_clk);
    $finish(0);
      
end

 
//---------------------------------------------------------
//Tracking the IE PC
//--------------------------------------------------------- 
pc_tracking pc_tracking_u0 (test_done);


endmodule