/*****************************************************************************
 *   amy.h:  amy Header file for a MCU implementation of PODES_M0 Family 
 *   Microprocessor IP.
 *
 *   History
 *   2009.04.01  ver 1.00    Preliminary version, first Release
 *
******************************************************************************/

#ifndef _AMY_H_
#define _AMY_H_

#include "type.h"
#include "systemConfig.h"
#include "systick.h"  
#include "uart.h" 
#include "gpio.h"

typedef volatile uint8_t  REG8;
typedef volatile uint16_t REG16;  
typedef volatile uint32_t REG32;
typedef unsigned char     byte_t;

#define pREG8  (REG8 *)
#define pREG16 (REG16 *)
#define pREG32 (REG32 *)

#ifndef NULL
#define NULL ((void *) 0)
#endif


/*##############################################################################
## GPIO
##############################################################################*/

#define OUT			1
#define IN			0

#define AMY_GPIO_BASE                      (0x40000400)

/*
 *  The following defines the AMY GPIO Registers.
 */
#define AMY_GPIO_OUT_P          (*(pREG32(AMY_GPIO_BASE + 0x00)))
#define AMY_GPIO_DIR_P          (*(pREG32(AMY_GPIO_BASE + 0x04)))
#define AMY_GPIO_INP_P          (*(pREG32(AMY_GPIO_BASE + 0x08)))
#define AMY_GPIO_INT_MOD_P      (*(pREG32(AMY_GPIO_BASE + 0x0c)))
#define AMY_GPIO_INT_ENB_P      (*(pREG32(AMY_GPIO_BASE + 0x10)))
#define AMY_GPIO_INT_STS_P      (*(pREG32(AMY_GPIO_BASE + 0x14)))


#define AMY_GPIO_P0             ((unsigned int) 0x00000001)
#define AMY_GPIO_P1             ((unsigned int) 0x00000002)
#define AMY_GPIO_P2             ((unsigned int) 0x00000004)
#define AMY_GPIO_P3             ((unsigned int) 0x00000008)
#define AMY_GPIO_P4             ((unsigned int) 0x00000010)
#define AMY_GPIO_P5             ((unsigned int) 0x00000020)
#define AMY_GPIO_P6             ((unsigned int) 0x00000040)
#define AMY_GPIO_P7             ((unsigned int) 0x00000080)
#define AMY_GPIO_ALL            ((unsigned int) 0xFFFFFFFF)

/*##############################################################################
## UART
##############################################################################*/
#define AMY_UART0_BASE                      (0x40000000)

/*
 *  The following defines the AMY UART Registers.
 */
#define AMY_UART0_DATA_P        (*(pREG32(AMY_UART0_BASE + 0x00)))
#define AMY_UART0_STATUS_P      (*(pREG32(AMY_UART0_BASE + 0x04)))
#define AMY_UART0_CTRL_P        (*(pREG32(AMY_UART0_BASE + 0x08)))
#define AMY_UART0_SCALAR_P      (*(pREG32(AMY_UART0_BASE + 0x0c)))

/*
 *  The following defines the bits in the AMY UART Status Registers.
 */

#define AMY_REG_UART_STATUS_DR   0x00000001 /* Data Ready */
#define AMY_REG_UART_STATUS_TSE  0x00000002 /* TX Send Register Empty */
#define AMY_REG_UART_STATUS_THE  0x00000004 /* TX Hold Register Empty */
#define AMY_REG_UART_STATUS_BR   0x00000008 /* Break Error */
#define AMY_REG_UART_STATUS_OE   0x00000010 /* RX Overrun Error */
#define AMY_REG_UART_STATUS_PE   0x00000020 /* RX Parity Error */
#define AMY_REG_UART_STATUS_FE   0x00000040 /* RX Framing Error */

/*
 *  The following defines the bits in the AMY UART Ctrl Registers.
 */

