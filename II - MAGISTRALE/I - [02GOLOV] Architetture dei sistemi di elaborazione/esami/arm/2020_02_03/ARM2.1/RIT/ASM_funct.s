				
				
				AREA asm_functions, CODE, READONLY				
                EXPORT  get_and_sort
get_and_sort
				; save current SP for a faster access 
				; to parameters in the stack
				MOV   r12, sp
				; save volatile registers
				STMFD sp!,{r4-r8,r10-r11,lr}				
				; extract argument 4 and 5 into R4 and R5
				
				; posizione libera n 
				
				; for (i=n-1 ; i>=0 && trovato ; i--)
				;	if val > vett[i]
				; 		vett[i+1] = vett[i]
				;	else
				;		vett[i] = val
				;		trovato = 1
				
				; r0 = vett
				; r1 = val
				; r2 = n
				; r3 = n-1
				
				add r2, r0, r2
				
loop			sub r2, r2, #1
				sub r3, r2, #1
				cmp r0, r3
				bhi	fine
				ldrb r4, [r3]				
				cmp r4, r1
				strblo r4, [r2]
				bhi	fine
				b loop
				; setup a value for R0 to return
fine 			strb r1, [r2]
				MOV	  r0, r1
				; restore volatile registers
				LDMFD sp!,{r4-r8,r10-r11,pc}
				
                END