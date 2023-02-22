		.data
v1: .word 100
v2: .word 100
v3: .word 100
v4: .word 100
v5: .word 0
		.text
main:	daddui r1,r0,0
	daddui r2,r0,100
loop:	l.d f1,v1(r1)
	l.d f2,v2(r1)
	l.d f3,v3(r1) 
	l.d f4,v4(r1)
	div.d f6,f3,f4
	div.d f7,f1,f2
	mul.d f5,f6,f7
	s.d f5,v5(r1)
	daddui r1,r1,8
	daddi r2,r2,-1
	bnez r2,loop
	HALT