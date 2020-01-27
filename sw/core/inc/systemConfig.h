/*****************************************************************************
 *   systemconfig.h:  system configuration Header file for PODES_M0 Family 
 *   Microprocessor IP.
 *
 *   History
 *   2009.04.01  ver 1.00    Prelimnary version, first Release
 *
******************************************************************************/
#ifndef _SYSCONFIG_H_
								  
#define _SYSCONFIG_H_


#define CFG_CPU_CCLK              (50000000) /*定义系统CPU工作时钟*/

#define CFG_SYSTICK_DELAY_IN_MS     (1)  /*配置每1ms产生多少个tick中断*/

//#define TEST_UART0_INTR										   

//#define TEST_SYSTICK

#define TEST_UART_SEND  	


//===============================================
//Define LED
//===============================================

#define OUT			1
#define IN			0
#define SET		        1
#define RESET		    0

#define LED_PIN         AMY_GPIO_P0
#define LED_PORT        AMY_GPIO_OUT_P


#define LED_DIR_OUT     GPIOSetDir(LED_PIN,OUT)
#define LED_ON		    GPIOSetValue(LED_PIN,RESET)
#define LED_OFF		    GPIOSetValue(LED_PIN,SET)
#define LED_TOG		    GPIO_TOGGLE(LED_PIN)


#endif

