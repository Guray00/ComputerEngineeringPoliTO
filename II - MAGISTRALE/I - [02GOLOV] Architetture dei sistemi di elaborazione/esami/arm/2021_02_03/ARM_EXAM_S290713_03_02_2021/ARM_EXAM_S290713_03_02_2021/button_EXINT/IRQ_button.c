#include "button.h"
#include "lpc17xx.h"						
#include "../RIT/RIT.h"		  				


volatile uint8_t press_2;										/* Toggle button pressed when joystick enabled */

void EINT0_IRQHandler (void)	  						/* INT0														 */
{		
	LPC_SC->EXTINT &= (1 << 0);     					/* clear pending interrupt         */
}

void EINT1_IRQHandler (void)	  						/* KEY1														 */
{
	LPC_SC->EXTINT &= (1 << 1);    	 					/* clear pending interrupt         */
}

void EINT2_IRQHandler (void)	  						/* KEY2														 */
{
	press_2 = 1;											
	NVIC_DisableIRQ(EINT2_IRQn);							/* disable Button interrupts			 */
	LPC_PINCON->PINSEL4    &= ~(1 << 24);   	/* GPIO pin selection */	
		
  LPC_SC->EXTINT &= (1 << 2);     					/* clear pending interrupt         */    
}


