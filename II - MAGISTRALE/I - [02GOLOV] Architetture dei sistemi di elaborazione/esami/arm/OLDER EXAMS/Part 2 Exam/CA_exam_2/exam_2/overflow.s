				AREA asm_func, CODE, READONLY
				EXPORT overflow
					
overflow        MOV r12, sp
				STMFD sp!, {r4-r8, r10-r11, lr}
				
				MOV r5, #0
				MOV r4, r1
next			LDR r6, [r0]
				ADDS R5,R5,R6
				BVS return0
				BCS return1
				ADD R0,R0,#4
				SUBS R4,R4, #1
				BNE next
				
				MOV r0,#2
				B exit
				
return1			MOV r0, #1
				B exit


return0			MOV r0,#0
				B exit
				
exit			LDMFD sp!,{r4-r8,r10-r11,pc}
				
                END