#include <stdio.h>
#include <string.h>

#include "amy.h" 
#include "uart.h"




fail(int dev)
  {                                                                
    printf("\n");
    printf("test failed at %x\n", dev); 
  }




struct addcase {
        signed  addend1;
        signed  addend2;
        signed  sum;
};

volatile struct addcase adda[] = { { 1, 2, 3}, { 2, -2, 0}, { 0,  -1, -1},
        { 0x7fffffff, 1, 0}, {  0x7fffffff, 3, 2}, { 0x7fffffff,  -1, 0x7ffffffe}, 
        { -2, -3, -5}, { 0, 0, 0}, {0,  0, 9}};


struct mulcase {
        int     fac1;
        int     fac2;
        int     res;
};

volatile struct mulcase mula[] = { { 2, 3, 6}, { 2, -3, -6}, { 0,  1, 0},
        { 0, -1, 0}, {  1, -1, -1}, { -1,  1, -1}, { -2,  3, -6},
        { -2, -3, 6}, {  0,  0, 9}};


struct divcase {
        int     num;
        int     denom;
        int     res;
};

volatile struct divcase diva[] = {
        {  2,  3, 0}, { 3, -2, -1}, {  2, -3, 0}, {  0,  1, 0}, {  0, -1, 0}, {  1, -1, -1},
        { -1,  1, -1}, { -2,  3, 0}, { -2, -3, 0}, {9, 7, 1}, 
        { -9, 2, -4}, {-8, 2, -4}, {-8, -4, 2}, {8, -4, -2}, {-8, -8 , 1},
        {-8, -9, 0}, {11, 2, 5}, {47, 2, 23}, 
        { 12345,  679, 12345/679}, { -63636,  77, -63636/77},
        { 12345,  -679, -12345/679}, { -63636,  -77, 63636/77},
        { 145,  -6079, 0}, { -636,  -77777, 0}, { 63226,  7227777, 0},
        {  0,  0, 0}
 };

struct udivcase {
        unsigned int    num;
        unsigned int    denom;
        unsigned int    res;
};

volatile struct udivcase udiva[] = {
        {  2,  3, 0}, {  0,  1, 0}, { 0xfffffffe,  3, 0xfffffffe/3},
        { 0xfffffffe,  3, 0xfffffffe/3}, { 0x700ffffe,  7, 0x700ffffe/7},
        {  0,  0, 0}
 };




 
int main (void)
{



        int i = 0;

       uartInit(CFG_UART_BAUDRATE);
										  
printf ("//------------------------\n");
printf (" Start the ALU_TEST.\n");
printf ("//------------------------\n");


 
printf ("\n");
printf ("\n");
printf ("//------------------------\n");
printf ("//Adder test              \n");
printf ("//------------------------\n");        

       while (adda[i].sum != 9) {
                if ((adda[i].addend1 + adda[i].addend2) != adda[i].sum)   {
                   fail(i);     
                   printf("Result is: %x.  Expected is: %x.\n", adda[i].addend1 + adda[i].addend2,adda[i].sum);                                    
                   printf("\n");
                   }
                else
              printf("pass: %x + %x = %x.\n", adda[i].addend1, adda[i].addend2, adda[i].sum);
         i++;
       }


                               

printf ("\n");
printf ("\n");
printf ("//------------------------\n");
printf ("//Mulitplier test         \n");
printf ("//------------------------\n");        
       i = 0;
        while (mula[i].res != 9) {
            if ((mula[i].fac1 * mula[i].fac2) != mula[i].res) {
                fail(i);
                printf("Result is: %x.  Expected is: %x.\n", (mula[i].fac1 * mula[i].fac2), mula[i].res);                                          
                printf("\n");
                }
                else
              printf("pass: %x * %x = %x.\n", mula[i].fac1, mula[i].fac2, mula[i].res);
            i++;
        }
        
        
        
printf ("\n");
printf ("\n");
printf ("//------------------------\n");
printf ("//Divider test            \n");
printf ("//------------------------\n"); 
      i = 0;
    while (diva[i].denom != 0) {
            if ((diva[i].num / diva[i].denom) != diva[i].res) {
                fail(i);
                printf("Result is: %x.  Expected is: %x.\n", (diva[i].num / diva[i].denom), diva[i].res);                                          
                printf("\n");
                }
                else
              printf("pass: %x / %x = %x.\n", diva[i].num, diva[i].denom, diva[i].res);
            i++;
        } 


printf ("\n");
printf ("\n");
printf ("//------------------------\n");
printf ("//Unsigned Divider test   \n");
printf ("//------------------------\n");        
        i = 0;
        while (udiva[i].denom != 0) {
            if ((udiva[i].num / udiva[i].denom) != udiva[i].res) {
                fail(i);
                printf("Result is: %x.  Expected is: %x.\n", (udiva[i].num / udiva[i].denom), udiva[i].res);                                          
                printf("\n");
                }
                else
              printf("pass: %x / %x = %x.\n", udiva[i].num, udiva[i].denom, diva[i].res);
            i++;
        }






//stop the program.
        uartSendByte('~');
        while(1);
}


