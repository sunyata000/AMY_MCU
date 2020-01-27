
//************************************************************************//
//PODES:    Processor Optimization for Deeply Embedded System                                                                 
//Web:      http://www.mcucore.org                        
//Bug report: sunyata.peng@foxmail.com                                                                          
//Q_Q:   2143971503         
//************************************************************************//
//                                                                          
//  AMY_M0O - A demo MCU based on PODES_M0O Core                              
//                                      
//                                                                  
//************************************************************************//
// File        : srom_model.v
// Author      : PODES
// Date        : 20200101
// Version     : 1.0
// Description : SROM module.
//
// -----------------------------History-----------------------------------//
// Date      BY   Version  Change Description
//
// 20200101  PODES   1.0      Initial Release. 
//                            Use SRAM replace the SROM in FPGA, so that program code
//                             can be downloaded repeatedly for debugging. 
//                                                                        
//************************************************************************//
// --- CVS information:
// ---    $Author: $
// ---    $Revision: $
// ---    $Id: $
// ---    $Log$ 
//
//************************************************************************//


module	srom_model(
        clk,
		boot_ctrl,
	//SRAM interface
	    romcs_n,
	    romaddr,
	    romdout,
	    romdin,
	    romben,
	    romwr_n
        );


//-----------------------------------------------------------//
//                          PARAMETERS                       //
//-----------------------------------------------------------//
parameter MDW = 32;
parameter MAW = 32;
parameter MAM = 4096;	// 4K words for sim.


//-----------------------------------------------------------//
//                      INPUTS/OUTPUTS                       //
//-----------------------------------------------------------//  
input                   clk;   
input                   boot_ctrl;  

output	[MDW-1:0]	    romdout;
input			        romcs_n;
input	[MAW-1:0]	    romaddr;
input   [MDW-1:0]       romdin;
input   [3:0]           romben;
input                   romwr_n;

wire    [31:0]          boot_romdout;
wire    [31:0]          code_romdout;


assign romdout = boot_ctrl ? boot_romdout : code_romdout;

wire wren = ~romcs_n & ~romwr_n;

ram32x4096 ram32x4096_u0 (
	                  .clk  (clk           ),
	                  .dout (code_romdout  ),
	                  .addr (romaddr[13:2] ),
 	                  .din  (romdin        ),
	                  .ben  (romben        ),
	                  .wren (wren          )
	                  );
					  
					  
ram32x256 ram32x256_u0 (
	                  .clk  (clk           ),
	                  .dout (boot_romdout  ),
	                  .addr (romaddr[9:2]  ),
 	                  .din  (32'b0         ),
	                  .ben  (romben        ),
	                  .wren (1'b0          )
	                  );
					  
endmodule
