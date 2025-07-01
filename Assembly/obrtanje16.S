.section .data
	broj: .ascii ""
.section .text
.global main
main:
	movl $broj, %esi
	movl $1234, %eax
	movl $16, %ebx
	
	movb $'0',(%esi)
	movb $'x',(%esi)
	addl $2, %esi
petlja:
	cmpl $0, (%esi)
	je kraj_konverzije
	movl $0, %edx
	divl %ebx
	
	addb $48, %dl
	cmpb $'9', %dl #ovde ti treba karakter devet a ne cifra devet jer je sad string a ne vrijednosto
	jl cifra
	addb $7, %dl
cifra:
	movb %dl, (%esi)
	incl %esi
	jmp petlja
kraj_konverzije:
	movb $0, (%esi)
	decl %esi
	movl $broj, %edi # sad ti je izvrnuti broj u ediju
	
	addl $2, %edi
obrtanje:	
	cmpl %edi,%esi
	jle kraj 	#ako se mimoidju kraj
	movb (%edi), %al	
	movb (%esi), %cl
	movb %al, (%esi)
	movb %cl, (%edi)
	incl %edi
	decl %esi
	jmp obrtanje
kraj:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
