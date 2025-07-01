.section .data
	broj: .ascii "0x12aCd\0"
.section .text
.global main
main:
	movl $broj, %esi
	movl $0, %eax
	movl $16, %ebx #16 je baza posto je heksadecimalni
	movl $0, %ecx
	
	cmpb $'0',(%esi) #svaki heksadecmilani broj mora pocinjati sa 0x
	jne greska
	cmpb $'x',(%esi)
	jne greska
	incl %esi
petlja:
	cmpl $0, (%esi) 
	je kraj
	movb (%esi), %cl
	subb $48, %cl	
	cmpb $10, %cl #ako rezultat predhodnog oduzimanja nije deset onda jos nisi dobio broj
	jl cifra
	subb $7, %cl	#sad oduzimas 7 za velika slova
	cmpb $16, %cl
	jl cifra
	subb $32, %cl 	# i 32 za mala
cifra:
	mull %ebx
	addl %ecx, %eax
	incl %esi
	jmp petlja
greska:
kraj:
	movl $1,%eax
	movl $0,%ebx
	int $0x80
