/**************************************************************************/
/*   gpio.h:  gpio Header file for PODES_M0 Family 
 *   Microprocessor IP.
 *
 *   History
 *   2009.04.01  ver 1.00    Preliminary version, first Release
 */
/**************************************************************************/

#ifndef _GPIO_H_
#define _GPIO_H_


/**************************************************************************/
/*!
    Indicates GPIO direction.
    
*/
/**************************************************************************/
typedef enum gpioDirection_e
{
    gpioDirection_Input = 0,
    gpioDirection_Output 
}
gpioDirection_t;


/**************************************************************************/
/*!
    Indicates whether l2h or h2l edges trigger an interrupt.
*/
/**************************************************************************/
typedef enum gpioInterruptEdge_e
{
    gpioInterruptEdge_h2l = 0,
    gpioInterruptEdge_l2h
}
gpioInterruptEdge_t;


void gpioInit ( void );
void GPIO0_IRQHandler ( void );


void gpioSetDir (uint32_t bitPos, gpioDirection_t dir );
uint32_t gpioGetValue (uint32_t bitPos );
void gpioSetValue (uint32_t bitPos, uint32_t bitVal );
void gpioSetInterrupt (uint32_t bitPos, gpioInterruptEdge_t edge);
void gpioIntEnable (uint32_t bitPos );
void gpioIntDisable (uint32_t bitPos );
uint32_t  gpioIntStatus (uint32_t bitPos );
void gpioIntClear (uint32_t bitPos );
void GPIO_TOGGLE(uint32_t bitPosi );



/**************************************************************************/
/*!
    @brief Sets the direction (input/output) for a specific port pin

    @param[in]  bitPos
                The bit position (0..11)
    @param[in]  dir
                The pin direction (gpioDirection_Input or
                gpioDirection_Output)
*/
/**************************************************************************/
inline void gpioSetDir (uint32_t bitPos, gpioDirection_t dir )
{
    // Toggle dir
    dir == gpioDirection_Output ? ( *AMY_GPIO_DIR_P |= ( 1 << bitPos ) ) : ( *AMY_GPIO_DIR_P &= ~ ( 1 << bitPos ) );
}



/**************************************************************************/
/*!
    @brief Gets the value for a specific port pin

    @param[in]  bitPos
                The bit position (0..31)

    @return     The current value for the specified port pin (0..1)
*/
/**************************************************************************/
inline uint32_t gpioGetValue (uint32_t bitPos )
{   
    return ( ( uint32_t ) (( AMY_GPIO_INP_P & ( 1 << bitPos ) ) ? 1 : 0 ) );
}


/**************************************************************************/
/*!
    @brief Sets the value for a specific port pin (only relevant when a
           pin is configured as output).

    @param[in]  bitPos
                The bit position (0..31)
    @param[in]  bitValue
                The value to set for the specified bit (0..1).  0 will set
                the pin low and 1 will set the pin high.
*/
/**************************************************************************/
inline void gpioSetValue (uint32_t bitPos, uint32_t bitVal )
{
    // Toggle value
    bitVal == 1 ? ( *AMY_GPIO_OUT_P |= ( 1 << bitPos ) ) : ( *AMY_GPIO_OUT_P &= ~ ( 1 << bitPos ) );
}

/*************************************
           取反GPIO的某个位
函数功能:翻转某GPIO的一个引脚
参数描述：portNum : 端口号；
          bitPosi : 引脚在端口的位置
返回值  ：无
*************************************/
inline void GPIO_TOGGLE(uint32_t bitPosi )
{
    *AMY_GPIO_OUT_P ^= ( 1 << bitPos );
}

/**************************************************************************/
/*!
    @brief Sets the interrupt

    @param[in]  bitPos
                The bit position (0..31)
    @param[in]  event
                Whether the rising or the falling edge (high or low)
                should be used to trigger the interrupt.

    @section Example

    @code
    // Initialise gpio
    gpioInit();
    // Set GPIO1.7 to input
    gpioSetDir(1, 7, gpioDirection_Input);
    // Setup an interrupt on GPIO1.7
    gpioSetInterrupt(1,                               // Port
                     7,                               // Pin
                     gpioInterruptEdge_h2l);          // Rising/Falling
    // Enable the interrupt
    gpioIntEnable(1, 7);
    @endcode
*/
/**************************************************************************/
inline void gpioSetInterrupt (uint32_t bitPos, gpioInterruptEdge_t edge)
{
    ( gpioInterruptEdge_h2l == edge ) ? ( *AMY_GPIO_INT_MOD_P &= ~ ( 0x1 << bitPos ) ) : 
	                                    ( *AMY_GPIO_INT_MOD_P |= ( 0x1 << bitPos ) );

}



/**************************************************************************/
/*!
    @brief Enables the interrupt mask for a specific port pin

    @param[in]  bitPos
                The bit position (0..31)
*/
/**************************************************************************/
inline void gpioIntEnable (uint32_t bitPos )
{
    AMY_GPIO_INT_ENB_P |= ( 0x1 << bitPos );
   
}

/**************************************************************************/
/*!
    @brief Disables the interrupt mask for a specific port pin

    @param[in]  bitPos
                The bit position (0..31)
*/
/**************************************************************************/
inline void gpioIntDisable (uint32_t bitPos )
{

    AMY_GPIO_INT_ENB_P &= ~ ( 0x1 << bitPos );
}

/**************************************************************************/
/*!
    @brief Gets the interrupt status for a specific port pin

    @param[in]  bitPos
                The bit position (0..31)

    @return     The interrupt status for the specified port pin (0..1)
*/
/**************************************************************************/
inline uint32_t gpioIntStatus (uint32_t bitPos )
{
    return (uint32_t) (( AMY_GPIO_INT_STS_P & ( 0x1 << bitPos ) ) ? 1 : 0);
}

/**************************************************************************/
/*!
    @brief Clears the interrupt for a port pin

    @param[in]  bitPos
                The bit position (0..31)
*/
/**************************************************************************/
inline void gpioIntClear (uint32_t bitPos )
{
    AMY_GPIO_INT_STS_P |= ( 0x1 << bitPos );
}



#endif
