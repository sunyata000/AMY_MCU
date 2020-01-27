;/**************************************************************************//**
; * @file     startup_AMY.s
; * @brief    CMSIS Cortex-M0 Core Device Startup File
; *           for the PODES_M0 Device Series
; * @version  V0.9
; * @date     24. August 2013
; *------- <<< Use Configuration Wizard in Context Menu >>> ------------------
; *
; * @note
; * Copyright (C) 2009-2010 ARM Limited. All rights reserved.
; *
; * @par
; * ARM Limited (ARM) is supplying this software for use with Cortex-M 
; * processor based microcontrollers.  This file can be freely distributed 
; * within development tools that are supporting such ARM based processors. 
; *
; * @par
; * THIS SOFTWARE IS PROVIDED "AS IS".  NO WARRANTIES, WHETHER EXPRESS, IMPLIED
; * OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF
; * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE APPLY TO THIS SOFTWARE.
; * ARM SHALL NOT, IN ANY CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL, OR
; * CONSEQUENTIAL DAMAGES, FOR ANY REASON WHATSOEVER.
; *
; ******************************************************************************/


; <h> Stack Configuration
;   <o> Stack Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Stack_Size      EQU     0x00000200

                AREA    STACK, NOINIT, READWRITE, ALIGN=3
Stack_Mem       SPACE   Stack_Size		  ;Reserve a 0-filled memory block.
__initial_sp


; <h> Heap Configuration
;   <o>  Heap Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Heap_Size       EQU     0x00000200

                AREA    HEAP, NOINIT, READWRITE, ALIGN=3
__heap_base
Heap_Mem        SPACE   Heap_Size
__heap_limit


                PRESERVE8
                THUMB


; Vector Table Mapped to Address 0 at Reset

                AREA    RESET, DATA, READONLY
                EXPORT  __Vectors
                EXPORT  __Vectors_End
                EXPORT  __Vectors_Size

__Vectors       DCD     __initial_sp              ; Top of Stack
                DCD     Reset_Handler             ; Reset Handler
                DCD     NMI_Handler               ; NMI Handler
                DCD     HardFault_Handler         ; Hard Fault Handler
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     SVC_Handler               ; SVCall Handler
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     PendSV_Handler            ; PendSV Handler
                DCD     SysTick_Handler           ; SysTick Handler

                ; External Interrupts
                DCD    UART0_IRQHandler         ; 16+ 0: UART0
                DCD    UART1_IRQHandler         ; 16+ 1: UART1
                DCD    IIC_IRQHandler           ; 16+ 2: IIC
                DCD    APBKEY_IRQHandler        ; 16+ 3: APBKEY
                DCD    GPIO_IRQHandler          ; 16+ 4: GPIO
                DCD    STN_IRQHandler           ; 16+ 5: STN
                DCD    PWM_IRQHandler           ; 16+ 6: PWM

                DCD    RSV0_IRQHandler         ; 
                DCD    RSV1_IRQHandler         ; 
                DCD    RSV2_IRQHandler         ; 
                DCD    RSV3_IRQHandler         ; 
                DCD    RSV4_IRQHandler         ; 
                DCD    RSV5_IRQHandler         ; 
                DCD    RSV6_IRQHandler         ;
                DCD    RSV7_IRQHandler         ;
                DCD    RSV8_IRQHandler         ;
                DCD    RSV9_IRQHandler         ;
                DCD    RSV10_IRQHandler        ;
                DCD    RSV11_IRQHandler        ;
                DCD    RSV12_IRQHandler        ;
                DCD    RSV13_IRQHandler        ;
                DCD    RSV14_IRQHandler        ;
                DCD    RSV15_IRQHandler        ;
                DCD    RSV16_IRQHandler        ;
                DCD    RSV17_IRQHandler        ;
                DCD    RSV18_IRQHandler        ;
                DCD    RSV19_IRQHandler        ;
                DCD    RSV20_IRQHandler        ;
                DCD    RSV21_IRQHandler        ;
                DCD    RSV22_IRQHandler        ;
                DCD    RSV23_IRQHandler        ;
                DCD    RSV24_IRQHandler        ;
__Vectors_End

__Vectors_Size 	EQU 	__Vectors_End - __Vectors


                IF      :LNOT::DEF:NO_CRP		;if not define NO_CRP
                AREA    |.ARM.__at_0x02FC|, CODE, READONLY
CRP_Key         DCD     0xFFFFFFFF
                ENDIF


                AREA    |.text|, CODE, READONLY


; Reset Handler

Reset_Handler   PROC
                EXPORT  Reset_Handler             [WEAK]
                IMPORT  SystemInit
                IMPORT  __main
                LDR     R0, =SystemInit		   
                BLX     R0
                LDR     R0, =__main			  
                BX      R0
                ENDP


