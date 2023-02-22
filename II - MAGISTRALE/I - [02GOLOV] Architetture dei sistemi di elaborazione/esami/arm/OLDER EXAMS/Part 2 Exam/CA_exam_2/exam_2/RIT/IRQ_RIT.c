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
#define N 5
/******************************************************************************
** Function name:		RIT_IRQHandler
**
** Descriptions:		REPETITIVE INTERRUPT TIMER handler
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/

volatile int down=0;
extern int overflow(int*,int);
void RIT_IRQHandler (void)
{					
	static int select=0;
	static int i=0;	
	static int v[N] = {0};
	if((LPC_GPIO1->FIOPIN & (1<<29)) == 0){ //JOYSTICK UP	
		/* Joytick Select pressed */
		select++;
		switch(select){
			case 1:
				disable_timer(1);
			  v[i++] = LPC_TIM2->TC;
				enable_timer(1);
				if (i == N)
				{
					i = 0;
					LED_On(overflow(v,N));
				}
				break;
			case 60 : // 3s / 50ms = 60
				LED_On(7);
				break;
			case 67: // 350ms / 50ms = 7
				LED_Off(7);
				select = 60;
				break;
			default:
				break;
		}
	}
	else{
			select=0;
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
	
  LPC_RIT->RICTRL |= 0x1;	/* clear interrupt flag */
	
  return;
}

/******************************************************************************
**                            End Of File
******************************************************************************/
