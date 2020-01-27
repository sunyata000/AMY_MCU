
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
// File        : rst_gen.v
// Author      : PODES
// Date        : 20200101
// Version     : 1.0
// Description : RESET generator.
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



module	rst_gen(
               clk,          
               rst_n,
			   boot_en,
			   boot_ctrl,
               sysresetreq,
               glb_rst_n,     
               por_rst_n    
        );


//-----------------------------------------------------------//
//                          PARAMETERS                       //
//-----------------------------------------------------------//



//-----------------------------------------------------------//
//                      INPUTS/OUTPUTS                       //
//-----------------------------------------------------------//  
input                   clk;
input                   rst_n;
input                   boot_en;
output                  boot_ctrl;

input                   sysresetreq;

output                  glb_rst_n;
output                  por_rst_n;



//-----------------------------------------------------------//
//                    REGISTERS & WIRES                      //
//-----------------------------------------------------------//
reg boot_ctrl;
reg por_rst_n;
reg glb_rst_n;



//-----------------------------------------------------------//
//                          ARCHITECTURE                     //
//-----------------------------------------------------------//

//----------------------------
//por_rst_n
//----------------------------
reg [7:0] por_rst_n_reg;
always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        por_rst_n_reg <= 8'h0;
        por_rst_n <= 1'b0;
    end
    else
    begin
        por_rst_n_reg <= {por_rst_n_reg[6:0], rst_n};
        por_rst_n <= ( & por_rst_n_reg);
    end
end


//----------------------------
//boot_ctrl
//----------------------------
reg [7:0] boot_ctrl_reg;
always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        boot_ctrl_reg <= 8'h0;
        boot_ctrl <= 1'b0;
    end
    else
    begin
        boot_ctrl_reg <= {boot_ctrl_reg[6:0], ~boot_en};
        boot_ctrl <= ( & boot_ctrl_reg);
    end
end


//----------------------------
//boot_chg
//----------------------------
reg  boot_ctrl_dly;
reg  boot_chg;
always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        boot_ctrl_dly <= 1'b0;
        boot_chg <= 1'b0;
    end
    else
    begin
        boot_ctrl_dly <= boot_ctrl;
        boot_chg <= ( boot_ctrl_dly ^ boot_ctrl);
    end
end


reg sysresetreq_d1;
always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
        sysresetreq_d1 <= 1'b0;
    else
        sysresetreq_d1 <= sysresetreq;
end

reg [15:0] glb_rst_n_reg;
always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        glb_rst_n_reg <= 16'h0;
        glb_rst_n <= 1'b0;
    end
    else if ((!sysresetreq_d1 && sysresetreq) || boot_chg)
    begin
        glb_rst_n_reg <= 16'h0;
        glb_rst_n <= 1'b0;
    end
    else
    begin
        glb_rst_n_reg <= {glb_rst_n_reg[14:0], rst_n};
        glb_rst_n     <= ( & glb_rst_n_reg);
    end
end


endmodule
