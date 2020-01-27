
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
// File        : ahb2apb.v
// Author      : PODES
// Date        : 20200101
// Version     : 1.0
// Description : AHB to APB bus bridge module.
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

module  ahb2apb
(
        //Ahb clock & reset
          clk,
          rst_n,
        
        //Ahb slave interface
          shready_in,
          shsel,
          shaddr,
          shtrans,
          shwrite,
          shwdata,
          shsize,
          shburst,
          shprot,         
          shrdata,
          shready_out,
          shresp,
          
          apb0_psel    ,
          apb0_penable ,
          apb0_paddr   ,
          apb0_pwrite  ,
          apb0_pwdata  ,
          apb0_prdata  ,
     
          apb1_psel    ,    
          apb1_penable ,    
          apb1_paddr   ,    
          apb1_pwrite  ,
          apb1_pwdata  ,
          apb1_prdata  ,
          
          apb2_psel    ,    
          apb2_penable ,    
          apb2_paddr   ,    
          apb2_pwrite  ,
          apb2_pwdata  ,
          apb2_prdata  ,
          
          apb3_psel    ,    
          apb3_penable ,    
          apb3_paddr   ,    
          apb3_pwrite  ,
          apb3_pwdata  ,
          apb3_prdata  ,
          
          apb4_psel    ,
          apb4_penable ,
          apb4_paddr   ,
          apb4_pwrite  ,
          apb4_pwdata  ,
          apb4_prdata  ,
     
          apb5_psel    ,    
          apb5_penable ,    
          apb5_paddr   ,    
          apb5_pwrite  ,
          apb5_pwdata  ,
          apb5_prdata  ,
          
          apb6_psel    ,    
          apb6_penable ,    
          apb6_paddr   ,    
          apb6_pwrite  ,
          apb6_pwdata  ,
          apb6_prdata  ,
          
          apb7_psel    ,    
          apb7_penable ,    
          apb7_paddr   ,    
          apb7_pwrite  ,
          apb7_pwdata  ,
          apb7_prdata  
       );

//-----------------------------------------------------------//
//                          PARAMETERS                       //
//-----------------------------------------------------------//
// 
parameter IDLE_ENABLE       = 3'b001;
parameter SETUP             = 3'b000;
parameter PR_SETUP          = 3'b100;
parameter B2B_SETUP         = 3'b101;
parameter W2W_SETUP         = 3'b110; 
parameter W2W_ENABLE        = 3'b100;
parameter B2B_ENABLE        = 3'b111;
     
//-----------------------------------------------------------//
//                      INPUTS/OUTPUTS                       //
//-----------------------------------------------------------//  
input          clk;
input          rst_n;

input           shready_in;
input           shsel;
input  [31:0]   shaddr;
input  [1:0]    shtrans;
input           shwrite;
input  [31:0]   shwdata;
input  [2:0]    shsize;  
input  [2:0]    shburst;   
input  [3:0]    shprot;  
output [31:0]   shrdata;           
output          shready_out;
output          shresp;

output          apb0_psel     ;
output          apb0_penable  ;
output  [31:0]  apb0_paddr    ;
output          apb0_pwrite   ;
output  [31:0]  apb0_pwdata   ;
input   [31:0]  apb0_prdata   ;
               
output          apb1_psel       ;    
output          apb1_penable    ;    
output  [31:0]  apb1_paddr      ;    
output          apb1_pwrite     ;
output  [31:0]  apb1_pwdata     ;
input   [31:0]  apb1_prdata     ;

output          apb2_psel     ;
output          apb2_penable  ;
output  [31:0]  apb2_paddr    ;
output          apb2_pwrite   ;
output  [31:0]  apb2_pwdata   ;
input   [31:0]  apb2_prdata   ;
               
output          apb3_psel       ;    
output          apb3_penable    ;    
output  [31:0]  apb3_paddr      ;    
output          apb3_pwrite     ;
output  [31:0]  apb3_pwdata     ;
input   [31:0]  apb3_prdata     ;

output          apb4_psel     ;
output          apb4_penable  ;
output  [31:0]  apb4_paddr    ;
output          apb4_pwrite   ;
output  [31:0]  apb4_pwdata   ;
input   [31:0]  apb4_prdata   ;
               
output          apb5_psel       ;    
output          apb5_penable    ;    
output  [31:0]  apb5_paddr      ;    
output          apb5_pwrite     ;
output  [31:0]  apb5_pwdata     ;
input   [31:0]  apb5_prdata     ;

