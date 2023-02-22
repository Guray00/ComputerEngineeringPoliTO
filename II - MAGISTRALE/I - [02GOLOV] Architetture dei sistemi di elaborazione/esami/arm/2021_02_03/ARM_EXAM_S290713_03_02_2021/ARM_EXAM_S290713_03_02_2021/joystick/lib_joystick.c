/*********************************************************************************************************
**--------------File Info---------------------------------------------------------------------------------
** File name:           joystick.h
** Last modified Date:  2018-12-30
** Last Version:        V1.00
** Descriptions:        Atomic joystick init functions
** Correlated files:    lib_joystick.c, funct_joystick.c
**--------------------------------------------------------------------------------------------------------       
*********************************************************************************************************/

#include "lpc17xx.h"
#include "joystick.h"

/*----------------------------------------------------------------------------
  Function that initializes joysticks and switch them off
 *----------------------------------------------------------------------------*/

void joystick_init(void) {
	/* joystick select functionality */
  LPC_PINCON->PINSEL3 &= ~(3<<18);	//PIN mode GPIO (00b value per P1.25)
	LPC_GPIO1->FIODIR   &= ~(1<<25);	//P1.25 Input (joysticks on PORT1 defined as Input) 
	/* joystick down functionality */
  LPC_PINCON->PINSEL3 &= ~(3<<20);	//PIN mode GPIO (00b value per P1.26)
	LPC_GPIO1->FIODIR   &= ~(1<<26);	//P1.26 Input (joysticks on PORT1 defined as Input)
	/* joystick left functionality */
  LPC_PINCON->PINSEL3 &= ~(3<<22);	//PIN mode GPIO (00b value per P1.27)
	LPC_GPIO1->FIODIR   &= ~(1<<27);	//P1.27 Input (joysticks on PORT1 defined as Input)
	/* joystick right functionality */
  LPC_PINCON->PINSEL3 &= ~(3<<24);	//PIN mode GPIO (00b value per P1.28)
	LPC_GPIO1->FIODIR   &= ~(1<<28);	//P1.28 Input (joysticks on PORT1 defined as Input)
	/* joystick up functionality */
  LPC_PINCON->PINSEL3 &= ~(3<<26);	//PIN mode GPIO (00b value per P1.29)
	LPC_GPIO1->FIODIR   &= ~(1<<29);	//P1.29 Input (joysticks on PORT1 defined as Input)
	
}
