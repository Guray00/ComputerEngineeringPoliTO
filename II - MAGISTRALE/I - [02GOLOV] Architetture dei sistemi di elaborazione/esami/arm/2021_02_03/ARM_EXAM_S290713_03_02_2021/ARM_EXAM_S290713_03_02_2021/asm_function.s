;/*********************************************************************************************************
;**--------------File Info---------------------------------------------------------------------------------
;** File name:           asm_function.s		
;** Last modified Date:  04/02/2021
;** Last Version:        V1.0
;** Author:				 Alessandro Cannarella S290713
;** Descriptions:        ARM Assembly function to calculate Duty Cycle
;**	Variable passing	 R0 = Start Value, R1 = Total Time, R2 = Variation Times Vector,
;**						 R3 = Number of Variations
;**--------------------------------------------------------------------------------------------------------
;*********************************************************************************************************/

;-------------------PSEUDO-CODE------------------------------------
;
;					if(numero variazioni NOT zero){
;						if{valore iniziale == 1){
;							//HIGH
;							if(variazioni -> dispari){
;								tempo_value_1 = DISPARI_HIGH();
;							}else{
;								tempo_value_1 = PARI_HIGH();
;							}
;						}else{
;							//LOW
;							if(variazioni -> dispari){
;								tempo_value_1 = DISPARI_LOW();
;							}else{
;								tempo_value_1 = PARI_LOW();
;							}
;						}
;					}else{
;						if{valore iniziale == 1){
;							return 100;
;						}else{
;							return 0;
;						}
;					}
;					return CALCOLA_PERCENTUALE(tempo_value_1);
;
;----------------------------------------------------------------
					
					AREA 	ASM_FUNCTION, CODE, READONLY				
					EXPORT  duty_cycle
					
duty_cycle		 	PROC
					
					STMFD 	SP!,{R4-R8,R10-R11,LR}		;SALVO REGISTRI VOLATILI
					
					;R0    	VALORE INIZIALE
					;R1		TEMPO TOTALE
					;R2		TEMPI_VARIAZIONI[]
					;R3		NUMERO VARIAZIONI
					
					;R6		NEXT
					;R5		BEFORE
					
					MOV 	R7, #0						;TOTAL TIME UP
					
					CMP		R3, #0
					BNE		START
					CMP		R0, #0
					BEQ		FINE
					MOVNE	R0, #100
					BNE		FINE
					
START				MOV		R4, R3						;SALVO NUMERO VARIAZIONI
					CBZ		R0, LOW
					
HIGH				TST		R4, #1
					SUB		R4, #1						;NUMERO VARIAZIONI = INDICE MASSIMO VETTORE
					BEQ		PARI_H
					BNE		DISPARI_H
					
DISPARI_H			CMP		R4, #0					
					LDREQ	R6, [R2,R4, LSL #2]
					ADDEQ	R7, R7, R6
					BEQ		CALCOLA
					LDR		R6, [R2,R4, LSL #2]
					SUB 	R4, #1
					LDR		R5, [R2,R4, LSL #2]
					SUB		R6, R6, R5
					ADD		R7, R7, R6
					SUB		R4, #1
					B		DISPARI_H
					
PARI_H				CMP		R4, #-1
					SUBEQ	R7, R1, R7
					BEQ		CALCOLA
					LDR		R6, [R2,R4, LSL #2]
					SUB 	R4, #1
					LDR		R5, [R2,R4, LSL #2]
					SUB		R6, R6, R5
					ADD		R7, R7, R6
					SUB		R4, #1
					B		PARI_H

LOW					TST		R4, #1
					SUB		R4, #1						;NUMERO VARIAZIONI = INDICE MASSIMO VETTORE
					BEQ		PARI_L
					SUBNE	R4, #1
					BNE		DISPARI_L
					
DISPARI_L			CMP		R4, #-1
					MOVEQ	R4, R3
					SUBEQ	R4, R4, #1
					LDREQ	R5, [R2,R4, LSL #2]
					SUBEQ	R6, R1, R5
					ADDEQ	R7, R7, R6
					BEQ		CALCOLA
					LDR		R6, [R2,R4, LSL #2]
					SUB 	R4, #1
					LDR		R5, [R2,R4, LSL #2]
					SUB		R6, R6, R5
					ADD		R7, R7, R6
					SUB		R4, #1
					B		DISPARI_L

PARI_L				CMP		R4, #-1					
					BEQ		CALCOLA
					LDR		R6, [R2,R4, LSL #2]
					SUB 	R4, #1
					LDR		R5, [R2,R4, LSL #2]
					SUB		R6, R6, R5
					ADD		R7, R7, R6
					SUB		R4, #1
					B		PARI_L
					
CALCOLA				MOV		R6, #100
					MUL		R7, R7, R6
					UDIV	R0, R7, R1					

FINE				LDMFD 	SP!,{R4-R8,R10-R11,PC}		;RIPRISTINO REGISTRI VOLATILI
					ENDP
					END