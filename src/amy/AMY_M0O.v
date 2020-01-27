
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
// File        : AMY_M0O.v
// Author      : PODES
// Date        : 20200101
// Version     : 1.0
// Description : AMY_M0O Core module.
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

module AMY_M0O(    
         clk_in,
         rst_n,
		 boot_en,
//UART0 interface                  
         uart0_rxd,
         uart0_txd,
//UART1 interface         
         uart1_rxd,
         uart1_txd,
//IIC interface
         scl_i,
         scl_o,
         scl_oe_n,
         sda_i,
         sda_o,
         sda_oe_n,   
//KEYPAD interface  
         row,
         col,
         ir_in,
//GPIO interface
         gpio_in,
         gpio_out,
         gpio_oe           
        );

//-----------------------------------------------------------//
//                          PARAMETERS                       //
//-----------------------------------------------------------//
parameter ROM_ADDRESS_START    = 32'h0000_0000;
parameter ROM_ADDRESS_MASK     = 32'he000_0000;
parameter RAM_ADDRESS_START    = 32'h2000_0000;
parameter RAM_ADDRESS_MASK     = 32'he000_0000;


//-----------------------------------------------------------//
//                      INPUTS/OUTPUTS                       //
//-----------------------------------------------------------//
input        clk_in;
input        rst_n;
input        boot_en;

input        uart0_rxd;
output       uart0_txd;

input        uart1_rxd;
output       uart1_txd;

//IIC interface
input         scl_i;
output        scl_o;
output        scl_oe_n;
input         sda_i;
output        sda_o;
output        sda_oe_n;

//keypad interface  
output [4:0]  row;
input  [4:0]  col;
input         ir_in;

//gpio interface
input  [31:0]  gpio_in;
output [31:0]  gpio_out;
output [31:0]  gpio_oe;


//-----------------------------------------------------------//
//                    REGISTERS & WIRES                      //
//-----------------------------------------------------------//   

wire           glb_rst_n;
wire           por_rst_n;

wire           sysresetreq ;   

wire           boot_ctrl;
wire           clk;
wire           clk_20k;  
  
wire           ext_mhready    ;
wire           ext_mhsel      ;
wire  [31:0]   ext_mhaddr     ;
wire  [1 :0]   ext_mhtrans    ;
wire           ext_mhwrite    ;
wire  [31:0]   ext_mhwdata    ;
wire  [2 :0]   ext_mhsize     ;  
wire  [2 :0]   ext_mhburst    ;   
wire  [3 :0]   ext_mhprot     ;  
wire  [31:0]   ext_mhrdata    ;           
wire           ext_mhready_out;
wire           ext_mhresp     ; 

wire           rom_shready_in ;
wire           rom_shsel      ;
wire  [31:0]   rom_shaddr     ;
wire  [1 :0]   rom_shtrans    ;
wire           rom_shwrite    ;
wire  [31:0]   rom_shwdata    ;
wire  [2 :0]   rom_shsize     ;  
wire  [2 :0]   rom_shburst    ;
wire  [3 :0]   rom_shprot     ;   
wire  [31:0]   rom_shrdata    ;
wire           rom_shready_out;
wire           rom_shresp     ;  
                
wire           ram_shready_in ;
wire           ram_shsel      ;
wire  [31:0]   ram_shaddr     ;
wire  [1 :0]   ram_shtrans    ;
wire           ram_shwrite    ;
wire  [31:0]   ram_shwdata    ;
wire  [2 :0]   ram_shsize     ;
wire  [2 :0]   ram_shburst    ;
wire  [3 :0]   ram_shprot     ;
wire  [31:0]   ram_shrdata    ;
wire           ram_shready_out;
wire           ram_shresp     ;
                
wire           peri_shready_in ;
wire           peri_shsel      ;
wire  [31:0]   peri_shaddr     ;
wire  [1 :0]   peri_shtrans    ;
wire           peri_shwrite    ;
wire  [31:0]   peri_shwdata    ;
wire  [2 :0]   peri_shsize     ;  
wire  [2 :0]   peri_shburst    ;  
wire  [3 :0]   peri_shprot     ;  
wire  [31:0]   peri_shrdata    ;  
wire           peri_shready_out;
wire           peri_shresp     ;

