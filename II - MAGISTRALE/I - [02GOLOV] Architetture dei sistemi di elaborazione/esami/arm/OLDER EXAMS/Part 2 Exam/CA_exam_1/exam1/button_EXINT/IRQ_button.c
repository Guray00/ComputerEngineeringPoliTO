#include "button.h"
#include "lpc17xx.h"

extern int down_KEY1,down_KEY2;
extern int down_INT0;
void EINT0_IRQHandler (void)	  	/* INT0														 */
{		
	NVIC_DisableIRQ(EINT0_IRQn);
	LPC_PINCON->PINSEL4 &= ~(1 << 20); //SEt as GPIO
	
	down_INT0 = 1;
	LPC_SC->EXTINT &= (1 << 0);     /* clear pending interrupt         */
}


void EINT1_IRQHandler (void)	  	/* KEY1														 */
{
	NVIC_DisableIRQ(EINT1_IRQn);		/* disable Button interrupts			 */
	LPC_PINCON->PINSEL4    &= ~(1 << 22);     /* GPIO pin selection */
	down_KEY1=1;
	LPC_SC->EXTINT &= (1 << 1);     /* clear pending interrupt         */
}

void EINT2_IRQHandler (void)	  	/* KEY2														 */
{
	NVIC_DisableIRQ(EINT2_IRQn);		/* disable Button interrupts			 */
	LPC_PINCON->PINSEL4    &= ~(1 << 24);     /* GPIO pin selection */
	down_KEY2=1;
  LPC_SC->EXTINT &= (1 << 2);     /* clear pending interrupt         */    
}


