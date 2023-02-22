/*********************************************************************************************************
**--------------File Info---------------------------------------------------------------------------------
** File name:           lib_RIT.h
** Last modified Date:  2014-09-25
** Last Version:        V1.00
** Descriptions:        atomic functions to be used by higher sw levels
** Correlated files:    lib_RIT.c, funct_RIT.c, IRQ_RIT.c
**--------------------------------------------------------------------------------------------------------
*********************************************************************************************************/
#include "lpc17xx.h"
#include "RIT.h"

/******************************************************************************
** Function name:		enable_RIT
**
** Descriptions:		Enable RIT
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/
void enable_RIT( void )
{
  LPC_RIT->RICTRL |= (1<<3);	
  return;
}

/******************************************************************************
** Function name:		disable_RIT
**
** Descriptions:		Disable RIT
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/
void disable_RIT( void )
{
	LPC_RIT->RICTRL &= ~(1<<3);	
  return;
}

/******************************************************************************
** Function name:		reset_RIT
**
** Descriptions:		Reset RIT
**
** parameters:			RIT number: 0 or 1
** Returned value:		None
**
******************************************************************************/
void reset_RIT( void )
{
  LPC_RIT->RICOUNTER = 0;          // Set count value to 0
  return;
}

uint32_t init_RIT ( uint32_t RITInterval )
{
  
	
  LPC_SC->PCLKSEL1  &= ~(3<<26);
  LPC_SC->PCLKSEL1  |=  (1<<26);   // RIT Clock = CCLK
	LPC_SC->PCONP     |=  (1<<16);   // Enable power for RIT
	
	LPC_RIT->RICOMPVAL = RITInterval;      // Set match value		
	LPC_RIT->RICTRL    = (1<<1) |    // Enable clear on match	
											 (1<<2) ;		 // Enable timer for debug	
	LPC_RIT->RICOUNTER = 0;          // Set count value to 0
	
	NVIC_EnableIRQ(RIT_IRQn);
  return (0);
}

/******************************************************************************
**                            End Of File
******************************************************************************/