wire          ramcs_n;
wire  [31:0]  ramaddr;
wire  [31:0]  ramdout;
wire  [31:0]  ramdin;
wire  [3:0]   ramben;
wire          ramwr_n;

wire          romcs_n;
wire  [31:0]  romaddr;
wire  [31:0]  romdout;
wire  [31:0]  romdin;
wire  [3:0]   romben;
wire          romwr_n;


wire          uart0_psel     ;
wire          uart0_penable  ;
wire  [31:0]  uart0_paddr    ;
wire          uart0_pwrite   ;
wire  [31:0]  uart0_pwdata   ;
wire  [31:0]  uart0_prdata   ;

wire          uart1_psel     ;
wire          uart1_penable  ;
wire  [31:0]  uart1_paddr    ;
wire          uart1_pwrite   ;
wire  [31:0]  uart1_pwdata   ;
wire  [31:0]  uart1_prdata   ;


wire          iic_psel     ;
wire          iic_penable  ;
wire  [31:0]  iic_paddr    ;
wire          iic_pwrite   ;
wire  [31:0]  iic_pwdata   ;
wire  [31:0]  iic_prdata   ;

wire          apbkey_psel     ;
wire          apbkey_penable  ;
wire  [31:0]  apbkey_paddr    ;
wire          apbkey_pwrite   ;
wire  [31:0]  apbkey_pwdata   ;
wire  [31:0]  apbkey_prdata   ;

wire          gpio_psel     ;
wire          gpio_penable  ;
wire  [31:0]  gpio_paddr    ;
wire          gpio_pwrite   ;
wire  [31:0]  gpio_pwdata   ;
wire  [31:0]  gpio_prdata   ;

wire          stn_psel     ;
wire          stn_penable  ;
wire  [31:0]  stn_paddr    ;
wire          stn_pwrite   ;
wire  [31:0]  stn_pwdata   ;
wire  [31:0]  stn_prdata   ;

wire          pwm_psel     ;
wire          pwm_penable  ;
wire  [31:0]  pwm_paddr    ;
wire          pwm_pwrite   ;
wire  [31:0]  pwm_pwdata   ;
wire  [31:0]  pwm_prdata   ;

wire          rsv_psel     ;
wire          rsv_penable  ;
wire  [31:0]  rsv_paddr    ;
wire          rsv_pwrite   ;
wire  [31:0]  rsv_pwdata   ;
wire  [31:0]  rsv_prdata   ;


wire          uart0_irq;
wire          uart1_irq;
wire          iic_irq;
wire          apbkey_irq;
wire          gpio_irq;
wire          stn_irq;
wire          pwm_irq;
wire          rsv_irq;

//-----------------------------------------------------------//
//                          PARAMETERS                       //
//-----------------------------------------------------------//
//parameter INV_0  = 1'b0;


//-----------------------------------------------------------//
//                          ARCHITECTURE                     //
//-----------------------------------------------------------//


wire [31:0] irq_in = {
                     24'b0,
                     rsv_irq, 
                     pwm_irq, 
                     stn_irq, 
                     gpio_irq, 
                     apbkey_irq, 
                     iic_irq, 
                     uart1_irq, 
                     uart0_irq
                     };
   
//rst_gen
rst_gen  rst_gen_u0 (
               .clk         (clk             ),          
               .rst_n       (rst_n           ),
			   .boot_en     (boot_en         ),
			   .boot_ctrl   (boot_ctrl       ),
               .sysresetreq (sysresetreq     ),
               .glb_rst_n   (glb_rst_n       ),     
               .por_rst_n   (por_rst_n       ) 
               );   

//clk_gen
clk_gen clk_gen_u0 (
               .clk_in      (clk_in         ),
               .rst_n       (rst_n          ),
               .clk         (clk            ),
               .clk_20k     (clk_20k        )
               );
			   
			   
