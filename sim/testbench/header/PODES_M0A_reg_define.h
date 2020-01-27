
//-----------------------------
//register address
//-----------------------------

`define ACTLR      32'he000e008
`define CPUID      32'he000ed00
`define ICSR       32'he000ed04
`define AIRCR      32'he000ed0c
`define SCR        32'he000ed10
`define CCR        32'he000ed14
`define SHPR2      32'he000ed1c
`define SHPR3      32'he000ed20
`define SHCSR      32'he000ed24
`define DFSR       32'he000ed30

//sysTick
`define SYST_CSR      32'he000e010
`define SYST_RVR      32'he000e014
`define SYST_CVR      32'he000e018
`define SYST_CALIB    32'he000e01c

//NIVC
`define NVIC_ISER        32'he000e100  
`define NVIC_ICER        32'he000e180  
`define NVIC_ISPR        32'he000e200  
`define NVIC_ICPR        32'he000e280  
`define NVIC_IPR0        32'he000e400  
`define NVIC_IPR1        32'he000e404  
`define NVIC_IPR2        32'he000e408  
`define NVIC_IPR3        32'he000e40c  
`define NVIC_IPR4        32'he000e410  
`define NVIC_IPR5        32'he000e414  
`define NVIC_IPR6        32'he000e418  
`define NVIC_IPR7        32'he000e41c

//Debug
`define DHCSR        32'he000edf0  
`define DCRSR        32'he000edf4  
`define DCRDR        32'he000edf8  
`define DEMCR        32'he000edfc  

//DWT
`define DWT_CTRL         32'he0001000  
`define DWT_PCSR         32'he000101c
`define DWT_COMP0        32'he0001020  
`define DWT_MASK0        32'he0001024  
`define DWT_FUNC0        32'he0001028  
`define DWT_COMP1        32'he0001030  
`define DWT_MASK1        32'he0001034  
`define DWT_FUNC1        32'he0001038  

//BPU
`define BP_CTRL         32'he0002000   
`define BP_COMP0        32'he0002008  
`define BP_COMP1        32'he000200c  
`define BP_COMP2        32'he0002010  
`define BP_COMP3        32'he0002014  





//----------------------------------
//register default value
//----------------------------------
`define INIT_VAL_ACTLR      32'h00000000
`define INIT_VAL_CPUID      32'h410cc200
`define INIT_VAL_ICSR       32'h00000000
`define INIT_VAL_AIRCR      32'h00000000
`define INIT_VAL_SCR        32'h00000000
`define INIT_VAL_CCR        32'h00000208
`define INIT_VAL_SHPR2      32'h00000000
`define INIT_VAL_SHPR3      32'h00000000
`define INIT_VAL_SHCSR      32'h00000000
`define INIT_VAL_DFSR       32'h00000000


`define INIT_VAL_SYST_CSR      32'h00000004
`define INIT_VAL_SYST_RVR      32'h00000000
`define INIT_VAL_SYST_CVR      32'h00000000
`define INIT_VAL_SYST_CALIB    32'hc007a120



`define INIT_VAL_NVIC_ISER        32'h00000000  
`define INIT_VAL_NVIC_ICER        32'h00000000  
`define INIT_VAL_NVIC_ISPR        32'h00000000  
`define INIT_VAL_NVIC_ICPR        32'h00000000  
`define INIT_VAL_NVIC_IPR0        32'h00000000  
`define INIT_VAL_NVIC_IPR1        32'h00000000  
`define INIT_VAL_NVIC_IPR2        32'h00000000  
`define INIT_VAL_NVIC_IPR3        32'h00000000  
`define INIT_VAL_NVIC_IPR4        32'h00000000  
`define INIT_VAL_NVIC_IPR5        32'h00000000  
`define INIT_VAL_NVIC_IPR6        32'h00000000  
`define INIT_VAL_NVIC_IPR7        32'h00000000


`define INIT_VAL_DHCSR        32'h01000001  
`define INIT_VAL_DCRSR        32'h00000000  
`define INIT_VAL_DCRDR        32'h00000000  
`define INIT_VAL_DEMCR        32'h00000000  


//DWT
`define INIT_VAL_DWT_CTRL         32'h20000000  
`define INIT_VAL_DWT_PCSR         32'h00000000
`define INIT_VAL_DWT_COMP0        32'h00000000  
`define INIT_VAL_DWT_MASK0        32'h00000010  
`define INIT_VAL_DWT_FUNC0        32'h00000000  
`define INIT_VAL_DWT_COMP1        32'h00000000  
`define INIT_VAL_DWT_MASK1        32'h00000010  
`define INIT_VAL_DWT_FUNC1        32'h00000000  

//BPU
`define INIT_VAL_BP_CTRL         32'h00000040   
`define INIT_VAL_BP_COMP0        32'h00000000  
`define INIT_VAL_BP_COMP1        32'h00000000  
`define INIT_VAL_BP_COMP2        32'h00000000  
`define INIT_VAL_BP_COMP3        32'h00000000  
