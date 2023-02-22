/*********************************************************************************************************
**--------------File Info---------------------------------------------------------------------------------
** File name:           IRQ_RIT.c
** Last modified Date:  04/02/2021
** Last Version:        V1.0
** Author:							Alessandro Cannarella S290713
** Descriptions:        functions to manage KEY2 interrupts and System STATUS
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


extern uint8_t press_2;													/* Toggle button pressed when joystick enabled */
extern char duty_cycle(uint8_t, uint32_t, uint32_t *, uint8_t);
extern uint8_t monitor;
uint8_t status;																	/* 1 = ACQUISIZIONE - 0 = MONITOR */
uint8_t toggle;																	/* 1 = already enterd - 0 = not entered */
uint8_t variazioni;
uint8_t	valore_iniziale;
uint8_t temp_val;
uint32_t tempi_variazioni[5];
uint32_t tempo_totale;
char dutycycle;

void RIT_IRQHandler (void)
{	static int i;

	if(press_2){
		if((LPC_GPIO2->FIOPIN & (1<<12)) == 0){			/* KEY2 pressed */
			press_2++;				
			switch(press_2){
				case 2:
						if(!status){
							status = 1;
							toggle = 0;
							disable_timer(1);
							reset_timer(1);
							LED_Out(255);
							for(i=0; i<5; i++) tempi_variazioni[i] = 0;
							variazioni = 0;
							tempo_totale = 0;
							temp_val = valore_iniziale = !(LPC_GPIO1->FIOPIN & (1<<29));
							enable_timer(3);
							enable_timer(2);
						}
						/* ACTION */
					break;
				default:
					break;
			}
		}
		else {	/* button released */
			press_2=0;
			NVIC_EnableIRQ(EINT2_IRQn);							 /* enable Button interrupts			*/			
			LPC_PINCON->PINSEL4    |= (1 << 24);     /* External interrupt 0 pin selection */
		}
	}
	
	if(!status){
		if(!toggle){
			// MONITOR
			toggle = 1;
			reset_timer(2);
			reset_timer(3);
			LED_Out(0);
			dutycycle = duty_cycle(valore_iniziale, tempo_totale, tempi_variazioni, variazioni);
			monitor = 1;
			enable_timer(1);
		}
	}
	
	
  LPC_RIT->RICTRL |= 0x1;	/* clear interrupt flag */
	
  return;
}

/******************************************************************************
**                            End Of File
******************************************************************************/