PODES_M0O PODES_M0O_u0 (
               .clk            (clk            ),           
               .rst_n          (glb_rst_n      ),     
                                               
               .sysresetreq    (sysresetreq    ),         
               .nmi            (1'b0           ),           
               .irq            (irq_in         ), 
               
               .ext_mhready    (ext_mhready    ),
               .ext_mhsel      (ext_mhsel      ),
               .ext_mhaddr     (ext_mhaddr     ),
               .ext_mhtrans    (ext_mhtrans    ),
               .ext_mhwrite    (ext_mhwrite    ),
               .ext_mhwdata    (ext_mhwdata    ),
               .ext_mhsize     (ext_mhsize     ),  
               .ext_mhburst    (ext_mhburst    ),   
               .ext_mhprot     (ext_mhprot     ),  
               .ext_mhrdata    (ext_mhrdata    ),           
               .ext_mhready_out(ext_mhready_out),
               .ext_mhresp     (ext_mhresp     )
             );

ahblite1to3 
        #(
           .S0_ADDRESS_START(ROM_ADDRESS_START),
           .S0_ADDRESS_MASK (ROM_ADDRESS_MASK ), 
           .S1_ADDRESS_START(RAM_ADDRESS_START),
           .S1_ADDRESS_MASK (RAM_ADDRESS_MASK )   
         ) 
        ahblite1to3_u0(
          .clk         (clk           ),
          .rst_n       (rst_n         ),
          
          //Master IF
          .fm_hready  (ext_mhready    ), 
          .fm_hsel    (ext_mhsel      ), 
          .fm_haddr   (ext_mhaddr     ), 
          .fm_htrans  (ext_mhtrans    ), 
          .fm_hwrite  (ext_mhwrite    ), 
          .fm_hwdata  (ext_mhwdata    ), 
          .fm_hsize   (ext_mhsize     ),    
          .fm_hburst  (ext_mhburst    ), 
          .fm_hprot   (ext_mhprot     ),     
          .tm_hrdata  (ext_mhrdata    ),          
          .tm_hready  (ext_mhready_out), 
          .tm_hresp   (ext_mhresp     ),
          
          //Slv IF 0
          .ts0_hready (rom_shready_in ),
          .ts0_hsel   (rom_shsel      ),
          .ts0_haddr  (rom_shaddr     ),
          .ts0_htrans (rom_shtrans    ),
          .ts0_hwrite (rom_shwrite    ),
          .ts0_hwdata (rom_shwdata    ),
          .ts0_hsize  (rom_shsize     ),  
          .ts0_hburst (rom_shburst    ),
          .ts0_hprot  (rom_shprot     ),   
          .fs0_hrdata (rom_shrdata    ),
          .fs0_hready (rom_shready_out),
          .fs0_hresp  (rom_shresp     ),  
          
          //Slv IF 1
          .ts1_hready (ram_shready_in ),
          .ts1_hsel   (ram_shsel      ),
          .ts1_haddr  (ram_shaddr     ),
          .ts1_htrans (ram_shtrans    ),
          .ts1_hwrite (ram_shwrite    ),
          .ts1_hwdata (ram_shwdata    ),
          .ts1_hsize  (ram_shsize     ),
          .ts1_hburst (ram_shburst    ),
          .ts1_hprot  (ram_shprot     ),
          .fs1_hrdata (ram_shrdata    ),
          .fs1_hready (ram_shready_out),
          .fs1_hresp  (ram_shresp     ),
          
          //Slv IF 2
          .ts2_hready (peri_shready_in ),
          .ts2_hsel   (peri_shsel      ),
          .ts2_haddr  (peri_shaddr     ),
          .ts2_htrans (peri_shtrans    ),
          .ts2_hwrite (peri_shwrite    ),
          .ts2_hwdata (peri_shwdata    ),
          .ts2_hsize  (peri_shsize     ),  
          .ts2_hburst (peri_shburst    ),  
          .ts2_hprot  (peri_shprot     ),  
          .fs2_hrdata (peri_shrdata    ),  
          .fs2_hready (peri_shready_out),
          .fs2_hresp  (peri_shresp     )
        );
		
          