output          apb6_psel     ;
output          apb6_penable  ;
output  [31:0]  apb6_paddr    ;
output          apb6_pwrite   ;
output  [31:0]  apb6_pwdata   ;
input   [31:0]  apb6_prdata   ;
               
output          apb7_psel       ;    
output          apb7_penable    ;    
output  [31:0]  apb7_paddr      ;    
output          apb7_pwrite     ;
output  [31:0]  apb7_pwdata     ;
input   [31:0]  apb7_prdata     ;


//-----------------------------------------------------------//
//                    REGISTERS & WIRES                      //
//-----------------------------------------------------------//

reg [31:0]   shrdata;  

reg  [2:0]    current_state;
reg           shready_out;
reg           penable;
reg  [31:0]   paddr;
reg           pwrite;
reg           psel;
reg  [31:0]   shaddr_buf1;
reg           shwrite_buf1;
reg  [31:0]   pwdata; 

reg  [2:0]    next_state;
reg           nxt_shready_out;
reg           nxt_penable;
reg  [31:0]   nxt_paddr;
reg           nxt_pwrite;
reg           nxt_psel;
reg  [31:0]   nxt_shaddr_buf1;
reg           nxt_shwrite_buf1;
reg  [31:0]   nxt_pwdata; 


//-----------------------------------------------------------//
//                          ARCHITECTURE                     //
//-----------------------------------------------------------//  
//access type: single read and write; burst read and write; back2back write/read
//data type: only 32bit access is valid. lowest 2bits of address are ignored. shsize is ignored.
//Address range:
//APB0: 0x4000_0000 ~ 0x4000_00ff;
//APB1: 0x4000_0100 ~ 0x4000_01ff;
//APB2: 0x4000_0200 ~ 0x4000_02ff;
//APB3: 0x4000_0300 ~ 0x4000_03ff;
//APB4: 0x4000_0400 ~ 0x4000_04ff;
//APB5: 0x4000_0500 ~ 0x4000_05ff;
//APB6: 0x4000_0600 ~ 0x4000_06ff;
//APB7: 0x4000_0700 ~ 0x4000_07ff;
//Others, reserved. To be added.


wire apb_access_hit = shsel & shaddr[31:18] == 14'b0100_0000_0000_00;
wire read_access  = apb_access_hit & shready_in & shtrans[1] & (~shwrite);
wire write_access = apb_access_hit & shready_in & shtrans[1] & shwrite;

//back2back + WR2WR + RD2RD
always @ (*)
begin    
    next_state = current_state;
    nxt_shready_out = 1'b1;
    nxt_penable = 1'b0;
    nxt_paddr = paddr;
    nxt_pwrite = pwrite;
    nxt_psel = 1'b0;
    
    nxt_shaddr_buf1 = shaddr_buf1;
    nxt_shwrite_buf1 = shwrite_buf1;
    nxt_pwdata = pwdata; 
    
   
    case (current_state)
    IDLE_ENABLE: //Idle or Read Enable state.
        begin
          if(read_access ) 
          begin
            next_state = SETUP;
            nxt_shready_out = 1'b0;
            nxt_penable = 1'b0;
            nxt_paddr = shaddr;
            nxt_pwrite = shwrite;
            nxt_psel = 1'b1;
          end
          else if (write_access)
          begin
            next_state = PR_SETUP; 
            nxt_shready_out = 1'b1;
            nxt_penable = 1'b0;
            nxt_shaddr_buf1 = shaddr;
            nxt_shwrite_buf1 = shwrite;
            nxt_psel = 1'b0;
          end
        end
    PR_SETUP,//Wait for data
    W2W_ENABLE: //APB write phase.
        begin
          nxt_shready_out = 1'b0;
          nxt_penable = 1'b0;   
          nxt_paddr = shaddr_buf1;
          nxt_pwrite = shwrite_buf1;
          nxt_pwdata = shwdata;  
          nxt_psel = 1'b1;
          if (write_access || read_access)
          begin
            nxt_shaddr_buf1 = shaddr;
            nxt_shwrite_buf1 = shwrite;
          end 
          next_state = write_access ? W2W_SETUP : (read_access ? B2B_SETUP : SETUP);  
        end
    B2B_SETUP:
        begin
          next_state = B2B_ENABLE;
          nxt_shready_out = 1'b0;
          nxt_penable = 1'b1;    
          nxt_psel = 1'b1;      
        end
    W2W_SETUP:
        begin
          next_state = W2W_ENABLE;
          nxt_shready_out = 1'b1;
          nxt_penable = 1'b1; 
          nxt_psel = 1'b1;         
        end
    SETUP:
        begin
          next_state = IDLE_ENABLE;
          nxt_shready_out =  1'b1;
          nxt_penable = 1'b1;       
          nxt_psel = 1'b1;   
        end
    B2B_ENABLE:
        begin
          nxt_shready_out = 1'b0;
          nxt_penable = 1'b0;   
          nxt_paddr = shaddr_buf1;
          nxt_pwrite = shwrite_buf1;  
          nxt_psel = 1'b1;        
          next_state = SETUP;    
        end
    default:
        begin
          next_state = IDLE_ENABLE;  
          nxt_shready_out = 1'b1;
          nxt_penable = 1'b0; 
          nxt_psel = 1'b0;             
        end
    endcase  

