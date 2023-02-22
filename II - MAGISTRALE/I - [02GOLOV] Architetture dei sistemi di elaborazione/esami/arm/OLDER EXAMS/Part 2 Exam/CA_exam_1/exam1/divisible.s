				
				AREA asm_functions, CODE, READONLY				
                EXPORT  divisible
divisible
				; save current SP for a faster access 
				; to parameters in the stack
				MOV   r12, sp
				; save volatile registers
				STMFD sp!,{r4-r8,r10-r11,lr}				
lab_1				
				cmp r1, r0
				bhi end_asmf
				sub r0, r0, r1
				b lab_1

end_asmf
				; setup a value for R0 to return
				; restore volatile registers
				LDMFD sp!,{r4-r8,r10-r11,pc}
				
                END