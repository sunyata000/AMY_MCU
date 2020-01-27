#include "amy.h"
#include "systemConfig.h"
#include <stdio.h>

 uint32_t  systickNum;

 int main (void)
 {

  systickInit((CFG_CPU_CCLK / 1000/2) * CFG_SYSTICK_DELAY_IN_MS);	 //0.5ms
  uartInit(CFG_UART_BAUDRATE);

    puts ("start the test program: systick_test!\n");
    
	//Check the SysTick exception.			   
 	while(1){
	  systickNum = systickGetTicks();
      if (systickNum == 5) 
      //stop the program.
	     uartSendByte('~');
 	}
 }
