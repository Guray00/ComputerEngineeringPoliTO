				AREA asm_func, CODE, READONLY
				EXPORT count_bits_to_1

count_bits_to_1	MOV r12, sp
				STMFD sp!, {r4-r8, r10-r11, lr}
				
				MOV r5, #0
				MOV r7, #1
				MOV r8, #32
loop			TST r0, r7
				ADDNE r5, r5, #1
				LSL r7, r7, #1
				SUBS r8, r8, #1
				BNE loop
				
				
				
				
				MOV r0, r5
				LDMFD sp!,{r4-r8,r10-r11,pc}
				
                END