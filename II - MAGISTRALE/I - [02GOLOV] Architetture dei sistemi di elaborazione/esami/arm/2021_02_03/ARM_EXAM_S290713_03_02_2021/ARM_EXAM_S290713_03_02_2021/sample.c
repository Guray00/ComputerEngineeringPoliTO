/*----------------------------------------------------------------------------
 * Name:    sample.c
 * Purpose: EXAM ASE 03/02/2021	
 * Note(s): this version supports the LANDTIGER Emulator
 * Author: 	Alessandro Cannarella - S290713 - last modified 04/01/2021
 *
 *----------------------------------------------------------------------------*/
                  
#include <stdio.h>
#include "LPC17xx.H"                    /* LPC17xx definitions                */
#include "led/led.h"
#include "button_EXINT/button.h"
#include "timer/timer.h"
#include "RIT/RIT.h"
#include "joystick/joystick.h"


extern uint8_t status;																	/* 1 = A - 0 = M */
extern uint8_t toggle;																	/* 1 = already enterd - 0 = not entered */
extern uint8_t variazioni;
extern uint8_t valore_iniziale;
extern uint8_t temp_val;


/* Led external variables from funct_led */
extern unsigned char led_value;					/* defined in funct_led								*/
#ifdef SIMULATOR
extern uint8_t ScaleFlag; // <- ScaleFlag needs to visible in order for the emulator to find the symbol (can be placed also inside system_LPC17xx.h but since it is RO, it needs more work)
#endif
/*----------------------------------------------------------------------------
  Main Program
 *----------------------------------------------------------------------------*/
int main (void) {

  	
	SystemInit();  												/* System Initialization (i.e., PLL)  */
  LED_init();                           /* LED Initialization                 */
  BUTTON_init();												/* BUTTON Initialization              */
	joystick_init();											/* Joystick Initialization            */
	init_RIT(0x004C4B40);									/* RIT Initialization at 50 msec [50 msec 0x004C4B40 - 200 msec 0x01312D00 - 100 msec 0x00989680] */
	
	NVIC_SetPriority(TIMER1_IRQn, 1);
	NVIC_SetPriority(TIMER2_IRQn, 1);
	NVIC_SetPriority(TIMER3_IRQn, 1);
	
	init_timer(1, 50000000);
	init_timer(2, 625000);
	init_timer(3, 25000000);
	
	status = 0;
	toggle = 0;
	variazioni = 0;
	valore_iniziale = 0;
	
	enable_RIT();													/* RIT enabled for joystick */
		
	LPC_SC->PCON |= 0x1;									/* power-down	mode										*/
	LPC_SC->PCON &= ~(0x2);						
		
  while (1) {                           /* Loop forever                       */	
		__ASM("wfi");
  }

}
