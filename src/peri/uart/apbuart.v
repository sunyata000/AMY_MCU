
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
// File        : apbuart.v
// Author      : PODES
// Date        : 20200101
// Version     : 1.0
// Description : Simple UART module with APB I/F
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


module apbuart (
                      rst_n      ,
                      clk        ,
                               
                      psel       ,
                      penable    ,
                      paddr      ,
                      pwrite     ,
                      pwdata     ,                             
                      prdata     ,
                            
                      uart_extclk,
					  uart_ctsn  ,  //1'b0
					  uart_rtsn  ,
					  uart_irq   ,
                      uart_rxd   ,
                      uart_txd  
                      );
 

 input           rst_n   ;
 input           clk     ;
    
 input           psel    ;
 input           penable ;
 input [31:0]    paddr   ;
 input           pwrite  ;                           
 input  [31:0]   pwdata  ;   
 output [31:0]   prdata  ;
   
 input           uart_extclk;
 input           uart_ctsn  ;
 output          uart_rtsn  ;
 output          uart_irq   ; 
 input           uart_rxd   ;
 output          uart_txd   ;
 
  
 reg [31:0]    prdata   ; 
 reg           uart_rtsn;
 wire          uart_irq ;  
 reg           uart_txd ;
 
//============================================
//============================================ 

parameter RX_IDLE      = 3'b000;
parameter RX_STARTBIT  = 3'b001;
parameter RX_DATA      = 3'b010; 
parameter RX_CPARITY   = 3'b011;
parameter RX_STOPBIT   = 3'b100;

parameter TX_IDLE      = 2'b00;
parameter TX_DATA      = 2'b01;
parameter TX_CPARITY   = 2'b10;
parameter TX_STOPBIT   = 2'b11;
 



//==========================================
//==========================================
reg [7:0]  thold   ;
reg        extclken;
reg        loopb   ;
reg        flow    ;
reg        paren   ;
reg        parsel  ;
reg        tirqen  ;
reg        rirqen  ;
reg        txen    ;
reg        rxen    ;
reg [11:0] brate   ;

//--------------------
reg [1:0]  txstate ;
reg        tsempty ;
reg        tpar    ;
reg [10:0] tshift  ;
reg        thempty ;

//-------------------
reg [2:0]  rxstate;
reg [7:0]  rhold   ;
reg        rsempty ;
reg [7:0]  rshift  ;
reg        dready  ;
reg        ovf     ;
reg        dpar    ;
reg        parerr  ;
reg        frameerr;
reg        breakerr; 


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
      thold    <= 8'b0;	  
      extclken <= 1'b0;
      loopb    <= 1'b0;
      flow     <= 1'b0;
      paren    <= 1'b0;
      parsel   <= 1'b0;
      tirqen   <= 1'b0;
      rirqen   <= 1'b0;
      txen     <= 1'b1;
      rxen     <= 1'b1;
      brate    <= 12'd2499; //24Mhz, baud_rate 1200
    end
    else if (apbwr) 
    begin
      case (paddr[7:2])
      6'b000000: begin //data register
	      thold     <= pwdata[7:0];
	  end
	  //status register is updated in FSM.
      6'b000010: begin //control register
          extclken  <= pwdata[8];
          loopb     <= pwdata[7];
          flow      <= pwdata[6];
          paren     <= pwdata[5];
          parsel    <= pwdata[4];
          tirqen    <= pwdata[3];
          rirqen    <= pwdata[2];
          txen      <= pwdata[1];
          rxen      <= pwdata[0];
      end
      6'b000011: begin //baud rate register
          brate     <= pwdata[11:0];
      end
      default: ;
      endcase
    end
end        


//========================
//Reade operation to registers
//========================
always @ *
begin
    if( apbrd )
        case (paddr[7:2])
          6'b000000:    prdata = {24'b0, rhold};
          6'b000001:    prdata = {25'b0,
		                          frameerr, 
                                  parerr , 
                                  ovf ,
                                  breakerr , 
                                  thempty , 
                                  tsempty , 
                                  dready};
          6'b000010:    prdata = {23'b0,
		                          extclken , 
                                  loopb ,
                                  flow , 
                                  paren , 
                                  parsel , 
                                  tirqen , 
                                  rirqen , 
                                  txen , 
                                  rxen};
          6'b000011:    prdata = {20'b0, brate};
          default :     prdata = 32'b0;
        endcase
    else
        prdata = 32'b0;
