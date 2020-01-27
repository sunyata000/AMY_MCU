
#include <string.h>

#include "amy.h"   
#include "uart.h"
	  
  
void uartSendByte (uint8_t byte)
{
	//waiting for TX fifo ready
	while(UART0_TX_READY(AMY_UART0->STS) ==0);

    UART0_PUT_CHAR(byte);
        
   //waiting for TX fifo empty
   while(!UART0_TX_EMPTY(AMY_UART0->STS));   
 
}

int puts(const char * str)
{
  while(*str) uartSendByte(*str++);
  return 0;
}

  
 int main (void)
 {	  
    
  
 /*=================================== */
 /*UART initialization.                */	 
 /*=================================== */

    /* clear status	*/
    UART0_PUT_STATUS(0);   	
    /* define baudrate. 115200 baudrate. 50Mhz system clock	*/
    UART0_PUT_SCAL(50);	
	/* enable rx and tx. no interrupt */
    UART0_PUT_CTRL(0x3); 
    /* clear status	*/
    UART0_PUT_STATUS(0); 

    puts ("[AMY BOOT]: MCU is in boot mode. Ready to receive the code!\n"); 
    

//stop the program.
	     uartSendByte('~');
 	     while(1);
 


 }