end



always @(posedge clk or negedge rst_n)
begin
    if (~rst_n)
    begin
      current_state <= IDLE_ENABLE;
      shready_out    <= 1'b1;
      penable       <= 1'b0;
      paddr         <= 32'h0;
      pwrite        <= 1'b0;
      psel          <= 1'b0;
      
      shaddr_buf1   <= 32'h0;
      shwrite_buf1  <= 1'b0;
      pwdata        <= 32'h0; 
    end
    else 
    begin 
      current_state <= next_state;
      shready_out   <= nxt_shready_out; 
      penable       <= nxt_penable;
      paddr         <= nxt_paddr;
      pwrite        <= nxt_pwrite;
      psel          <= nxt_psel;
                                        
      shaddr_buf1   <= nxt_shaddr_buf1;
      shwrite_buf1  <= nxt_shwrite_buf1; 
      pwdata        <= nxt_pwdata;
    end                                 
end

  
assign apb0_psel = psel & ((paddr[31:8] == 24'h4000_00) ? 1'b1 : 1'b0);
assign apb0_paddr = paddr;
assign apb0_penable = penable;
assign apb0_pwrite = pwrite;
assign apb0_pwdata = pwdata;  
  
assign apb1_psel = psel & ((paddr[31:8] == 24'h4000_01) ? 1'b1 : 1'b0);
assign apb1_paddr = paddr;
assign apb1_penable = penable;
assign apb1_pwrite = pwrite;
assign apb1_pwdata = pwdata; 
 
assign apb2_psel = psel & ((paddr[31:8] == 24'h4000_02) ? 1'b1 : 1'b0);
assign apb2_paddr = paddr;
assign apb2_penable = penable;
assign apb2_pwrite = pwrite;
assign apb2_pwdata = pwdata; 
 
assign apb3_psel = psel & ((paddr[31:8] == 24'h4000_03) ? 1'b1 : 1'b0);
assign apb3_paddr = paddr;
assign apb3_penable = penable;
assign apb3_pwrite = pwrite;
assign apb3_pwdata = pwdata;  

assign apb4_psel = psel & ((paddr[31:8] == 24'h4000_04) ? 1'b1 : 1'b0);
assign apb4_paddr = paddr;
assign apb4_penable = penable;
assign apb4_pwrite = pwrite;
assign apb4_pwdata = pwdata;  
  
assign apb5_psel = psel & ((paddr[31:8] == 24'h4000_05) ? 1'b1 : 1'b0);
assign apb5_paddr = paddr;
assign apb5_penable = penable;
assign apb5_pwrite = pwrite;
assign apb5_pwdata = pwdata; 
 
assign apb6_psel = psel & ((paddr[31:8] == 24'h4000_06) ? 1'b1 : 1'b0);
assign apb6_paddr = paddr;
assign apb6_penable = penable;
assign apb6_pwrite = pwrite;
assign apb6_pwdata = pwdata; 
 
assign apb7_psel = psel & ((paddr[31:8] == 24'h4000_07) ? 1'b1 : 1'b0);
assign apb7_paddr = paddr;
assign apb7_penable = penable;
assign apb7_pwrite = pwrite;
assign apb7_pwdata = pwdata;  


always @(*)
begin
  case ({apb7_psel,apb6_psel,apb5_psel,apb4_psel,apb3_psel,apb2_psel,apb1_psel,apb0_psel})
    8'b0000_0001: shrdata <= apb0_prdata;
    8'b0000_0010: shrdata <= apb1_prdata;
    8'b0000_0100: shrdata <= apb2_prdata;
    8'b0000_1000: shrdata <= apb3_prdata;
    8'b0001_0000: shrdata <= apb4_prdata;
    8'b0010_0000: shrdata <= apb5_prdata;
    8'b0100_0000: shrdata <= apb6_prdata;
    8'b1000_0000: shrdata <= apb7_prdata;
    default: shrdata <= 32'b0;
  endcase
end  

assign shresp = 1'b0;


endmodule