#define AMY_REG_UART_CTRL_RE     0x00000001 /* Receiver enable */
#define AMY_REG_UART_CTRL_TE     0x00000002 /* Transmitter enable */
#define AMY_REG_UART_CTRL_RI     0x00000004 /* Receiver interrupt enable */
#define AMY_REG_UART_CTRL_TI     0x00000008 /* Transmitter interrupt enable */
#define AMY_REG_UART_CTRL_PS     0x00000010 /* Parity select */
#define AMY_REG_UART_CTRL_PE     0x00000020 /* Parity enable */
#define AMY_REG_UART_CTRL_FL     0x00000040 /* Flow control enable */
#define AMY_REG_UART_CTRL_LB     0x00000080 /* Loop Back enable */
#define AMY_REG_UART_CTRL_ET     0x00000100 /* Use external clock */


#define UART0_GET_CHAR()         (AMY_UART0_DATA_P)
#define UART0_PUT_CHAR(v)        do { AMY_UART0_DATA_P = v;}while(0)
                                                            
#define UART0_GET_STATUS()       (AMY_UART0_STATUS_P)
#define UART0_PUT_STATUS(v)      do {AMY_UART0_STATUS_P = v;}while(0)
									
#define UART0_GET_CTRL()         (AMY_UART0_CTRL_P)
#define UART0_PUT_CTRL(v)        do { AMY_UART0_CTRL_P = v;}while(0)


#define UART0_GET_SCAL()         (AMY_UART0_SCALAR_P)
#define UART0_PUT_SCAL(v)        do {AMY_UART0_SCALAR_P = v;}while(0)

#define UART0_RX_DATA(s)         (((s) & AMY_REG_UART_STATUS_DR) != 0)
#define UART0_TX_READY(s)        (((s) & AMY_REG_UART_STATUS_THE) != 0)

#define UART0_TX_EMPTY(s)        (((s) & (AMY_REG_UART_STATUS_THE|AMY_REG_UART_STATUS_TSE)) == (AMY_REG_UART_STATUS_THE|AMY_REG_UART_STATUS_TSE))


#define MASK_UART0_TX_INTR()     do {  AMY_UART0_CTRL_P &= ~(1<<3);}while(0)

#define UNMASK_UART0_TX_INTR()   do {  AMY_UART0_CTRL_P |= (1<<3); }while(0)

#define MASK_UART0_RX_INTR()     do { AMY_UART0_CTRL_P &= ~(1<<2); }while(0)

#define UNMASK_UART0_RX_INTR()   do {  AMY_UART0_CTRL_P |= (1<<2); }while(0)





/*##############################################################################
## SCB registers
##############################################################################*/

#define SYSAUX_CTRL         (*(pREG32 (0xE000_E008)))

/*  CPU ID Base Register */
#define SCB_CPUID                                 (*(pREG32 (0xE000ED00)))
#define SCB_CPUID_REVISION_MASK                   ((unsigned int) 0x0000000F) // Revision Code
#define SCB_CPUID_PARTNO_MASK                     ((unsigned int) 0x0000FFF0) // Part Number
#define SCB_CPUID_CONSTANT_MASK                   ((unsigned int) 0x000F0000) // Constant
#define SCB_CPUID_VARIANT_MASK                    ((unsigned int) 0x00F00000) // Variant
#define SCB_CPUID_IMPLEMENTER_MASK                ((unsigned int) 0xFF000000) // Implementer

