
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
// File        : ahb_srom_ctrl.v
// Author      : PODES
// Date        : 20200101
// Version     : 1.0
// Description : AHB I/F SROM controller.
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

module  ahb_srom_ctrl
(
        //Ahb clock & reset
          clk,
          rst_n,
        
        //Ahb slave interface
          rom_shready_in,
          rom_shsel,
          rom_shaddr,
          rom_shtrans,
          rom_shwrite,
          rom_shwdata,
          rom_shsize,
          rom_shburst,
          rom_shprot,         
          rom_shrdata,
          rom_shready_out,
          rom_shresp,
        
        //Inner srom interface
          romcs_n,
          romaddr,
          romdout
          
       );

//-----------------------------------------------------------//
//                          PARAMETERS                       //
//-----------------------------------------------------------//


//-----------------------------------------------------------//
//                      INPUTS/OUTPUTS                       //
//-----------------------------------------------------------//  
input          clk;
input          rst_n;

input           rom_shready_in;
input           rom_shsel;
input  [31:0]   rom_shaddr;
input  [1:0]    rom_shtrans;
input           rom_shwrite;
input  [31:0]   rom_shwdata;
input  [2:0]    rom_shsize;  
input  [2:0]    rom_shburst;   
input  [3:0]    rom_shprot;  
output [31:0]   rom_shrdata;           
output          rom_shready_out;
output          rom_shresp;

output          romcs_n;
output  [31:0]  romaddr;
input   [31:0]  romdout;


//-----------------------------------------------------------//
//                    REGISTERS & WIRES                      //
//-----------------------------------------------------------//
               
reg [31:0]   rom_shrdata;           
wire         rom_shready_out;
wire         rom_shresp;

wire           romcs_n;
wire  [31:0]   romaddr;



//-----------------------------------------------------------//
//                          ARCHITECTURE                     //
//-----------------------------------------------------------//
//This design only valid for 0 waitstate synchronous ROM. 
//wire rom_range = (rom_shaddr[31:29] == 3'b000) ? 1'b1 : 1'b0;

wire rom_ahb_rd  = rom_shready_in & rom_shsel & rom_shtrans[1] & ~rom_shwrite ;//& rom_range;

assign romcs_n = ~ rom_ahb_rd;
assign romaddr = rom_shaddr;

assign rom_shready_out = 1'b1;
assign rom_shresp = 1'b0;

reg [1:0] romaddr_1_0_reg;
reg [2:0] rom_shsize_reg;
always @(posedge clk or negedge rst_n)
begin
    if (~rst_n)
    begin
       romaddr_1_0_reg <= 2'h0;
       rom_shsize_reg  <= 3'h0;
    end
    else if (rom_ahb_rd)
    begin 
       romaddr_1_0_reg <= romaddr[1:0];
       rom_shsize_reg  <= rom_shsize;
    end                                 
end


//byte enable for little endian
always @ *
begin
    case ({romaddr_1_0_reg,rom_shsize_reg})
    5'b00000: rom_shrdata = {4{romdout[7:0]}};
    5'b00001: rom_shrdata = {2{romdout[15:0]}};
    5'b00010: rom_shrdata = romdout;
    5'b01000: rom_shrdata = {4{romdout[15:8]}};
    5'b10000: rom_shrdata = {4{romdout[23:16]}};
    5'b10001: rom_shrdata = {2{romdout[31:16]}};
    5'b11000: rom_shrdata = {4{romdout[31:24]}};
    default : rom_shrdata = romdout; //all other cases are unexpected.
    endcase
end

  
endmodule
