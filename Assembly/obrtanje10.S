.section .data
	broj: .ascii ""
.section .text
.global main
main:
	movl $broj, %esi
	movl $1234, %eax
	movl $10, %ebx
petlja:
	cmpl $0, (%esi)
	je kraj_konverzije
	movl $0, %edx
	divl %ebx
	addb $48, %dl
	movb %dl, (%esi)
	incl %esi
	jmp petlja
kraj_konverzije:
	movb $0, (%esi)
	decl %esi
	movl $broj, %edi # sad ti je izvrnuti broj u ediju
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