#define SCB_ICSR                                  (*(pREG32 (0xE000ED04)))
#define SCB_ICSR_NMIPENDSET_MASK                  ((unsigned int) 0x80000000)
#define SCB_ICSR_NMIPENDSET                       ((unsigned int) 0x80000000)
#define SCB_ICSR_PENDSVSET_MASK                   ((unsigned int) 0x10000000)
#define SCB_ICSR_PENDSVSET                        ((unsigned int) 0x10000000)
#define SCB_ICSR_PENDSVCLR_MASK                   ((unsigned int) 0x08000000)
#define SCB_ICSR_PENDSVCLR                        ((unsigned int) 0x08000000)
#define SCB_ICSR_PENDSTSET_MASK                   ((unsigned int) 0x04000000)
#define SCB_ICSR_PENDSTSET                        ((unsigned int) 0x04000000)
#define SCB_ICSR_PENDSTCLR_MASK                   ((unsigned int) 0x02000000)
#define SCB_ICSR_PENDSTCLR                        ((unsigned int) 0x02000000)
#define SCB_ICSR_ISRPREEMPT_MASK                  ((unsigned int) 0x00800000)
#define SCB_ICSR_ISRPREEMPT                       ((unsigned int) 0x00800000)
#define SCB_ICSR_ISRPENDING_MASK                  ((unsigned int) 0x00400000)
#define SCB_ICSR_ISRPENDING                       ((unsigned int) 0x00400000)
#define SCB_ICSR_VECTPENDING_MASK                 ((unsigned int) 0x001FF000)
#define SCB_ICSR_VECTACTIVE_MASK                  ((unsigned int) 0x000001FF)

/*  System Control Register */

#define SCB_SCR                                   (*(pREG32 (0xE000ED10)))
#define SCB_SCR_SLEEPONEXIT_MASK                  ((unsigned int) 0x00000002) // Enable sleep on exit
#define SCB_SCR_SLEEPONEXIT                       ((unsigned int) 0x00000002)
#define SCB_SCR_SLEEPDEEP_MASK                    ((unsigned int) 0x00000004)
#define SCB_SCR_SLEEPDEEP                         ((unsigned int) 0x00000004) // Enable deep sleep
#define SCB_SCR_SEVONPEND_MASK                    ((unsigned int) 0x00000010) // Wake up from WFE is new int is pended regardless of priority
#define SCB_SCR_SEVONPEND                         ((unsigned int) 0x00000010)



/*##############################################################################
## System Tick Timer
##############################################################################*/

#define SYSTICK_BASE_ADDRESS                      (0xE000E000)

/*  STCTRL (System Timer Control and status register)
    The STCTRL register contains control information for the System Tick Timer, and provides
    a status flag.  */

#define SYSTICK_STCTRL                            (*(pREG32 (0xE000E010)))    // System tick control
#define SYSTICK_STCTRL_ENABLE                     (0x00000001)    // System tick counter enable
#define SYSTICK_STCTRL_TICKINT                    (0x00000002)    // System tick interrupt enable
#define SYSTICK_STCTRL_CLKSOURCE                  (0x00000004)    // NOTE: This isn't documented but is based on NXP examples
#define SYSTICK_STCTRL_COUNTFLAG                  (0x00010000)    // System tick counter flag

/*  STRELOAD (System Timer Reload value register)
    The STRELOAD register is set to the value that will be loaded into the System Tick Timer
    whenever it counts down to zero. This register is loaded by software as part of timer
    initialization. The STCALIB register may be read and used as the value for STRELOAD if
    the CPU or external clock is running at the frequency intended for use with the STCALIB
    value.  */

#define SYSTICK_STRELOAD                          (*(pREG32 (0xE000E014)))    // System timer reload
#define SYSTICK_STRELOAD_MASK                     (0x00FFFFFF)

/*  STCURR (System Timer Current value register)
    The STCURR register returns the current count from the System Tick counter when it is
    read by software. */

#define SYSTICK_STCURR                            (*(pREG32 (0xE000E018)))
#define SYSTICK_STCURR_MASK                       (0x00FFFFFF)

/*  STCALIB (System Timer Calibration value register) */

#define SYSTICK_STCALIB                           (*(pREG32 (0xE000E01C)))    // System timer calibration
#define SYSTICK_STCALIB_TENMS_MASK                (0x00FFFFFF)
#define SYSTICK_STCALIB_SKEW_MASK                 (0x40000000)
#define SYSTICK_STCALIB_NOREF_MASK                (0x80000000)



/*##############################################################################
## Nested Vectored Interrupt Controller
##############################################################################*/

#define NVIC_BASE_ADDRESS                         (0xE000E100)