end


//============================================
// scaler tick
//============================================ 
reg          scaler_tick;
reg  [11:0]  scaler     ;
wire [11:0]  scaler_dec = (rxen | txen) ? (scaler - 1'b1) : scaler;

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
      scaler    <= 12'b0;
	end
	else if (apbwr && (paddr[7:2] == 6'b000011))
	begin
      scaler    <= pwdata[11:0];
	end
	else if (scaler_dec[11]  && (~scaler[11]))
	begin
      scaler    <= brate;
	end
	else   
	begin
      scaler    <= scaler_dec;
	end
end

reg extclk_d1;
reg extclk_d2;
reg extclk_d3;	 
always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
      extclk_d1 <= 1'b0;
      extclk_d2 <= 1'b0;
      extclk_d3 <= 1'b0;	 
	end
	else 
    begin
      extclk_d1 <= uart_extclk ; 
      extclk_d2 <= extclk_d1   ;
      extclk_d3 <= extclk_d2   ;	 
	end
end
	
always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
      scaler_tick    <= 1'b0;
	end
	else if (extclken) 
	begin
      scaler_tick    <= extclk_d3 & (~extclk_d2);
	end
	else   
	begin
      scaler_tick    <= scaler_dec[11]  & (~scaler[11]);
	end
end	


//================================================
// Filter for RXD
//================================================
reg [4:0] rxf;
reg [1:0] rxdb;
	
always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
      rxf[1:0]    <= 2'b0;
	end
	else 
    begin
      rxf[1:0]    <= {rxf[0], uart_rxd};
	end
end
	
always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
      rxf[4:2]    <= 3'b0;
	end
	else if (scaler_tick)
    begin
      rxf[4:2]    <= rxf[3:1];
	end
end	

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
      rxdb    <= 2'b0;
	end
	else if (loopb)
    begin
      rxdb    <= {rxdb[0], tshift[0]};
	end
	else
    begin
      rxdb    <= {rxdb[0],
	              (rxf[4] & rxf[3]) | (rxf[4] & rxf[2]) | (rxf[3] & rxf[2])
				 };
	end
end	
wire rxd = rxdb[0];


//============================================
// Reciever tick
// Each bit period occupies 8 scale_tick cycles. 
// If detect a startbit on rxd, re-set the rxcnt. 
//    Count 4 scale_ticks then sample the data bit.
//============================================ 
reg         rxtick;
reg [2:0]   rxcnt;

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
      rxtick    <= 1'b0;
      rxcnt     <= 3'b000;
	end
	else if ((rxstate == RX_IDLE ) && rxen && rxdb[1] && (!rxd))
    begin
      rxtick    <= 1'b0;
      rxcnt     <= 3'b101;
	end
	else 
	begin
      rxtick    <= scaler_tick & (rxcnt == 3'b111);
      rxcnt     <= scaler_tick ? (rxcnt + 1'b1) : rxcnt;
	end
end


//============================================
// Trasmitter tick
// Each bit period occupies 8 scale_tick cycles. 
// If data is ready to be sent, reset the rxcnt.
//      then count 8 scale_ticks for sending one bit.
//============================================ 
reg         txtick;
reg [2:0]   txcnt;
reg         ctsn;

always @ (posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
      txtick    <= 1'b0;
      txcnt     <= 3'b000;
	end
	else if ((txstate == TX_IDLE) &&
	         (txen && (!thempty) && txtick) && 
			 ((!ctsn) || (!flow)))
    begin
      txtick    <= 1'b0;
      txcnt     <= {2'b00 , scaler_tick};
	end
	else 
	begin
      txtick    <= scaler_tick & (txcnt == 3'b111);
      txcnt     <= scaler_tick ? (txcnt + 1'b1) : txcnt;
	end
end

//====================================
// CTSN: clear to send.
//====================================
reg [1:0] ctsn_dly;
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
      ctsn_dly    <= 2'b0;
	end
	else 
    begin
      ctsn_dly    <= {ctsn_dly[0], uart_ctsn};
	end
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
      ctsn    <= 1'b0;
	end
	else if (loopb)
    begin
      ctsn    <= dready & (~rsempty);
	end
	else 
	begin
	  ctsn    <= (flow) ? ctsn_dly[1] : 1'b0;
	end
end	

//====================================
// RTSN: Request to Send.
//====================================
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
      uart_rtsn    <= 1'b1;
	end
	else if (rxtick)
    begin
      uart_rtsn    <= dready & (~rsempty) | loopb;
	end
end	      
 

//====================================
// transmitter operation
//====================================
reg [1:0]  nxt_txstate;
reg        nxt_tsempty;
reg        nxt_tpar;
reg [10:0] nxt_tshift;
reg        nxt_thempty;
reg        nxt_tirq;

always @(*)
begin
    nxt_txstate = txstate;
    nxt_tsempty = tsempty;
    nxt_tpar    = tpar;
    nxt_tshift  = tshift;
    nxt_thempty = thempty;
	nxt_tirq    = 1'b0;
	
    case (txstate)
    TX_IDLE: begin //-- idle state
      if (txtick) 
	    nxt_tsempty  = 1'b1;
      if ((txen && (!thempty) && txtick) && ((!ctsn) || (!flow))) 
      begin
          nxt_txstate  = TX_DATA;
          nxt_tpar     = parsel; 
          nxt_tsempty  = 1'b0;
          nxt_tshift   = {2'b10 , thold, 1'b0}; 
          nxt_thempty  = 1'b1;		  
          nxt_tirq     = tirqen;  //only once cycle for interrupt
      end 
    end
    TX_DATA: begin //  -- transmit data frame
      if (txtick)
      begin
         nxt_tpar    = tpar ^ tshift[1];
         nxt_tshift  = {1'b1 , tshift[10:1]};
        if (tshift[10:1] == 10'b11_1111_1110) 
        if (paren) 
        begin
            nxt_tshift[0]  = tpar; 
            nxt_txstate    = TX_CPARITY;
        end
        else
        begin
            nxt_tshift[0] = 1'b1; 
            nxt_txstate   = TX_STOPBIT;
        end
      end
    end
    TX_CPARITY: begin  //  -- transmit parity bit
      if (txtick)
      begin
          nxt_tshift   = {1'b1, tshift[10:1]}; 
          nxt_txstate  = TX_STOPBIT;
      end
    end
    TX_STOPBIT: begin  //  -- transmit stop bit
      if (txtick) 
      begin
          nxt_tshift   = {1'b1 , tshift[10:1]}; 
          nxt_txstate  = TX_IDLE;
      end
    end
    endcase
	//if writing data register, thempty will be cleard.
    if ((apbwr) && (paddr[7:2] == 6'b000000))
    begin
        nxt_thempty  = 1'b0;	
	end
//synopsys translate_off
`ifdef SPEEDUP_SIM
    nxt_thempty = 1'b1;
    nxt_tsempty = 1'b1;
`endif
//synopsys translate_on	
	
end

reg tirq;
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
      txstate <= TX_IDLE;
      tsempty <= 1'b1;
      tpar    <= 1'b0;
      tshift  <= 11'b111_1111_1111;
      thempty <= 1'b1;
	  tirq    <= 1'b0;
	end
	else
	begin
      txstate <= nxt_txstate  ;
      tsempty <= nxt_tsempty  ;
      tpar    <= nxt_tpar     ;
      tshift  <= nxt_tshift   ;
      thempty <= nxt_thempty  ;
	  tirq    <= nxt_tirq     ;
	end
end	
 
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
      uart_txd <= 1'b1;
	end
	else
	begin
      uart_txd <= tshift[0] | loopb  ;
	end
end	

		
	

//===================================     
// receiver operation
//===================================
reg [2:0]  nxt_rxstate;
reg        nxt_rsempty;
reg [7:0]  nxt_rhold;
reg [7:0]  nxt_rshift;
reg        nxt_dready;
reg        nxt_ovf;
reg        nxt_dpar;
reg        nxt_parerr;
reg        nxt_frameerr;
reg        nxt_break;
reg        nxt_rirq;

always @(*)
begin
    nxt_rxstate  = rxstate ;
    nxt_rsempty  = rsempty ;
    nxt_rhold    = rhold   ;
    nxt_rshift   = rshift  ;
    nxt_dready   = dready  ;
    nxt_ovf      = ovf     ;
    nxt_dpar     = dpar    ;
    nxt_parerr   = parerr  ;
    nxt_frameerr = frameerr;
    nxt_break    = breakerr   ;
	nxt_rirq     = 1'b0    ;

    case (rxstate)
    RX_IDLE: begin   //    -- wait for start bit
      if ((!rsempty) && (!dready))
      begin
          nxt_rhold    = rshift;
          nxt_dready   = 1'b1;  
          nxt_rsempty  = 1'b1;        
      end
      if (rxen && rxdb[1] && (!rxd))
      begin
          nxt_rxstate  = RX_STARTBIT; 
          nxt_rshift   = 8'b1111_1111; 
      end
    end
    RX_STARTBIT: begin  //-- start bit
      if (rxtick)
        if (!rxd)
        begin
		    nxt_ovf     = rsempty ? 1'b0 : 1'b1;
			nxt_rsempty = 1'b0;
            nxt_rshift  = {rxd , rshift[7:1]}; 
            nxt_rxstate = RX_DATA;
            nxt_dpar    = parsel;
        end
        else
            nxt_rxstate  = RX_IDLE;
    end
    RX_DATA: begin   //-- receive data frame
      if (rxtick)
      begin
          nxt_dpar    = dpar ^ rxd;
          nxt_rshift  = {rxd , rshift[7:1]};
          if (!rshift[0])
          begin
              if (paren) 
                  nxt_rxstate  = RX_CPARITY;
              else 
              begin
                  nxt_rxstate  = RX_STOPBIT; 
                  nxt_dpar     = 1'b0; 
              end
          end 
      end
    end   
    RX_CPARITY: begin   //-- receive parity bit
      if (rxtick)
      begin
          nxt_dpar     = dpar ^ rxd; 
          nxt_rxstate  = RX_STOPBIT;
      end
    end
    RX_STOPBIT: begin  //-- receive stop bit
      if (rxtick)
      begin
          nxt_rirq  = rirqen; //only one cycle for interrupt.
          if (rxd)
          begin
              nxt_parerr   = parerr | dpar; 
              nxt_rsempty  = dpar;  //if parity is error, rsempty will be forced to high.
              if ((!dready) && (!dpar))
              begin
                  nxt_rsempty  = 1'b1;
                  nxt_rhold    = rshift;
                  nxt_dready   = 1'b1;
              end
          end
          else
          begin
              nxt_rsempty  = 1'b1;
              if (rshift == 8'b00000000) 
			    nxt_break  = 1'b1;
              else 
			    nxt_frameerr  = 1'b1; 
          end
          nxt_rxstate = RX_IDLE;
      end
    end
    endcase	
	//if writing status register, they will be cleard.
    if ((apbwr) && (paddr[7:2] == 6'b000001))
    begin
        nxt_frameerr  = 1'b0;
        nxt_parerr    = 1'b0;
        nxt_ovf       = 1'b0;
        nxt_break     = 1'b0;		
	end
	//if read data port, dready will be cleard.
    if ((apbrd) && (paddr[7:2] == 6'b000000)) 
    begin
        nxt_dready  = 1'b0;
	end
	
end
	
reg rirq;
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
      rxstate  <= RX_IDLE ;
      rsempty  <= 1'b1;
      rhold    <= 8'b0;
      rshift   <= 8'b1111_1111;
      dready   <= 1'b0;
      ovf      <= 1'b0;
      dpar     <= 1'b0;
      parerr   <= 1'b0;
      frameerr <= 1'b0;
      breakerr    <= 1'b0;
	  rirq     <= 1'b0;
	end
	else
	begin
      rxstate  <= nxt_rxstate  ;
      rsempty  <= nxt_rsempty  ;
      rhold    <= nxt_rhold    ;
      rshift   <= nxt_rshift   ;
      dready   <= nxt_dready   ;
      ovf      <= nxt_ovf      ;
      dpar     <= nxt_dpar     ;
      parerr   <= nxt_parerr   ;
      frameerr <= nxt_frameerr ;
      breakerr    <= nxt_break    ;
	  rirq     <= nxt_rirq     ;
	end
end	
	
assign uart_irq = rirq | tirq;  //only one cycle.	
	

endmodule