//--------------------------------------------
////RAM controller and RAM model
//-------------------------------------------- 
ahb_sram_ctrl  ahb_sram_ctrl_u0 (
       
          .clk             (clk             ),
          .rst_n           (glb_rst_n       ),
        
          .ram_shready_in  (ram_shready_in  ),
          .ram_shsel       (ram_shsel       ),
          .ram_shaddr      (ram_shaddr      ),
          .ram_shtrans     (ram_shtrans     ),
          .ram_shwrite     (ram_shwrite     ),
          .ram_shwdata     (ram_shwdata     ),
          .ram_shsize      (ram_shsize      ),
          .ram_shburst     (ram_shburst     ),
          .ram_shprot      (ram_shprot      ),         
          .ram_shrdata     (ram_shrdata     ),
          .ram_shready_out (ram_shready_out ),
          .ram_shresp      (ram_shresp      ),
       
          .ramcs_n         (ramcs_n         ),
          .ramaddr         (ramaddr         ),
          .ramdout         (ramdout         ),
          .ramdin          (ramdin          ),
          .ramben          (ramben          ),
          .ramwr_n         (ramwr_n         )          
       );
//ram model
sram_model sram_model_u0(
          .clk             (clk             ),
          .ramcs_n         (ramcs_n         ),
          .ramaddr         (ramaddr         ),
          .ramdout         (ramdout         ),
          .ramdin          (ramdin          ),
          .ramben          (ramben          ),
          .ramwr_n         (ramwr_n         )
              );

 
//--------------------------------------------
////ROM controller and ROM model
//--------------------------------------------
 
//ahb_srom_ctrl  ahb_srom_ctrl_u0 (
//       
//          .clk   (clk      ),
//          .rst_n (glb_rst_n),
//        
//          .rom_shready_in  (rom_shready_in  ),
//          .rom_shsel       (rom_shsel       ),
//          .rom_shaddr      (rom_shaddr      ),
//          .rom_shtrans     (rom_shtrans     ),
//          .rom_shwrite     (rom_shwrite     ),
//          .rom_shwdata     (rom_shwdata     ),
//          .rom_shsize      (rom_shsize      ),
//          .rom_shburst     (rom_shburst     ),
//          .rom_shprot      (rom_shprot      ),         
//          .rom_shrdata     (rom_shrdata     ),
//          .rom_shready_out (rom_shready_out ),
//          .rom_shresp      (rom_shresp      ),        
//        
//          .romcs_n (romcs_n ),
//          .romaddr (romaddr ),
//          .romdout (romdout )
//          
//       );

ahb_sram_ctrl  ahb_sram_ctrl_u1 (
       
          .clk             (clk             ),
          .rst_n           (glb_rst_n       ),
                           
          .ram_shready_in  (rom_shready_in  ),
          .ram_shsel       (rom_shsel       ),
          .ram_shaddr      (rom_shaddr      ),
          .ram_shtrans     (rom_shtrans     ),
          .ram_shwrite     (rom_shwrite     ),
          .ram_shwdata     (rom_shwdata     ),
          .ram_shsize      (rom_shsize      ),
          .ram_shburst     (rom_shburst     ),
          .ram_shprot      (rom_shprot      ),         
          .ram_shrdata     (rom_shrdata     ),
          .ram_shready_out (rom_shready_out ),
          .ram_shresp      (rom_shresp      ),
       
          .ramcs_n         (romcs_n         ),
          .ramaddr         (romaddr         ),
          .ramdout         (romdout         ),
          .ramdin          (romdin          ),
          .ramben          (romben          ),
          .ramwr_n         (romwr_n         )          
       );   
            
//rom model
//To be modified for real application.
//rom_model rom_model_u0(
//       .clk             (clk              ),
//       .romcs_n         (romcs_n          ),
//       .romaddr         (romaddr          ),
//       .romdout         (romdout          )
//        );
srom_model srom_model_u0(
          .clk            (clk             ),
          .boot_ctrl      (boot_ctrl       ),
          .romcs_n        (romcs_n         ),
          .romaddr        (romaddr         ),
          .romdout        (romdout         ),
          .romdin         (romdin          ),
          .romben         (romben          ),
          .romwr_n        (romwr_n         )
              );


			  
