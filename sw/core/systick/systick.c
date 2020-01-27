#include "amy.h"  
#include <stdio.h>

volatile uint32_t systickTicks = 0;
volatile uint32_t systickRollovers = 0;

/**************************************************************************/
/*! 
    @brief SysTick interrupt handler
*/
/**************************************************************************/	 
void SysTick_Handler (void)
{
  systickTicks++;				
  printf("SysTick Interrupt Number is: %d.\n", systickTicks); //For debugging test
   // Increment roll over counter
  if (systickTicks == 0xFFFFFFFF) systickRollovers++;

}

void systickInit (uint32_t ticks)		  
{
  // Check if 'ticks' is greater than maximum value
  if (ticks > SYSTICK_STRELOAD_MASK)
  {
    return;
  }

  // Reset counter
  systickTicks = 0;
                     
  // Set reload register
  SYSTICK_STRELOAD  = (ticks & SYSTICK_STRELOAD_MASK) - 1;

  // Load the systick counter value
  SYSTICK_STCURR = 0;

  // Enable systick IRQ and timer
  SYSTICK_STCTRL = SYSTICK_STCTRL_CLKSOURCE |
                   SYSTICK_STCTRL_TICKINT |
                   SYSTICK_STCTRL_ENABLE;
}

/**************************************************************************/
/*! 
    @brief      Causes a blocking delay for 'delayTicks' ticks on the
                systick timer.  For example: systickDelay(100) would cause
                a blocking delay for 100 ticks of the systick timer.

    @param[in]  delayTicks
                The number of systick ticks to cause a blocking delay for

    @Note       This function takes into account the fact that the tick
                counter may eventually roll over to 0 once it reaches
                0xFFFFFFFF.
*/
/**************************************************************************/
void systickDelay (uint32_t delayTicks) 
{
  uint32_t curTicks;
  curTicks = systickTicks;

  // Make sure delay is at least 1 tick in case of division, etc.
  if (delayTicks == 0) delayTicks = 1;

  if (curTicks > 0xFFFFFFFF - delayTicks)
  {
    // Roll over will occur during delay
    while (systickTicks >= curTicks)
    {
      while (systickTicks < (delayTicks - (0xFFFFFFFF - curTicks)));
    }      
  }
  else
  {
    while ((systickTicks - curTicks) < delayTicks);
  }
}

/**************************************************************************/
/*! 
    @brief      Returns the current value of the sysTick timer counter. 
                This value is incremented by one every time an interrupt
                fires for the sysTick timer.
*/
/**************************************************************************/
uint32_t systickGetTicks(void)
{
  return systickTicks;
}



