/*********************************************************************************************************
**--------------File Info---------------------------------------------------------------------------------
** File name:           lib_timer.h
** Last modified Date:  2020-12-30
** Last Version:        V1.1
** Author:							Alessandro Cannarella S290713
** Descriptions:        atomic functions to be used by higher sw levels
** Correlated files:    lib_timer.c, funct_timer.c, IRQ_timer.c
**--------------------------------------------------------------------------------------------------------
*********************************************************************************************************/
#include "lpc17xx.h"
#include "timer.h"

/******************************************************************************
** Function name:		enable_timer
**
** Descriptions:		Enable timer
**
** parameters:			timer number: 0 or 1
** Returned value:		None
**
******************************************************************************/
void enable_timer( uint8_t timer_num )
{
	switch(timer_num){
		case 0:
			LPC_TIM0->TCR = 1;
			break;
		case 1:
			LPC_TIM1->TCR = 1;
			break;
		case 2:
			LPC_TIM2->TCR = 1;
			break;
		case 3:
			LPC_TIM3->TCR = 1;
			break;
		default:
			break;
	}
  return;
}

/******************************************************************************
** Function name:		disable_timer
**
** Descriptions:		Disable timer
**
** parameters:			timer number: 0 or 1
** Returned value:		None
**
******************************************************************************/
void disable_timer( uint8_t timer_num )
{
  switch(timer_num){
		case 0:
			LPC_TIM0->TCR = 0;
			break;
		case 1:
			LPC_TIM1->TCR = 0;
			break;
		case 2:
			LPC_TIM2->TCR = 0;
			break;
		case 3:
			LPC_TIM3->TCR = 0;
			break;
		default:
			break;
	}
  return;
}

/******************************************************************************
** Function name:		reset_timer
**
** Descriptions:		Reset timer
**
** parameters:			timer number: 0 or 1
** Returned value:		None
**
******************************************************************************/
void reset_timer( uint8_t timer_num )
{
  uint32_t regVal;
	
	switch(timer_num){
		case 0:
			regVal = LPC_TIM0->TCR;
			regVal |= 0x02;
			LPC_TIM0->TCR = regVal;
			break;
		case 1:
			regVal = LPC_TIM1->TCR;
			regVal |= 0x02;
			LPC_TIM1->TCR = regVal;
			break;
		case 2:
			regVal = LPC_TIM2->TCR;
			regVal |= 0x02;
			LPC_TIM2->TCR = regVal;
			break;
		case 3:
			regVal = LPC_TIM3->TCR;
			regVal |= 0x02;
			LPC_TIM3->TCR = regVal;
			break;
		default:
			break;
	}
  return;
}

uint32_t init_timer ( uint8_t timer_num, uint32_t TimerInterval ){
	switch(timer_num){
		case 0:
			LPC_TIM0->MR0 = TimerInterval;
			LPC_TIM0->MCR = 3;
		
			NVIC_EnableIRQ(TIMER0_IRQn);
			break;
		case 1:
			LPC_TIM1->MR0 = TimerInterval;
			LPC_TIM1->MCR = 3;
		
			NVIC_EnableIRQ(TIMER1_IRQn);
			break;
		case 2:
			LPC_TIM2->MR0 = TimerInterval;
			LPC_TIM2->MCR = 3;
		
			NVIC_EnableIRQ(TIMER2_IRQn);
			break;
		case 3:
			LPC_TIM3->MR0 = TimerInterval;
			LPC_TIM3->MCR = 5;
		
			NVIC_EnableIRQ(TIMER3_IRQn);
			break;
		default:
			break;
	}
  return (0);
}

/******************************************************************************
**                            End Of File
******************************************************************************/