//--------------------------------------------
////Peripherals bus controller 
//-------------------------------------------- 
ahb2apb ahb2apb_u0 (
               .clk        (clk            ),           
               .rst_n      (glb_rst_n      ),    

//synopsys translate_off
`ifdef AHB_EMU
               .shready_in (testbench.emu_shready_in ),
               .shsel      (testbench.emu_shsel      ),
               .shaddr     (testbench.emu_shaddr     ),
               .shtrans    (testbench.emu_shtrans    ),
               .shwrite    (testbench.emu_shwrite    ),
               .shwdata    (testbench.emu_shwdata    ),
               .shsize     (testbench.emu_shsize     ),  
               .shburst    (testbench.emu_shburst    ),   
               .shprot     (testbench.emu_shprot     ),  
               .shrdata    (testbench.emu_shrdata    ),           
               .shready_out(testbench.emu_shready_out),
               .shresp     (testbench.emu_shresp     ),
`else
//synopsys translate_on
               .shready_in (peri_shready_in ),
               .shsel      (peri_shsel      ),
               .shaddr     (peri_shaddr     ),
               .shtrans    (peri_shtrans    ),
               .shwrite    (peri_shwrite    ),
               .shwdata    (peri_shwdata    ),
               .shsize     (peri_shsize     ),  
               .shburst    (peri_shburst    ),   
               .shprot     (peri_shprot     ),  
               .shrdata    (peri_shrdata    ),           
               .shready_out(peri_shready_out),
               .shresp     (peri_shresp     ),
//synopsys translate_off
`endif
//synopsys translate_on
               //UART0
               .apb0_psel   (uart0_psel   ),
               .apb0_penable(uart0_penable),
               .apb0_paddr  (uart0_paddr  ),
               .apb0_pwrite (uart0_pwrite ),
               .apb0_pwdata (uart0_pwdata ),
               .apb0_prdata (uart0_prdata ),
               //UART1                            
               .apb1_psel   (uart1_psel   ),     
               .apb1_penable(uart1_penable),     
               .apb1_paddr  (uart1_paddr  ),     
               .apb1_pwrite (uart1_pwrite ),  
               .apb1_pwdata (uart1_pwdata ),  
               .apb1_prdata (uart1_prdata ),  
               //IIC
               .apb2_psel   (iic_psel     ),
               .apb2_penable(iic_penable  ),
               .apb2_paddr  (iic_paddr    ),
               .apb2_pwrite (iic_pwrite   ),
               .apb2_pwdata (iic_pwdata   ),
               .apb2_prdata (iic_prdata   ),
               //APBKEY                              
               .apb3_psel   (apbkey_psel   ),     
               .apb3_penable(apbkey_penable),     
               .apb3_paddr  (apbkey_paddr  ),     
               .apb3_pwrite (apbkey_pwrite ), 
               .apb3_pwdata (apbkey_pwdata ), 
               .apb3_prdata (apbkey_prdata ),
               //GPIO
               .apb4_psel   (gpio_psel    ),
               .apb4_penable(gpio_penable ),
               .apb4_paddr  (gpio_paddr   ),
               .apb4_pwrite (gpio_pwrite  ),
               .apb4_pwdata (gpio_pwdata  ),
               .apb4_prdata (gpio_prdata  ),
               //STN                              
               .apb5_psel   (stn_psel     ),     
               .apb5_penable(stn_penable  ),     
               .apb5_paddr  (stn_paddr    ),     
               .apb5_pwrite (stn_pwrite   ),  
               .apb5_pwdata (stn_pwdata   ),  
               .apb5_prdata (stn_prdata   ),  
               //PWM
               .apb6_psel   (pwm_psel     ),
               .apb6_penable(pwm_penable  ),
               .apb6_paddr  (pwm_paddr    ),
               .apb6_pwrite (pwm_pwrite   ),
               .apb6_pwdata (pwm_pwdata   ),
               .apb6_prdata (pwm_prdata   ),
               //RSVED                              
               .apb7_psel   (rsv_psel     ),     
               .apb7_penable(rsv_penable  ),     
               .apb7_paddr  (rsv_paddr    ),     
               .apb7_pwrite (rsv_pwrite   ), 
               .apb7_pwdata (rsv_pwdata   ), 
               .apb7_prdata (rsv_prdata   )  
               
                );
                
//UART0
apbuart apbuart_u0 (
                 .rst_n       (por_rst_n    ),
                 .clk         (clk          ),
                 
                 .psel        (uart0_psel   ),
                 .penable     (uart0_penable),
                 .paddr       (uart0_paddr  ),
                 .pwrite      (uart0_pwrite ),
                 .pwdata      (uart0_pwdata ),
                 .prdata      (uart0_prdata ),
                
                 .uart_extclk (1'b0         ),        
                 .uart_ctsn   (1'b0         ),
                 .uart_rtsn   (             ),
                 .uart_irq    (uart0_irq    ),
                 .uart_rxd    (uart0_rxd    ),
                 .uart_txd    (uart0_txd    ) 
                 );

//
////UART1
//apbuart apbuart_u1 (
//                 .rst_n       (por_rst_n    ),
//                 .clk         (clk          ),
//                 
//                 .psel        (uart1_psel   ),
//                 .penable     (uart1_penable),
//                 .paddr       (uart1_paddr  ),
//                 .pwrite      (uart1_pwrite ),
//                 .pwdata      (uart1_pwdata ),
//                 .prdata      (uart1_prdata ),
//                
//                 .uart_extclk (1'b0         ),        
//                 .uart_ctsn   (1'b0         ),
//                 .uart_rtsn   (             ),
//                 .uart_irq    (uart1_irq    ),
//                 .uart_rxd    (uart1_rxd    ),
//                 .uart_txd    (uart1_txd    ) 
//                 );
 assign uart1_prdata = 32'b0;
 assign uart1_irq = 1'b0;
 assign uart1_txd = 1'b0;
//
//
////IIC
//apb2iic apb2iic_u0 (
//                    .clk      (clk         ),
//                    .rst_n    (rst_n       ),
//                    .iic_irq  (iic_irq     ),
//                             
//                    .psel     (iic_psel    ),
//                    .penable  (iic_penable ),
//                    .paddr    (iic_paddr   ),
//                    .pwrite   (iic_pwrite  ),
//                    .pwdata   (iic_pwdata  ),
//                    .prdata   (iic_prdata  ),
//                              
//                    .scl_i    (scl_i    ),
//                    .scl_o    (scl_o    ),
//                    .scl_oe_n (scl_oe_n ),
//                    .sda_i    (sda_i    ),
//                    .sda_o    (sda_o    ),
//                    .sda_oe_n (sda_oe_n )
//                 ); 
 assign iic_prdata = 32'b0;
 assign iic_irq = 1'b0;
 assign scl_o = 1'b0;
 assign sda_o = 1'b0;
 assign scl_oe_n = 1'b1;
 assign sda_oe_n = 1'b1;
 
////apbkey
//apbkey apbkey_u0 (
//                    .clk      (clk      ),
//                    .rst_n    (rst_n    ),
//                    .apbkey_irq  (apbkey_irq  ),
//                             
//                    .psel     (apbkey_psel    ),
//                    .penable  (apbkey_penable ),
//                    .paddr    (apbkey_paddr   ),
//                    .pwrite   (apbkey_pwrite  ),
//                    .pwdata   (apbkey_pwdata  ),
//                    .prdata   (apbkey_prdata  ),
//                              
//                    .clk_20k  (clk_20k    ),
//                    .row      (row        ),
//                    .col      (col        ),
//                    .ir_in    (ir_in      )
//                 );
//  
 assign row = 5'b0;
 assign apbkey_prdata = 32'b0;
 assign apbkey_irq = 1'b0;

//gpio
apbgpio apbgpio_u0 (
                    .clk      (clk          ),
                    .rst_n    (rst_n        ),
                    .gpio_irq (gpio_irq     ),
                             
                    .psel     (gpio_psel    ),
                    .penable  (gpio_penable ),
                    .paddr    (gpio_paddr   ),
                    .pwrite   (gpio_pwrite  ),
                    .pwdata   (gpio_pwdata  ),
                    .prdata   (gpio_prdata  ),
                              
                    .gpio_in  (gpio_in      ),
                    .gpio_out (gpio_out     ),
                    .gpio_oe  (gpio_oe      )
                 );
 
 //To add blank module, but not use below assignment.
 assign stn_prdata = 32'b0;
 assign stn_irq = 1'b0;
 
 assign pwm_prdata = 32'b0;
 assign pwm_irq = 1'b0;
 
 assign rsv_prdata = 32'b0;
 assign rsv_irq = 1'b0;
               
endmodule
       
       
       
       
       