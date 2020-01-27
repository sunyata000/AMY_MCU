
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
// File        : clk_gen.v
// Author      : PODES
// Date        : 20200101
// Version     : 1.0
// Description : CLOCK generator.
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


module	clk_gen(
               clk_in,          
               rst_n,
               clk,
               clk_20k    
        );


//-----------------------------------------------------------//
//                          PARAMETERS                       //
//-----------------------------------------------------------//



//-----------------------------------------------------------//
//                      INPUTS/OUTPUTS                       //
//-----------------------------------------------------------//  
input                   clk_in;
input                   rst_n;

output                  clk;
output                  clk_20k;



//-----------------------------------------------------------//
//                    REGISTERS & WIRES                      //
//-----------------------------------------------------------//
reg [9:0] div_cnt;


//-----------------------------------------------------------//
//                          ARCHITECTURE                     //
//-----------------------------------------------------------//

assign clk = clk_in;  //20Mhz

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        div_cnt <= 10'b0;
    end
    else
    begin
        div_cnt <= div_cnt + 1;
    end
end

assign clk_20k = div_cnt[9];

endmodule
