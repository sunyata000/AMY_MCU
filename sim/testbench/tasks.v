

//====================================================
//Tasks: ahb idle.
//====================================================
task ahb_idle(
input integer clk_count
               );
begin
	#100ps;
	@(posedge `TB_TOP.clk);
	repeat (clk_count) @(posedge `TB_TOP.clk);
end
endtask


//====================================================
//Tasks: ahb read
//====================================================
task automatic ahb_reg_read(
	input  [31:0]	addr,
	input  [3:0]		be,
 	output reg[31:0]	data
	);

   begin
          @(posedge `TB_TOP.clk);
          #100ps;
	      `TB_TOP.emu_shaddr  = addr[31:0];
          `TB_TOP.emu_shtrans = 2'b10; //NONSEQ
          `TB_TOP.emu_shwrite = 0;
          `TB_TOP.emu_shsize  = ((be==4'h1) |
                            (be==4'h2) |
                            (be==4'h4) |
                            (be==4'h8)) ? 3'b000 : //Byte
                            (be==4'h3) ? 3'b001 : //HWord
                            (be==4'hC) ? 3'b001 : //HWord
                                       3'b010;  //Word
          `TB_TOP.emu_shburst = 4'h0; //SINGLE
          @(posedge `TB_TOP.clk);  
          #100ps;
	  `TB_TOP.emu_shaddr = 32'h0000_0000;
	  `TB_TOP.emu_shburst = 3'b000;
	  `TB_TOP.emu_shtrans = 2'b00;
	  `TB_TOP.emu_shsize = 3'b000;
	  @(posedge `TB_TOP.clk); 
	  while (`TB_TOP.emu_shready_out == 0) #100ps;
          data = `TB_TOP.emu_shrdata[31:0];
        
         @(posedge `TB_TOP.clk); 
         $display("[AHB_EMU] Register Read End    : ADDR=%h; BE=%h RD_DATA=%h @%0d",addr,be,data,$time);
  end

endtask


//====================================================
//Tasks: ahb read and comparison
//====================================================
task automatic ahb_reg_read_cmp(
	input  [31:0]	addr,
	input  [3:0]	be,
	input  [31:0]   cdata
	);
reg [31:0] data;

   begin
          @(posedge `TB_TOP.clk);
          #100ps;
	      `TB_TOP.emu_shaddr  = addr[31:0];
          `TB_TOP.emu_shtrans = 2'b10; //NONSEQ
          `TB_TOP.emu_shwrite = 0;
          `TB_TOP.emu_shsize  = ((be==4'h1) |
                            (be==4'h2) |
                            (be==4'h4) |
                            (be==4'h8)) ? 3'b000 : //Byte
                            (be==4'h3) ? 3'b001 : //HWord
                            (be==4'hC) ? 3'b001 : //HWord
                                       3'b010;  //Word
          `TB_TOP.emu_shburst = 4'h0; //SINGLE
          @(posedge `TB_TOP.clk);  
          #100ps;
	  `TB_TOP.emu_shaddr = 32'h0000_0000;
	  `TB_TOP.emu_shburst = 3'b000;
	  `TB_TOP.emu_shtrans = 2'b00;
	  `TB_TOP.emu_shsize = 3'b000;
	  @(posedge `TB_TOP.clk); 
	  while (`TB_TOP.emu_shready_out == 0) #100ps;
          data = `TB_TOP.emu_shrdata[31:0];

          if (((be[0] ==1'b1) && (data[7:0] !== cdata[7:0])) ||
              ((be[1] ==1'b1) && (data[15:8] !== cdata[15:8])) ||
              ((be[2] ==1'b1) && (data[23:16] !== cdata[23:16])) ||
              ((be[3] ==1'b1) && (data[31:24] !== cdata[31:24]))) begin
	   $display("[AHB_EMU] ### DATA COMPARE FAILED ### address= %h, exp_data= %h, rd_data= %h : time = %d", addr , cdata, data, $time);
	   end
	  @(posedge `TB_TOP.clk); 
         $display("[AHB_EMU] Register Read/Comp End    : ADDR=%h; BE=%h RD_DATA=%h EX_DATA=%h @%0d",addr,be,data,cdata,$time);
   end

endtask


//====================================================
//Tasks: ahb_write
//====================================================

task automatic ahb_reg_write(
	input  [31:0]	addr,
	input  [3:0]	be,
	input  [31:0]   data
	);

   begin
          @(posedge `TB_TOP.clk);
          #100ps;
	      `TB_TOP.emu_shaddr  = addr[31:0];
          `TB_TOP.emu_shtrans = 2'b10; //NONSEQ
          `TB_TOP.emu_shwrite = 1;
          `TB_TOP.emu_shsize  = ((be==4'h1) |
                            (be==4'h2) |
                            (be==4'h4) |
                            (be==4'h8)) ? 3'b000 : //Byte
                            (be==4'h3) ? 3'b001 : //HWord
                            (be==4'hC) ? 3'b001 : //HWord
                                       3'b010;  //Word
          `TB_TOP.emu_shburst = 4'h0; //SINGLE
          `TB_TOP.emu_shwdata = 32'h0; 
          @(posedge `TB_TOP.clk);  
          #100ps;
	  `TB_TOP.emu_shaddr = 32'h0000_0000;
	  `TB_TOP.emu_shburst = 3'b000;
	  `TB_TOP.emu_shtrans = 2'b00;
	  `TB_TOP.emu_shsize = 3'b000;
          `TB_TOP.emu_shwrite = 0;
          `TB_TOP.emu_shwdata = data; 
	  @(posedge `TB_TOP.clk); 
	  while (`TB_TOP.emu_shready_out == 0) #100ps;

	  @(posedge `TB_TOP.clk); 
          $display("[AHB_EMU] Register Write End        : ADDR=%h; BE=%h DATA=%h @%0d",addr,be,data,$time);
   end

endtask


/*

//====================================================
//Tasks: DSU Initialization.
//====================================================
task dcu_init ();
  begin
          dcu_send(8'h55);
          #10us;
          dcu_send(8'h55);
          #10us;          
  end
endtask

//====================================================
//Tasks: DSU writes a word
//====================================================
task dcu_wr_reg (
                 input [31:0] wr_addr,
                 input [31:0] wr_data
                  );
 begin           
          dcu_send(8'hc0);
          dcu_send(wr_addr[31:24]);
          dcu_send(wr_addr[23:16]);
          dcu_send(wr_addr[15:8]);
          dcu_send(wr_addr[7:0]);
          dcu_send(wr_data[31:24]);
          dcu_send(wr_data[23:16]);
          dcu_send(wr_data[15:8]);
          dcu_send(wr_data[7:0]);
         
 end
endtask
        

//====================================================
//Tasks: DSU read a word
//====================================================        
task dcu_rd_reg (
                 input [31:0] rd_addr,
                 output[31:0] rd_data
                  );
  reg [7:0] dcu_rx_data;
  reg [31:0] tmp_rd_data;
  reg [1:0] dcu_rx_error;
  begin
          dcu_send(8'h80);
          dcu_send(rd_addr[31:24]);
          dcu_send(rd_addr[23:16]);
          dcu_send(rd_addr[15:8]);
          dcu_send(rd_addr[7:0]);
         
           repeat (4) begin
           dcu_monitor (dcu_rx_data, dcu_rx_error);
           tmp_rd_data = {tmp_rd_data[23:0], dcu_rx_data};
           $display("[DCU MONITOR] DCU Port: RX Data:%h; Error_status:(%b)",dcu_rx_data,dcu_rx_error);
           end
           rd_data = tmp_rd_data;
           
  end
endtask       


//====================================================
//Tasks: send a char through DSU_tx port
//====================================================

//DSU Send Data Task
//-----------------------------------------------------------
task dcu_send (                       
        input   [7:0]   tx_char        //sent byte
        );
  reg [9:0]    tx_data;
  integer       m;
  parameter baud = 8681; //ns
begin        
        tx_data = {1'b1, tx_char, 1'b0}; 
        for(m=0;m<10;m=m+1)
        begin
            repeat (baud) #1000ps;
            `TB_TOP.xdcu_rxd_reg = tx_data[m];
        end
        $display("[DCU MONITOR] DCU sends Byte=%h End.",tx_char);
end
endtask

//===============================================
//task: Recieve a char through dsu_rx port
//===============================================
task dcu_monitor(
      output  [7:0]   rx_data,
      output  [1:0]   rx_err  
       );

  reg [7:0]       data;
  integer         k;
  parameter baud = 8681; //ns
begin
    rx_err = 2'b00;

    @(negedge `TB_TOP.xdcu_txd);  //start bit
    repeat (baud/2) #1000ps;

    //received data
    for(k=0;k<8;k=k+1)
    begin
       repeat (baud) #1000ps;
       data[k] = `TB_TOP.xdcu_txd;
    end      
       
    repeat (baud) #1000ps;
    if(`TB_TOP.xdcu_txd != 1'b1)   rx_err[1] = 1'b1;
       
    $display("[DCU MONITOR] DCU receives a char:%h (%b)",data,rx_err);
    rx_data = data;
       
end
endtask
*/


