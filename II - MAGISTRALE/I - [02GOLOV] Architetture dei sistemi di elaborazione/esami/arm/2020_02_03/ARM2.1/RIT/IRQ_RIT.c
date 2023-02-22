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

/******************************************************************************
** Function name:		RIT_IRQHandler
**
** Descriptions:		REPETITIVE INTERRUPT TIMER handler
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/

#include "../timer/timer.h"
#include "../led/led.h"

#define N 3

int val_int;
unsigned char val_char;
unsigned char vett[N];
int n=0;
int i=0;


extern unsigned char get_and_sort(unsigned char*, unsigned char, int);

void RIT_IRQHandler (void)
{			
	static int down=0;	
	
	down++; 
	if((LPC_GPIO2->FIOPIN & (1<<11)) == 0){ /* KEY1														 */
		
		reset_RIT();
		switch(down){
			case 1:
				disable_timer(1);
				val_int = LPC_TIM1->TC;
				enable_timer(1);
				val_char = (val_int & 0x00FF0000)>>16;
				n++;
				get_and_sort(vett, val_char, n);
				if(n<N)
					LED_Out_mod(n);
				else{					
					LED_Out(vett[0]);
					enable_timer(0);
					i++;
				}
				
				break;
			default:
				break;
		}
	}
	else {	/* button released */
		down=0;			
		disable_RIT();
		reset_RIT();
		if(n<N)
			NVIC_EnableIRQ(EINT1_IRQn);							 /* disable Button interrupts			*/
		LPC_PINCON->PINSEL4    |= (1 << 22);     /* External interrupt 0 pin selection */
	}
		
	
  LPC_RIT->RICTRL |= 0x1;	/* clear interrupt flag */
	
  return;
}

/******************************************************************************
**                            End Of File
******************************************************************************/
