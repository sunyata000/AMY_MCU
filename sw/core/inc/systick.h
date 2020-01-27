/*****************************************************************************
 *   systick.h:  systick Header file for PODES_M0 Family 
 *   Microprocessor IP.
 *
 *   History
 *   2009.04.01  ver 1.00    Preliminary version, first Release
 *
******************************************************************************/
#ifndef _SYSTICK_H_
#define _SYSTICK_H_

void SysTick_Handler (void);

void systickInit (uint32_t delayMs);

void systickDelay (uint32_t delayTicks) ;

uint32_t systickGetTicks(void);


#endif