; Dummy Exception Handlers (infinite loops which can be modified)                

NMI_Handler     PROC
                EXPORT  NMI_Handler               [WEAK]
                B       .
                ENDP
HardFault_Handler\
                PROC
                EXPORT  HardFault_Handler         [WEAK]
                B       .
                ENDP
SVC_Handler     PROC
                EXPORT  SVC_Handler               [WEAK]
                B       .
                ENDP
PendSV_Handler  PROC
                EXPORT  PendSV_Handler            [WEAK]
                B       .
                ENDP
SysTick_Handler PROC
                EXPORT  SysTick_Handler           [WEAK]
                B       .
                ENDP

Default_Handler PROC

                EXPORT   UART0_IRQHandler    [WEAK]
                EXPORT   UART1_IRQHandler    [WEAK]
                EXPORT   IIC_IRQHandler      [WEAK]
                EXPORT   APBKEY_IRQHandler   [WEAK]
                EXPORT   GPIO_IRQHandler     [WEAK]
                EXPORT   STN_IRQHandler      [WEAK]
                EXPORT   PWM_IRQHandler      [WEAK]
               
                EXPORT    RSV0_IRQHandler     [WEAK]
                EXPORT    RSV1_IRQHandler     [WEAK]
                EXPORT    RSV2_IRQHandler     [WEAK]
                EXPORT    RSV3_IRQHandler     [WEAK]
                EXPORT    RSV4_IRQHandler     [WEAK]
                EXPORT    RSV5_IRQHandler     [WEAK]
                EXPORT    RSV6_IRQHandler     [WEAK]
                EXPORT    RSV7_IRQHandler     [WEAK]
                EXPORT    RSV8_IRQHandler     [WEAK]
                EXPORT    RSV9_IRQHandler     [WEAK]
                EXPORT    RSV10_IRQHandler    [WEAK]
                EXPORT    RSV11_IRQHandler    [WEAK]
                EXPORT    RSV12_IRQHandler    [WEAK]
                EXPORT    RSV13_IRQHandler    [WEAK]
                EXPORT    RSV14_IRQHandler    [WEAK]
                EXPORT    RSV15_IRQHandler    [WEAK]
                EXPORT    RSV16_IRQHandler    [WEAK]
                EXPORT    RSV17_IRQHandler    [WEAK]
                EXPORT    RSV18_IRQHandler    [WEAK]
                EXPORT    RSV19_IRQHandler    [WEAK]
                EXPORT    RSV20_IRQHandler    [WEAK]
                EXPORT    RSV21_IRQHandler    [WEAK]
                EXPORT    RSV22_IRQHandler    [WEAK]
                EXPORT    RSV23_IRQHandler    [WEAK]
                EXPORT    RSV24_IRQHandler    [WEAK]

UART0_IRQHandler    
UART1_IRQHandler    
IIC_IRQHandler      
APBKEY_IRQHandler   
GPIO_IRQHandler     
STN_IRQHandler      
PWM_IRQHandler      
RSV0_IRQHandler  
RSV1_IRQHandler  
RSV2_IRQHandler  
RSV3_IRQHandler  
RSV4_IRQHandler  
RSV5_IRQHandler  
RSV6_IRQHandler  
RSV7_IRQHandler  
RSV8_IRQHandler  
RSV9_IRQHandler  
RSV10_IRQHandler 
RSV11_IRQHandler 
RSV12_IRQHandler 
RSV13_IRQHandler 
RSV14_IRQHandler 
RSV15_IRQHandler 
RSV16_IRQHandler 
RSV17_IRQHandler 
RSV18_IRQHandler 
RSV19_IRQHandler 
RSV20_IRQHandler 
RSV21_IRQHandler 
RSV22_IRQHandler 
RSV23_IRQHandler 
RSV24_IRQHandler 
                B       .

                ENDP


                ALIGN


; User Initial Stack & Heap

                IF      :DEF:__MICROLIB		  ;if use the microlib.
                
                EXPORT  __initial_sp
                EXPORT  __heap_base
                EXPORT  __heap_limit
                
                ELSE
                
                IMPORT  __use_two_region_memory	  ;	 use two region memory model
                EXPORT  __user_initial_stackheap  ;	 user defines the stackheap.
__user_initial_stackheap					;set and return init stack and heap location.

                LDR     R0, =  Heap_Mem
                LDR     R1, =(Stack_Mem + Stack_Size)	   ;the values should be exchanged between R1 and R3?..
                LDR     R2, = (Heap_Mem +  Heap_Size)
                LDR     R3, = Stack_Mem
                BX      LR

                ALIGN

                ENDIF


                END
