
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
// File        : apbgpio.v
// Author      : PODES
// Date        : 20200101
// Version     : 1.0
// Description : 32bits GPIO port.
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

module apbgpio(
              clk,
              rst_n,
              paddr,
              psel,
              penable,
              pwrite,
              prdata,
              pwdata,
              gpio_irq,
              
              //gpio I/F 
              gpio_in,
              gpio_out,
              gpio_oe
             );
             
//-----------------------------------------------------------//
//                          PARAMETERS                       //
//-----------------------------------------------------------//
//


//-----------------------------------------------------------//
//                      INPUTS/OUTPUTS                       //
//-----------------------------------------------------------//  
             
input         clk;
input         rst_n;
input  [31:0] paddr;
input         psel;
input         penable;
input         pwrite;
input  [31:0] pwdata;
output [31:0] prdata;

output       gpio_irq;

input  [31:0]  gpio_in;
output [31:0]  gpio_out;
output [31:0]  gpio_oe;



//-----------------------------------------------------------//
//                    REGISTERS & WIRES                      //
//-----------------------------------------------------------//

reg  [31:0]  prdata;

wire         gpio_irq;

wire [31:0]  gpio_out;
wire [31:0]  gpio_oe;



reg [31:0]    gpio_out_reg ;// register for GPIO output.
reg [31:0]    gpio_dir_reg ;//high: output; low: input.
reg [31:0]    gpio_irq_edg ;//High: interrupt for low to high; low: interrupt for high to low. 
reg [31:0]    gpio_irq_enb ;//High: enable interrupt; low: disable. 
reg [31:0]    gpio_irq_sts ;//high: a low to high or high to low transition occurs.    


reg [31:0]    gpio_in_dly1  ;
reg [31:0]    gpio_in_dly2  ;//register for GPIO input.


//-----------------------------------------------------------//
//                          ARCHITECTURE                     //
//-----------------------------------------------------------//  
wire apbrd = psel & penable & (~pwrite);
wire apbwr = psel & penable & pwrite;


//========================
//Write operation to registers
//========================
always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
      gpio_out_reg <= 32'b0;
      gpio_dir_reg <= 32'b0;
      gpio_irq_edg <= 32'b0;
      gpio_irq_enb <= 32'b0;   
    end
    else if (apbwr) 
    begin
      case (paddr[7:0])
      8'h00: gpio_out_reg <= pwdata;
      8'h04: gpio_dir_reg <= pwdata;
      8'h0c: gpio_irq_edg <= pwdata;
      8'h10: gpio_irq_enb <= pwdata;
      default: ;
      endcase
    end
end        


//========================
//Read operation to registers
//========================
always @ *
begin
    if( apbrd )
        case (paddr[7:0])
          8'h00:    prdata = gpio_out_reg;
          8'h04:    prdata = gpio_dir_reg;
          8'h08:    prdata = gpio_in_dly2;
          8'h0c:    prdata = gpio_irq_edg;
          8'h10:    prdata = gpio_irq_enb;
          8'h14:    prdata = gpio_irq_sts;
          default : prdata = 32'b0;
        endcase
    else
        prdata = 32'b0;
end



//========================
//GPIO functions
//========================
always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
      gpio_in_dly1     <= 32'b0;
      gpio_in_dly2     <= 32'b0;
    end
    else  
    begin
      gpio_in_dly1     <= gpio_in & (~gpio_dir_reg); //if output, do not loopback to input port.
      gpio_in_dly2     <= gpio_in_dly1;
    end
end

//low to high
wire [31:0] gpio_l2h = (~gpio_in_dly2) & gpio_in_dly1 & (~gpio_dir_reg);
//high to low
wire [31:0] gpio_h2l = (~gpio_in_dly1) & gpio_in_dly2 & (~gpio_dir_reg);
//irq status register
always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
      gpio_irq_sts     <= 32'b0;
    end
    else if (apbwr && (paddr[7:0] == 8'h14))    
      gpio_irq_sts <= ~pwdata & gpio_irq_sts;  //write-1-clear
    else  
    begin
      gpio_irq_sts <= gpio_irq_sts | (gpio_l2h & gpio_irq_edg) | (gpio_h2l & (~gpio_irq_edg));
    end
end
//irq gen
assign gpio_irq = | (gpio_irq_sts & gpio_irq_enb);

//gpio output
assign gpio_oe  = gpio_dir_reg; //high enable
assign gpio_out = gpio_out_reg;


endmodule