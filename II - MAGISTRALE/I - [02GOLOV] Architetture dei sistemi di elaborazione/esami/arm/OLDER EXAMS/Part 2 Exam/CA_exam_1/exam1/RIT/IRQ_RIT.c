/*********************************************************************************************************
**--------------File Info---------------------------------------------------------------------------------
** File name:           IRQ_RIT.c
** Last modified Date:  2014-09-25
** Last Version:        V1.00
** Descriptions:        functions to manage T0 and T1 interrupts
** Correlated files:    RIT.h
**--------------------------------------------------------------------------------------------------------
*********************************************************************************************************/
#include "lpc17xx.h"
#include "RIT.h"
#include "../led/led.h"
#include "../timer/timer.h"
/******************************************************************************
** Function name:		RIT_IRQHandler
**
** Descriptions:		REPETITIVE INTERRUPT TIMER handler
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/

volatile int down_KEY1=0;
volatile int down_KEY2=0;
volatile int down_INT0 = 0;
volatile int e1 = 0;
volatile int e2 = 0;
void RIT_IRQHandler (void)
{					
	static int select=0;
	static int i=0;
	
	
	if((LPC_GPIO1->FIOPIN & (1<<25)) == 0){	
		/* Joytick Select pressed */
		select++;
		switch(select){
			case 1:
				if(i%2==0)
					LED_Out(0xF0);
				else
					LED_Out(0x0F);
				i++;
				break;
			default:
				break;
		}
	}
	else{
			select=0;
	}
	
	/* button management */
	if(down_INT0!=0){ 
		if((LPC_GPIO2->FIOPIN & (1<<10)) == 0){	/* INT0 pressed */
			down_INT0++;				
			switch(down_INT0){
				case 2:
					reset_timer(2);
					enable_timer(2);
					break;
				default:
					
					break;
			}
		}
		else {	/* button released */
			down_INT0=0;			
			NVIC_EnableIRQ(EINT0_IRQn);							 /* enable Button interrupts			*/
			LPC_PINCON->PINSEL4    |= (1 << 20);     /* External interrupt 0 pin selection */
		}
	}
	
	if(down_KEY1!=0){ 
		if((LPC_GPIO2->FIOPIN & (1<<11)) == 0){	/* KEY1 pressed */
			down_KEY1++;				
			switch(down_KEY1){
				case 2:
					e1++;
				LED_Out(e1);
					break;
				default:
					break;
			}
		}
		else {	/* button released */
			down_KEY1=0;
				
			NVIC_EnableIRQ(EINT1_IRQn);							 /* enable Button interrupts			*/
			LPC_PINCON->PINSEL4    |= (1 << 22);     /* External interrupt 0 pin selection */
		}
	}
	
	if(down_KEY2!=0){ 
		if((LPC_GPIO2->FIOPIN & (1<<12)) == 0){	/* KEY2 pressed */
			down_KEY2++;				
			switch(down_KEY2){
				case 2:
					e2++;
					LED_Out(e2);
					break;
				default:
					break;
			}
		}
		else {	/* button released */
			down_KEY2=0;			
			NVIC_EnableIRQ(EINT2_IRQn);							 /* enable Button interrupts			*/
			LPC_PINCON->PINSEL4    |= (1 << 24);     /* External interrupt 0 pin selection */
		}
	}
	
	
	
  LPC_RIT->RICTRL |= 0x1;	/* clear interrupt flag */
	
  return;
}

/******************************************************************************
**                            End Of File
******************************************************************************/
