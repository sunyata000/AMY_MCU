				 
#include <stdio.h>

#include "amy.h"
#include "uart.h"




int main (void)
{
	   		 
        int baudrate = 115200;
		int br_word_scale; 

       int i = 4;
		int m = -3;
		int n = 0;
		n = i / m;
		printf ("n = %d.\n", n); 


	    br_word_scale = (int)(((CFG_CPU_CCLK * 10) / ((int)baudrate * 8)) - 5) / 10;
		printf ("%x.\n", br_word_scale);

//	br_word_scale = ((int)CFG_CPU_CCLK) / ((int)baudrate * 8) - 1;

//stop the program.
        uartSendByte('~');
        while(1);
}