typedef struct
{
  volatile uint32_t ISER[8];                      /*!< Offset: 0x000  Interrupt Set Enable Register           */
     uint32_t RESERVED0[24];                                   
  volatile uint32_t ICER[8];                      /*!< Offset: 0x080  Interrupt Clear Enable Register         */
      uint32_t RSERVED1[24];                                    
  volatile uint32_t ISPR[8];                      /*!< Offset: 0x100  Interrupt Set Pending Register          */
     uint32_t RESERVED2[24];                                   
  volatile uint32_t ICPR[8];                      /*!< Offset: 0x180  Interrupt Clear Pending Register        */
     uint32_t RESERVED3[24];                                   
  volatile uint32_t IABR[8];                      /*!< Offset: 0x200  Interrupt Active bit Register           */
     uint32_t RESERVED4[56];                                   
  volatile uint8_t  IP[240];                      /*!< Offset: 0x300  Interrupt Priority Register (8Bit wide) */
    uint32_t RESERVED5[644];                                  
  volatile  uint32_t STIR;                        /*!< Offset: 0xE00  Software Trigger Interrupt Register     */
}  NVIC_Type;                                               

#define NVIC                                      ((NVIC_Type *) NVIC_BASE_ADDRESS)

typedef enum IRQn
{
/******  Cortex-M0 Processor Exceptions Numbers ***************************************************/
  NonMaskableInt_IRQn           = -14,    /*!< 2 Non Maskable Interrupt                           */
  HardFault_IRQn                = -13,    /*!< 3 Cortex-M0 Hard Fault Interrupt                   */
  SVCall_IRQn                   = -5,     /*!< 11 Cortex-M0 SV Call Interrupt                     */
  PendSV_IRQn                   = -2,     /*!< 14 Cortex-M0 Pend SV Interrupt                     */
  SysTick_IRQn                  = -1,     /*!< 15 Cortex-M0 System Tick Interrupt                 */

/******  AMY Specific Interrupt Numbers *******************************************************/
  UART0_IRQn                  = 0,        /*!< UART0 interrupt                                   */
  UART1_IRQn                  = 1,        /*!< UART1 interrupt                                   */
  IIC_IRQn                    = 2,
  APBKEY_IRQn                 = 3,
  GPIO_IRQn                   = 4,        /*!< 8 GPIO pins use same one interrupt                */   
  STN_IRQn                    = 5,        
  PWM_IRQn                    = 6,   
       
  RSV0_IRQn                   = 7, 	       
  RSV1_IRQn                   = 8, 	       
  RSV2_IRQn                   = 9,       
  RSV3_IRQn                   = 10,       
  RSV4_IRQn                   = 11,       
  RSV5_IRQn                   = 12,       
  RSV6_IRQn                   = 13,       
  RSV7_IRQn                   = 14,       
  RSV8_IRQn                   = 15,       
  RSV9_IRQn                   = 16,       
  RSV10_IRQn                  = 17,       
  RSV11_IRQn                  = 18,       
  RSV12_IRQn                  = 19,       
  RSV13_IRQn                  = 20,       
  RSV14_IRQn                  = 21,       
  RSV15_IRQn                  = 22,       
  RSV16_IRQn                  = 23,       
  RSV17_IRQn                  = 24,       
  RSV18_IRQn                  = 25,       
  RSV19_IRQn                  = 26,        
  RSV20_IRQn                  = 27,       
  RSV21_IRQn                  = 28,       
  RSV22_IRQn                  = 29,       
  RSV23_IRQn                  = 30,       
  RSV24_IRQn                  = 31, 
} IRQn_t;


static __inline void NVIC_EnableIRQ(IRQn_t IRQn)
{
  NVIC->ISER[((uint32_t)(IRQn) >> 5)] = (1 << ((uint32_t)(IRQn) & 0x1F));
}

static __inline void NVIC_DisableIRQ(IRQn_t IRQn)
{
  NVIC->ICER[((uint32_t)(IRQn) >> 5)] = (1 << ((uint32_t)(IRQn) & 0x1F));
}

void SystemInit (void);


#endif 
