		.data
v1: .word 100
v2: .word 100
v3: .word 100
v4: .word 100
v5: .word 0
v6: .word 0
v7: .word 0
		.text
main:	daddui r1,r0,0
	daddui r2,r0,100
loop:	l.d f1,v1(r1)
	l.d f2,v2(r1) 
	div.d f5,f1,f2
	s.d f5,v5(r1)
	l.d f3,v3(r1)
	mul.d f6,f2,f3
	l.d f4,v4(r1)
	div.d f7,f6,f3
	add.d f7,f7,f3
	s.d f6,v6(r1)
	s.d f7,v7(r1)
	daddi r2,r2,-1
	daddui r1,r1,8
	bnez r2,loop
	HALT