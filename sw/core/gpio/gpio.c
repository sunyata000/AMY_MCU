/**************************************************************************/


/**************************************************************************/
#include "amy.h"                                                 
#include "gpio.h"  

volatile uint32_t p0_counter  = 0;
volatile uint32_t p1_counter  = 0;
volatile uint32_t p2_counter  = 0;
volatile uint32_t p3_counter  = 0;



/**************************************************************************/
/*!
    @brief Initialises GPIO and enables the GPIO interrupt
           handler for the first 8 GPIO ports.
*/
/**************************************************************************/
 void GPIOInit ( void )
{
    /* Set up NVIC when I/O pins are configured as external interrupts. */
    NVIC_EnableIRQ ( GPIO_IRQn );
	
	/* set all pins as input mode. */	
	AMY_GPIO->DATDIR = 0x00000000; 
	
    return;
}


/**************************************************************************/
/*!
    @brief IRQ Handler for GPIO port (currently checks pin 0)
*/
/**************************************************************************/
void GPIO0_IRQHandler ( void )
{
    uint32_t regVal;

    regVal = GPIOIntStatus (0 );
    if ( regVal )
    {
        p0_counter++;
        GPIOIntClear ( 0 );
    }
    return;
}




