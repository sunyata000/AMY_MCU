
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
// File        : AMY_M0O_TOP.v
// Author      : PODES
// Date        : 20200101
// Version     : 1.0
// Description : AMY_M0O IO top module.
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

module AMY_M0O_TOP(  
  
         CLKIN,
         RSTN,
		 BOOT,
//UART0 interface                  
         RXD0,
         TXD0,
//UART1 interface         
//         RXD1,
//         TXD1
//IIC interface
//         SCL,
//         SDA,  
//KEYPAD interface  
//         ROW0,
//         ROW1,
//         ROW2,
//         ROW3,
//         ROW4,
//         COL0,
//         COL1,
//         COL2,
//         COL3,
//         COL4,
//         IRIN,
//GPIO interface
         GPIO0,
         GPIO1,
         GPIO2,
         GPIO3,
         GPIO4,
         GPIO5,
         GPIO6,
         GPIO7        
        );

//-----------------------------------------------------------//
//                      INPUTS/OUTPUTS                       //
//-----------------------------------------------------------//

input         CLKIN;
input         RSTN ;
input         BOOT ;
//UART0 interface                  
input         RXD0;
output        TXD0;
//UART1 interface         
//input         RXD1;
//output        TXD1;
//IIC interface
//inout         SCL;
//inout         SDA;  
//KEYPAD interface  
//output        ROW0;
//output        ROW1;
//output        ROW2;
//output        ROW3;
//output        ROW4;
//input         COL0;
//input         COL1;
//input         COL2;
//input         COL3;
//input         COL4;
//input         IRIN;
//GPIO interface
inout         GPIO0;
inout         GPIO1;
inout         GPIO2;
inout         GPIO3;
inout         GPIO4;
inout         GPIO5;
inout         GPIO6;
inout         GPIO7;       
         

//-----------------------------------------------------------//
//                    REGISTERS & WIRES                      //
//-----------------------------------------------------------//   

wire        clk_in;
wire        rst_n;
wire        boot_en;

wire       uart0_rxd;
wire       uart0_txd;

wire       uart1_rxd;
wire       uart1_txd;

//IIC interface
wire        scl_i;
wire        scl_o;
wire        scl_oe_n;
wire        sda_i;
wire        sda_o;
wire        sda_oe_n;
//keypad interface  
wire [4:0]  row;
wire [4:0]  col;
wire        ir_in;
//gpio interface
wire [31:0]  gpio_in;
wire [31:0]  gpio_out;
wire [31:0]  gpio_oe;

//-----------------------------------------------------------//
//                          PARAMETERS                       //
//-----------------------------------------------------------//
//parameter INV_0  = 1'b0;


//-----------------------------------------------------------//
//                          ARCHITECTURE                     //
//-----------------------------------------------------------//

//================
//IOPAD
//behavior, to be updated by library cell
//================
assign clk_in = CLKIN;
assign rst_n  = RSTN ;

assign boot_en  = BOOT ;
                
assign uart0_rxd = RXD0;
assign TXD0      = uart0_txd;
        
//assign uart1_rxd = RXD1;
//assign TXD1      = uart1_txd;
assign uart1_rxd = 1'b1;
 
assign scl_i = 1'b0;
assign sda_i = 1'b0;
 
//assign ROW0  = row[0];
//assign ROW1  = row[1];
//assign ROW2  = row[2];
//assign ROW3  = row[3];
//assign ROW4  = row[4];
//assign col[0] = COL0;
//assign col[1] = COL1;
//assign col[2] = COL2;
//assign col[3] = COL3;
//assign col[4] = COL4;
assign col = 5'b0;

//assign ir_in = IRIN;
assign ir_in = 1'b0;
 
assign gpio_in[31:8] = 24'b0;
assign gpio_in[7:0] = {
                        GPIO0,
                        GPIO1,
                        GPIO2,
                        GPIO3,
                        GPIO4,
                        GPIO5,
                        GPIO6,
                        GPIO7 
                       };
assign GPIO0 = gpio_oe[0] ? gpio_out[0] : 1'bz;
assign GPIO1 = gpio_oe[1] ? gpio_out[1] : 1'bz;
assign GPIO2 = gpio_oe[2] ? gpio_out[2] : 1'bz;
assign GPIO3 = gpio_oe[3] ? gpio_out[3] : 1'bz;
assign GPIO4 = gpio_oe[4] ? gpio_out[4] : 1'bz;
assign GPIO5 = gpio_oe[5] ? gpio_out[5] : 1'bz;
assign GPIO6 = gpio_oe[6] ? gpio_out[6] : 1'bz;
assign GPIO7 = gpio_oe[7] ? gpio_out[7] : 1'bz;  


//===================
//Core logic
//===================
AMY_M0O AMY_M0O_u0(    
         .clk_in   (clk_in   ),
         .rst_n    (rst_n    ),
         .boot_en  (boot_en  ),
//UART0 interface                
         .uart0_rxd(uart0_rxd),
         .uart0_txd(uart0_txd),
//UART1 interface        
         .uart1_rxd(uart1_rxd),
         .uart1_txd(uart1_txd),
//IIC interface   
         .scl_i    (scl_i    ),
         .scl_o    (scl_o    ),
         .scl_oe_n (scl_oe_n ),
         .sda_i    (sda_i    ),
         .sda_o    (sda_o    ),
         .sda_oe_n (sda_oe_n ),   
//KEYPAD interface 
         .row      (row      ),
         .col      (col      ),
         .ir_in    (ir_in    ),
//GPIO interface  
         .gpio_in  (gpio_in  ),
         .gpio_out (gpio_out ),
         .gpio_oe  (gpio_oe  )         
        );
               
endmodule
       
       
       
       
       