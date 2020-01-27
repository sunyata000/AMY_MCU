//******************************************************************************
//
//******************************************************************************


`include "PODES_M0A_reg_define.h"
`include "AMY_reg_define.h"


module testcase ();

reg [31:0] rd_data;
reg c_halt;

initial
begin
    ahb_idle (20);
//===============================================
//Hold on CPU
//===============================================
  c_halt = 1'b1;
  ahb_reg_read (`DHCSR   , 4'b1111, rd_data );
  rd_data[1] = c_halt;
  rd_data[31:16] = 16'ha05f;
  ahb_reg_write (`DHCSR , 4'b1111, rd_data);
  

//====================================================    
//read back all registers' default value
//====================================================    

    ahb_reg_read_cmp (`ACTLR , 4'b1111, `INIT_VAL_ACTLR);
    ahb_reg_read_cmp (`CPUID , 4'b1111, `INIT_VAL_CPUID );
    ahb_reg_read_cmp (`ICSR  , 4'b1111, `INIT_VAL_ICSR  );
    ahb_reg_read_cmp (`AIRCR , 4'b1111, `INIT_VAL_AIRCR );
    ahb_reg_read_cmp (`SCR   , 4'b1111, `INIT_VAL_SCR   );
    ahb_reg_read_cmp (`CCR   , 4'b1111, `INIT_VAL_CCR   );
    ahb_reg_read_cmp (`SHPR2 , 4'b1111, `INIT_VAL_SHPR2 );
    ahb_reg_read_cmp (`SHPR3 , 4'b1111, `INIT_VAL_SHPR3 );
    ahb_reg_read_cmp (`SHCSR , 4'b1111, `INIT_VAL_SHCSR );
    ahb_reg_read_cmp (`DFSR  , 4'b1111, `INIT_VAL_DFSR  );
    
//sysTick
  ahb_reg_read_cmp (`SYST_CSR      , 4'b1111, `INIT_VAL_SYST_CSR   );
  ahb_reg_read_cmp (`SYST_RVR      , 4'b1111, `INIT_VAL_SYST_RVR   );
  ahb_reg_read_cmp (`SYST_CVR      , 4'b1111, `INIT_VAL_SYST_CVR   );
  ahb_reg_read_cmp (`SYST_CALIB    , 4'b1111, `INIT_VAL_SYST_CALIB );

//NIVC
     ahb_reg_read_cmp (`NVIC_ISER  , 4'b1111, `INIT_VAL_NVIC_ISER );
     ahb_reg_read_cmp (`NVIC_ICER  , 4'b1111, `INIT_VAL_NVIC_ICER );
     ahb_reg_read_cmp (`NVIC_ISPR  , 4'b1111, `INIT_VAL_NVIC_ISPR );
     ahb_reg_read_cmp (`NVIC_ICPR  , 4'b1111, `INIT_VAL_NVIC_ICPR );
     ahb_reg_read_cmp (`NVIC_IPR0  , 4'b1111, `INIT_VAL_NVIC_IPR0 );
     ahb_reg_read_cmp (`NVIC_IPR1  , 4'b1111, `INIT_VAL_NVIC_IPR1 );
     ahb_reg_read_cmp (`NVIC_IPR2  , 4'b1111, `INIT_VAL_NVIC_IPR2 );
     ahb_reg_read_cmp (`NVIC_IPR3  , 4'b1111, `INIT_VAL_NVIC_IPR3 );
     ahb_reg_read_cmp (`NVIC_IPR4  , 4'b1111, `INIT_VAL_NVIC_IPR4 );
     ahb_reg_read_cmp (`NVIC_IPR5  , 4'b1111, `INIT_VAL_NVIC_IPR5 );
     ahb_reg_read_cmp (`NVIC_IPR6  , 4'b1111, `INIT_VAL_NVIC_IPR6 );
     ahb_reg_read_cmp (`NVIC_IPR7  , 4'b1111, `INIT_VAL_NVIC_IPR7 );

//Debug
    ahb_reg_read_cmp (`DHCSR   , 4'b1111, `INIT_VAL_DHCSR );
    ahb_reg_read_cmp (`DCRSR   , 4'b1111, `INIT_VAL_DCRSR );
    ahb_reg_read_cmp (`DCRDR   , 4'b1111, `INIT_VAL_DCRDR );
    ahb_reg_read_cmp (`DEMCR   , 4'b1111, `INIT_VAL_DEMCR );

//DWT
    ahb_reg_read_cmp (`DWT_CTRL     , 4'b1111, `INIT_VAL_DWT_CTRL );
    ahb_reg_read_cmp (`DWT_PCSR     , 4'b1111, `INIT_VAL_DWT_PCSR );
    ahb_reg_read_cmp (`DWT_COMP0    , 4'b1111, `INIT_VAL_DWT_COMP0);
    ahb_reg_read_cmp (`DWT_MASK0    , 4'b1111, `INIT_VAL_DWT_MASK0);
    ahb_reg_read_cmp (`DWT_FUNC0    , 4'b1111, `INIT_VAL_DWT_FUNC0);
    ahb_reg_read_cmp (`DWT_COMP1    , 4'b1111, `INIT_VAL_DWT_COMP1);
    ahb_reg_read_cmp (`DWT_MASK1    , 4'b1111, `INIT_VAL_DWT_MASK1);
    ahb_reg_read_cmp (`DWT_FUNC1    , 4'b1111, `INIT_VAL_DWT_FUNC1);

//BPU
    ahb_reg_read_cmp (`BP_CTRL     , 4'b1111, `INIT_VAL_BP_CTRL  );
    ahb_reg_read_cmp (`BP_COMP0    , 4'b1111, `INIT_VAL_BP_COMP0 );
    ahb_reg_read_cmp (`BP_COMP1    , 4'b1111, `INIT_VAL_BP_COMP1 );
    ahb_reg_read_cmp (`BP_COMP2    , 4'b1111, `INIT_VAL_BP_COMP2 );
    ahb_reg_read_cmp (`BP_COMP3    , 4'b1111, `INIT_VAL_BP_COMP3 );


//UART0
    ahb_reg_read_cmp (`UART0_DATA     , 4'b1111, `INIT_VAL_UART0_DATA   );
    ahb_reg_read_cmp (`UART0_STATUS   , 4'b1111, `INIT_VAL_UART0_STATUS );
    ahb_reg_read_cmp (`UART0_CTRL     , 4'b1111, `INIT_VAL_UART0_CTRL   );
    ahb_reg_read_cmp (`UART0_SCALER   , 4'b1111, `INIT_VAL_UART0_SCALER );
    ahb_reg_read_cmp (`UART0_FIFO     , 4'b1111, `INIT_VAL_UART0_FIFO   );
    
   $display ("[TESTCASE] Register default value checking is done!, @%0d", $time); 
   $finish; 
    
end


endmodule