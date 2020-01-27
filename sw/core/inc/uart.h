/*****************************************************************************
 *   uart.h:  uart Header file for PODES_M0 Family 
 *   Microprocessor IP.
 *
 *   History
 *   2009.04.01  ver 1.00    Preliminary version, first Release
 *
******************************************************************************/
#ifndef __UART_H__ 
#define __UART_H__


#define CFG_UART_BAUDRATE           (115200)
#define CFG_UART_BUFSIZE            (1)

// Buffer used for circular fifo
typedef struct _uart_buffer_t
{
  uint8_t          ep_dir;
  volatile uint8_t len;
  volatile uint8_t wr_ptr;
  volatile uint8_t rd_ptr;
  uint8_t  buf[CFG_UART_BUFSIZE];
} uart_buffer_t;

// UART Protocol control block
typedef struct _uart_pcb_t
{
  uint8_t       initialised;
  uint32_t      status;
  uint32_t      pending_tx_data;
  uart_buffer_t rxfifo;
} uart_pcb_t;

void UART_IRQHandler(void);

void uartInit(uint32_t Baudrate);

void uartSendByte (uint8_t byte);

int puts(const char * str);

#endif

