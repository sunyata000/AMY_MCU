
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
// File        : ahb_sram_ctrl.v
// Author      : PODES
// Date        : 20200101
// Version     : 1.0
// Description : AHB I/F SRAM controller.
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

module  ahb_sram_ctrl
(
        //Ahb clock & reset
          clk,
          rst_n,
        
        //Ahb slave interface
          ram_shready_in,
          ram_shsel,
          ram_shaddr,
          ram_shtrans,
          ram_shwrite,
          ram_shwdata,
          ram_shsize,
          ram_shburst,
          ram_shprot,         
          ram_shrdata,
          ram_shready_out,
          ram_shresp,
        
        //Inner sram interface
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
// AHB slave state machine state
parameter IDLE            = 2'b00;
parameter WRITE           = 2'b01;
parameter WRITE_THEN_READ = 2'b10;

//-----------------------------------------------------------//
//                      INPUTS/OUTPUTS                       //
//-----------------------------------------------------------//  
input          clk;
input          rst_n;

input           ram_shready_in;
input           ram_shsel;
input  [31:0]   ram_shaddr;
input  [1:0]    ram_shtrans;
input           ram_shwrite;
input  [31:0]   ram_shwdata;
input  [2:0]    ram_shsize;  
input  [2:0]    ram_shburst;   
input  [3:0]    ram_shprot;  
output [31:0]   ram_shrdata;           
output          ram_shready_out;
output          ram_shresp;

output          ramcs_n;
output  [31:0]  ramaddr;
input   [31:0]  ramdout;
output  [31:0]  ramdin;
output  [3:0]   ramben;
output          ramwr_n;


//-----------------------------------------------------------//
//                    REGISTERS & WIRES                      //
//-----------------------------------------------------------//
               
reg [31:0]   ram_shrdata;           
reg          ram_shready_out;
wire          ram_shresp;

reg           ramcs_n;
reg  [31:0]   ramaddr;
reg  [31:0]   ramdin;
reg  [3:0]    ramben;
reg           ramwr_n;

reg  [1:0]    current_state;
reg  [1:0]    next_state;


//-----------------------------------------------------------//
//                          ARCHITECTURE                     //
//-----------------------------------------------------------//  
//This design is only valid for 0 waitstate ram/rom.
//if there exists one or more waitstates, it will be wrong.
//wire ram_range = (ram_shaddr[31:29] == 3'b001) ? 1'b1 : 1'b0;

wire ram_ahb_idle = (~ram_shsel) | (~ram_shtrans[1]); 
wire ram_ahb_wr  = ram_shsel & ram_shtrans[1] & ram_shwrite ;//& ram_range;
wire ram_ahb_rd  = ram_shsel & ram_shtrans[1] & ~ram_shwrite;// & ram_range;


//byte enable for little endian
reg [3:0]  byte_en;
always @ *
begin
    case ({ram_shaddr[1:0],ram_shsize})
    5'b00000: byte_en = 4'b0001;
    5'b00001: byte_en = 4'b0011;
    5'b00010: byte_en = 4'b1111;
    5'b01000: byte_en = 4'b0010;
    5'b10000: byte_en = 4'b0100;
    5'b10001: byte_en = 4'b1100;
    5'b11000: byte_en = 4'b1000;
    default : byte_en = 4'b0000; //if error, none byte will be used.
    endcase
end

reg [3:0]       byte_en_reg ;
reg [31:0]      ram_shaddr_reg;
always @(posedge clk or negedge rst_n)
begin
    if (~rst_n)
    begin
       byte_en_reg     <= 4'b0;
       ram_shaddr_reg  <= 32'b0;
    end
    else if (ram_shready_in && (ram_ahb_wr | ram_ahb_rd) )
    begin 
       byte_en_reg     <= byte_en;
       ram_shaddr_reg  <= ram_shaddr;
    end                                 
end


//state transition between read and write access.
reg nxt_ram_shready_out;
always @ (*)
begin
    nxt_ram_shready_out = 1'b1;
    ramcs_n = 1'b1;
    ramwr_n = 1'b1;
    ramben  = byte_en_reg;
    ramaddr = ram_shaddr_reg;
    ramdin  = ram_shwdata;
    next_state = current_state;
    
    case (current_state)
    IDLE:
        begin
          if(ram_shready_in && ram_ahb_wr ) //write at next state
          begin
            next_state = WRITE;
          end
          else if(ram_shready_in && ram_ahb_rd ) //normal read
          begin
            ramcs_n = 1'b0;
            ramaddr = ram_shaddr; 
            ramben  = byte_en;           
          end        
        end
    WRITE:
        begin
          ramcs_n = 1'b0;
          ramwr_n = 1'b0;
          if(ram_shready_in && ram_ahb_idle )  //no access
          begin
            next_state = IDLE;
          end
          else if(ram_shready_in && ram_ahb_rd ) //insert a waitstate for read
          begin
            nxt_ram_shready_out = 1'b0;
            next_state = WRITE_THEN_READ;  
          end  
        end
    WRITE_THEN_READ:
        begin
          ramcs_n = 1'b0; //delayed read operation.
          next_state = IDLE;        
        end
    default:
        begin
          next_state = IDLE;                
        end
    endcase  

end

always @(posedge clk or negedge rst_n)
begin
    if (~rst_n)
    begin
       current_state <= IDLE;
       ram_shready_out <= 1'b1;
    end
    else 
    begin 
       current_state <= next_state;
       ram_shready_out <= nxt_ram_shready_out;
    end                                 
end

assign ram_shresp = 1'b0;


//==========================//
// AHB Slave I/F
//==========================//

  //read data byte mapping for little endian
  always @ *
  begin
      case (byte_en_reg)
      4'b1000: ram_shrdata = {4{ramdout[31:24]}};
      4'b1100: ram_shrdata = {2{ramdout[31:16]}};
      4'b1111: ram_shrdata = ramdout;
      4'b0100: ram_shrdata = {4{ramdout[23:16]}};
      4'b0010: ram_shrdata = {4{ramdout[15:8]}};
      4'b0011: ram_shrdata = {2{ramdout[15:0]}};
      4'b0001: ram_shrdata = {4{ramdout[7:0]}};
      default: ram_shrdata = ramdout;
      endcase
  end

  
endmodule
