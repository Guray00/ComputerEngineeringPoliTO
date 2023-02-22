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

volatile int down_INT0=0,down_KEY2 = 0,down = 0, down_JOY = 0;
volatile unsigned VAR1 = 9;
extern int count_bits_to_1(unsigned);

void RIT_IRQHandler (void)
{					
	static int select=0;
	static int i=0;	
	static int result;
	static int blinking = 0, ticks = 0;
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
	
	if (blinking == 1)
	{
		ticks++;
		if (ticks == 12)
			LED_Off_All();
		else if (ticks == 24)
		{
			LED_On_All();
			ticks = 0;
		}
	}
	if((LPC_GPIO1->FIOPIN & (1<<26)) == 0){	
		/* Joytick DOWN pressed */
		down_JOY++;
		switch(down_JOY){
			
			case 61:
				if (blinking == 1)
				{
					LED_Off_All();
					blinking = 0;
				}
				result = count_bits_to_1(VAR1);
				if (result < 4)
				{
					LED_Off_All();
					
				}
				else if (result < 12)
				{
					LED_On(result-4);
				  
				}
				else if (result < 32)
				{
					LED_On_All();
					blinking = 1;
					ticks = 0;
				}
				VAR1 = 9;
			default:
				break;
		}
	}
	else{
			down_JOY=0;
	}
	
	/* button management */
	if(down!=0){ 
		if((LPC_GPIO2->FIOPIN & (1<<11)) == 0){	/* KEY1 pressed */
			down++;				
			switch(down){
				case 2:
					if(i%2==0)
						LED_Out(0xAA);
					else
						LED_Out(0x55);
					i++;
					break;
				default:
					break;
			}
		}
		else {	/* button released */
			down=0;			
			NVIC_EnableIRQ(EINT1_IRQn);							 /* enable Button interrupts			*/
			LPC_PINCON->PINSEL4    |= (1 << 22);     /* External interrupt 0 pin selection */
		}
	}
	
	
	if(down_KEY2!=0){ 
		if((LPC_GPIO2->FIOPIN & (1<<12)) == 0){	/* KEY2 pressed */
			down_KEY2++;				
			switch(down_KEY2){
				case 2:
					disable_timer(3);
					VAR1 += LPC_TIM3->TC;
					enable_timer(3);
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
	
	if(down_INT0!=0){ 
		if((LPC_GPIO2->FIOPIN & (1<<10)) == 0){	/* KEY2 pressed */
			down_INT0++;				
			switch(down_INT0){
				case 2:
					VAR1 = VAR1 >> 2; //divide var by 4
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
	
  LPC_RIT->RICTRL |= 0x1;	/* clear interrupt flag */
	
  return;
}

/******************************************************************************
**                            End Of File
******************************************************************************/
