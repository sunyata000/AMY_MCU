
//************************************************************************//
//PODES:    Processor Optimization for Deeply Embedded System                                                                 
//Web:      http://www.mcucore.org                        
//Bug report: podes.mcu@qq.com                                                                          
//Q_Q:        1740507106         
//************************************************************************//
//                                                                          
//  AMY_M0O - A demo MCU based on PODES_M0O Core                              
//  Copyright (C) 2013 PODES and www.mcucore.org                                      
//                                                                  
//************************************************************************//
// File        : rom_model.v
// Author      : PODES
// Date        : 20131111
// Version     : 1.0
// Description : SROM behavioural module.
//
// -----------------------------History-----------------------------------//
// Date      BY   Version  Change Description
//
// 20131111  PODES   1.0      Initial Release. 
//                                                                        
//************************************************************************//
// --- CVS information:
// ---    $Author: $
// ---    $Revision: $
// ---    $Id: $
// ---    $Log$ 
//
//************************************************************************//


module	rom_model(
        clk,
	//ROM interface
	romcs_n,
	romaddr,
	romdout
        );


//-----------------------------------------------------------//
//                          PARAMETERS                       //
//-----------------------------------------------------------//
parameter MDW = 32;
parameter MAW = 32;
parameter MAM = 2048;	//just 4K words for sim.


//-----------------------------------------------------------//
//                      INPUTS/OUTPUTS                       //
//-----------------------------------------------------------//  
input                   clk;

output	[MDW-1:0]	romdout;
input			romcs_n;
input	[MAW-1:0]	romaddr;


//-----------------------------------------------------------//
//                    REGISTERS & WIRES                      //
//-----------------------------------------------------------//
reg	[MDW-1:0]	romdout;

reg [31:0]              rom_memory[0 : MAM -1];


//-----------------------------------------------------------//
//                          ARCHITECTURE                     //
//-----------------------------------------------------------//
always @ (posedge clk )
begin
    if(!romcs_n)
        romdout <= rom_memory[romaddr[11:2]];
//    else
//        romdout <= {32{1'bx}}; // to avoid data is latched on wrong timing point.
end


endmodule
