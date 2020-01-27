
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
// File        : sram_model.v
// Author      : PODES
// Date        : 20200101
// Version     : 1.0
// Description : SRAM module.
//               
// -----------------------------History-----------------------------------//
// Date      BY   Version  Change Description
//
// 20200101  PODES   1.0      Initial Release. 
//                                                                        
//************************************************************************//
// --- CVS information:
// ---    $Author: $
// ---    $Revision: $
// ---    $Id: $
// ---    $Log$ 
//
//************************************************************************//



module	sram_model(
        clk,
	//SRAM interface
	    ramcs_n,
	    ramaddr,
	    ramdout,
	    ramdin,
	    ramben,
	    ramwr_n
        );


//-----------------------------------------------------------//
//                          PARAMETERS                       //
//-----------------------------------------------------------//
parameter MDW = 32;
parameter MAW = 32;
parameter MAM = 1024;	//just 1K words for sim.


//-----------------------------------------------------------//
//                      INPUTS/OUTPUTS                       //
//-----------------------------------------------------------//  
input                   clk;

output	[MDW-1:0]	    ramdout;
input			        ramcs_n;
input	[MAW-1:0]	    ramaddr;
input   [MDW-1:0]       ramdin;
input   [3:0]           ramben;
input                   ramwr_n;

wire ramwren = ~ramcs_n & ~ramwr_n;
ram32x1024 ram32x1024_u0 (
	                  .clk  (clk           ),
	                  .dout (ramdout       ),
	                  .addr (ramaddr[11:2] ),
 	                  .din  (ramdin        ),
	                  .ben  (ramben        ),
	                  .wren (ramwren       )
	                  );

endmodule
