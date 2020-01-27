
#include "amy.h" 
#include "uart.h"


#include <stdio.h>
#include <string.h>

int main(void)
{
 //byte variable. 4byte operation.
    unsigned char i, j, k1, k2, k3 ;

    i = 0x5A;     //    0101 1010    --5A
    j = 0x9B;     //    1001 1011    --9B
    k1 = ~i;      //    1010 0101    --A5
    k2 = i << 2;  //(01)0110 1000    --68
    k3 = j >> 2;  //    0010 0110(11)--26

	printf ("\n");
	printf ("start the test program: logic_test!\n");
 
    printf("AND: 5A & 9B = (1A): %x \n", i & j);  //1A 
    printf("OR: 5A | 9B =(DB): %x \n", i | j);  //DB  
    printf("XOR: 5A ^ 9B = (C1): %x \n", i ^ j);  //C1 

    printf("NOT: 5A =(A5): %x\n", k1);        //A5	   
    printf("LEFT SHIFT 2BIT: 5A << 2 = (68): %x\n", k2);     //168  
    printf("RIGHT SHIFT 2BIT: 9B >> 2 =(26): %x\n", k3);     //26


    printf("NOT: 5A = (FFFF_FFA5): %x\n", ~i);        //FFFF FFA5	
    printf("L_SHIFT_2: A << 2 =(0000_0168): %x\n", i << 2); //0000 0168 
    printf("R_SHIFT_2: B >> 2 = (0000_0026): %x\n", j >> 2); //0000 0026

 
	printf ("End the test program: logic_test!\n");

//stop the program.
        uartSendByte('~');
        while(1);
}


