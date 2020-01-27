
#include <stdio.h>
#include <string.h>

#include "amy.h" 				  
#include "uart.h"
  
 int main (void)
 {	  
		

 int days = 360;
 char c, s[20], *p;
 int a = 1234, *i;
 
 unsigned char b = 0xd3;
 int e = 0x4dc5;

 		
          printf ("a(1234)= %x\n", a);
          printf ("b(0xd3)= %x, %d\n", b, b);
          printf ("e(0x4dc5)= %x, %d\n", e, e);		


           p = "How do you do";
           strcpy (s, "Hello, Amy.");
           *i = 12;
           c = '\x41';

          printf ("[SW TEST] start the test program: hello_test!\n"); 
          printf ("\n");

          printf("%s\n", "this is c language");
   	   
          printf ("a= %x\n", a);	 
          printf ("%d \n", a);

          printf ("i = %p\n", i);

          printf ("c = %c\n", c);
          printf ("c = %x\n", c);

          printf ("s[] = %s\n", s);
          printf ("s[] = %6.9s\n", s);

          printf ("s = %p\n", s);
          printf ("*p = %s\n", p);
     

         printf ("\n");
         printf ("\n");
         sprintf (s, "I= %x\n", i); 
	     puts (s);
	     printf ("\n");	
         sprintf (s, "i=  %d\n", i);	
         puts (s);	

	     printf ("\n");			
	     printf ("%d \n", i);
         printf("10 bytes: [%10d]\n",i);   	
         printf ("%x \n", i);		  

	  		  
         printf ("\n");	
         printf ("\n");
         printf("%s", "this is c ");
         printf("language\t");
         printf("author is %s\n","XSP");			
         printf ("\n");

 	 
        printf ("\n");
        printf("%f\n.",(float)days);
        printf("integer:%d\n. decimal:%f\n. science:%e\n",days,(float)days,(double)days);	  //??
        printf ("\n");

 
		   
        printf ("\n");
        printf ("Hello World!\n");
        printf ("\n");
        
        
//stop the program.
	     uartSendByte('~');
 	     while(1);
 


 }



