
#include <stdio.h>
#include <string.h>

#include "amy.h"
 #include "gpio.h" 
 #include "uart.h"
 #include "systemConfig.h" 

  
 int main (void)
 {	  
		
		int i, j;
 	  
        uartInit(CFG_UART_BAUDRATE);
		GPIOInit ();

        printf("Start GPIO test.\n");	   
        printf ("\n");

		
        LED_DIR_OUT;                     //设置GPIO0为输出口
		
		j = 0;
        while(j < 20)
        {
	    	LED_TOG;                     //
			for (i = 0; i<100; i++);
			j ++; 
        }    
							  
//stop the program.
	     uartSendByte('~');
 	     while(1);
 


 }


 





