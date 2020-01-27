#include <stdarg.h>               // Variable argument definitions

#include "amy.h"
#include "uart.h"

//static uart_pcb_t pcb;

void uartInit(uint32_t baudrate)
{
    uint32_t ctrl_word = 0x3;
    uint32_t br_word_scale = 0;

	br_word_scale = ((int)CFG_CPU_CCLK) / ((int)baudrate * 8) - 1;

    /* Disable UART control register 			*/
    UART0_PUT_CTRL(0);
	
    /* clear status	*/
    UART0_PUT_STATUS(0);
	
    /* define baudrate					*/
    UART0_PUT_SCAL(br_word_scale);			  
 
	/* enable rx interrupt, tx use polling mode
	   no parity check*/
 	ctrl_word |= AMY_REG_UART_CTRL_RI;	
	
    UART0_PUT_CTRL(ctrl_word);

}

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



