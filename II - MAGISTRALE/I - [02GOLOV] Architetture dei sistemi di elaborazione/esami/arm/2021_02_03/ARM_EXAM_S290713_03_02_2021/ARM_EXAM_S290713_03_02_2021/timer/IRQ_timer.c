/*********************************************************************************************************
**--------------File Info---------------------------------------------------------------------------------
** File name:           IRQ_timer.c
** Last modified Date:  04/02/2021
** Last Version:        V1.0
** Author:							Alessandro Cannarella S290713
** Descriptions:        functions to manage TIMER 1,2,3
** Correlated files:    timer.h
**--------------------------------------------------------------------------------------------------------
*********************************************************************************************************/

#include "timer.h"
#include "../led/led.h"

extern uint8_t status;																	/* 1 = A - 0 = M */
extern uint8_t variazioni;
extern uint8_t	valore_iniziale;
extern uint8_t temp_val;
extern uint32_t tempi_variazioni[5];
extern uint32_t tempo_totale;
extern char dutycycle;
uint8_t	monitor;


/******************************************************************************
** Function name:		Timer1_IRQHandler
**
** Descriptions:		Timer/Counter 1 interrupt handler
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/

void TIMER1_IRQHandler (void)
{
	if(monitor){
		LED_On(7);
		LED_Out_7(variazioni);
		monitor = 0;
	}else{
		LED_Off(7);
		LED_Out_7(dutycycle);
		monitor = 1;
	}
	
	LPC_TIM1->IR = 1;			/* clear interrupt flag */	
  return;
}

/******************************************************************************
** Function name:		Timer2_IRQHandler
**
** Descriptions:		Timer/Counter 2 interrupt handler
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/

void TIMER2_IRQHandler (void)
{
	if(temp_val){
		//last value = 1
		if((LPC_GPIO1->FIOPIN & (1<<29))){
			// up released => variation
			temp_val = 0;
			disable_timer(3);
			tempi_variazioni[variazioni] = LPC_TIM3->TC;
			enable_timer(3);
			variazioni++;
			if(variazioni>=5){
				// STOP
				disable_timer(2);
				disable_timer(3);
				tempo_totale = LPC_TIM3->TC;
				reset_timer(2);
				reset_timer(3);
				status = 0;
				NVIC_EnableIRQ(EINT2_IRQn);							 /* enable Button interrupts			*/
			}
		}
	}else{
		//last value = 0
		if((LPC_GPIO1->FIOPIN & (1<<29)) == 0){
			// up pressed => variation
			temp_val = 1;
			disable_timer(3);
			tempi_variazioni[variazioni] = LPC_TIM3->TC;
			enable_timer(3);
			variazioni++;
			if(variazioni>=5){
				// STOP
				disable_timer(2);
				disable_timer(3);
				tempo_totale = LPC_TIM3->TC;
				reset_timer(2);
				reset_timer(3);
				status = 0;
				NVIC_EnableIRQ(EINT2_IRQn);							 /* enable Button interrupts			*/
			}
		}
	}
	
	LPC_TIM2->IR = 1;			/* clear interrupt flag */	
  return;
}

/******************************************************************************
** Function name:		Timer2_IRQHandler
**
** Descriptions:		Timer/Counter 2 interrupt handler
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/

void TIMER3_IRQHandler (void)
{
	disable_timer(2);
	tempo_totale = 25000000;
	status = 0;
	NVIC_EnableIRQ(EINT2_IRQn);							 /* enable Button interrupts			*/
	LPC_TIM3->IR = 1;			/* clear interrupt flag */	
  return;
}

/******************************************************************************
**                            End Of File
******************************************************************************/

