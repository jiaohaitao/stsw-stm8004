/**
  ******************************************************************************
  * file main.c
  * brief This file contains the main function for I2C interrupt mode example.
  * author STMicroelectronics - MCD Application Team
  * version V1.0.0
  * date 01/03/2010
  ******************************************************************************
  *
  * THE PRESENT FIRMWARE WHICH IS FOR GUIDANCE ONLY AIMS AT PROVIDING CUSTOMERS
  * WITH CODING INFORMATION REGARDING THEIR PRODUCTS IN ORDER FOR THEM TO SAVE
  * TIME. AS A RESULT, STMICROELECTRONICS SHALL NOT BE HELD LIABLE FOR ANY
  * DIRECT, INDIRECT OR CONSEQUENTIAL DAMAGES WITH RESPECT TO ANY CLAIMS ARISING
  * FROM THE CONTENT OF SUCH FIRMWARE AND/OR THE USE MADE BY CUSTOMERS OF THE
  * CODING INFORMATION CONTAINED HEREIN IN CONNECTION WITH THEIR PRODUCTS.
  *
  *                    COPYRIGHT 2009 STMicroelectronics
  ******************************************************************************
  */

/* Includes ------------------------------------------------------------------*/
#include "stm8l15x.h"
#include "I2c_slave_interrupt.h"
/* Private typedef -----------------------------------------------------------*/
/* Private define ------------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/ 
/* Private function prototypes -----------------------------------------------*/
/* Private functions ---------------------------------------------------------*/
/* Public functions ----------------------------------------------------------*/

 /*
  * Example firmware main entry point.
  * Parameters: None
  * Retval . None
  */
	
void main(void)
{
	

CLK->CKDIVR = 0;                // sys clock /1
	CLK->PCKENR1 = 0x08;						// enable I2C peripheral clk

	/* Init GPIO for I2C use */
	GPIOC->CR1 |= 0x03;
	GPIOC->DDR &= ~0x03;
	GPIOC->CR2 &= ~0x03;

	/* Initialise I2C for communication */
	Init_I2C();
	
	/* Enable general interrupts */
	enableInterrupts();
	
	/*Main Loop */
  while(1);
}

/******************* (C) COPYRIGHT 2009 STMicroelectronics *****END OF FILE****/
