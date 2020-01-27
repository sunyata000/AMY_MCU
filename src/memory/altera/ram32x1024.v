
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
// File        : ram32x1024.v
// Author      : PODES
// Date        : 20131111
// Version     : 1.0
// Description : SRAM wrapper for various foundry libs.
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



module  ram32x1024(
        clk,
    //SRAM interface
        addr,
        dout,
        din,
        ben,
        wren
        );

//-----------------------------------------------------------//
//                          PARAMETERS                       //
//-----------------------------------------------------------//


//-----------------------------------------------------------//
//                      INPUTS/OUTPUTS                       //
//-----------------------------------------------------------//  
input               clk;

output  [31:0]      dout;
input   [9 :0]      addr;
input   [31:0]      din;
input   [3 :0]      ben;
input               wren;


`ifndef ALTERA
`define ALTERA
`endif


//Altera model
`ifdef ALTERA
ram32x1024_altera ram32x1024_altera_u0 (
                      .address ( addr      ),
                      .byteena ( ben       ),
                      .clock   ( clk       ),
                      .data    ( din       ),
                      .wren    ( wren      ),
                      .q       ( dout      )
                      );

					  
//Xilinx model                      
`elsif  XILINX
wire [3:0] wea = wren ? ben : 4'b0;
ram32x1024_xilinx ram32x1024_xilinx_u0 (
                      .clka    ( clk       ),
                      .ena     ( 1'b1      ),
                      .wea     ( wea       ),
                      .addra   ( addr      ),
                      .dina    ( din       ),
                      .douta   ( dout      )
                      );

//behavioural model					  
`else

reg [31:0]     dout;

reg [7:0]      ram_memory0[0 : 1023];
reg [7:0]      ram_memory1[0 : 1023];
reg [7:0]      ram_memory2[0 : 1023];
reg [7:0]      ram_memory3[0 : 1023];


//ram read
always @ (posedge clk )
begin
    if(!wren)
      case (ben)
      4'b0000 : dout <= {32{1'bx}};
      4'b0001 : dout <= {{24{1'bx}}, ram_memory0[addr]};
      4'b0010 : dout <= {{16{1'bx}}, ram_memory1[addr],{8{1'bx}}};
      4'b0100 : dout <= {{8{1'bx}}, ram_memory2[addr],{16{1'bx}}};
      4'b1000 : dout <= {ram_memory3[addr],{24{1'bx}}};
      4'b0011 : dout <= {{16{1'bx}}, ram_memory1[addr], ram_memory0[addr]};
      4'b1100 : dout <= {ram_memory3[addr], ram_memory2[addr],{16{1'bx}}};
      4'b1111 : dout <= {ram_memory3[addr], ram_memory2[addr],
                         ram_memory1[addr], ram_memory0[addr]}; 
      default : dout <= {32{1'bx}};
      endcase
end

//ram write
always @ (posedge clk )
begin
    if(wren)
      case (ben)
      4'b0001 :  ram_memory0[addr] <= din[7:0];
      4'b0010 :  ram_memory1[addr] <= din[15:8];
      4'b0100 :  ram_memory2[addr] <= din[23:16];
      4'b1000 :  ram_memory3[addr] <= din[31:24];
      4'b0011 : {ram_memory1[addr], ram_memory0[addr]} <= din[15:0];
      4'b1100 : {ram_memory3[addr], ram_memory2[addr]} <= din[31:24];
      4'b1111 : {ram_memory3[addr], ram_memory2[addr], 
                 ram_memory1[addr], ram_memory0[addr]} <= din;
      default : ;
      endcase
end
`endif

endmodule
