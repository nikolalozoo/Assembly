.section .data
	broj: .ascii "1234 + 1234\0"
	prvi_broj: .long 0 # promjenjiva da savuvas vrijednost prvog broja
	znak: .long 0 #ako ostane nula -> oudzimanje , ako se poveca na 1->sabriranje
.section .text 
.global main
main:
	movl $broj, %esi
	movl $0, %eax
	movl $10, %ebx
	movl $0, %ecx
petlja:
	cmpl $'0', (%esi) #ovde ides do entera znaci zavrsio prvi broj i ako dodje onda trazis znak
	je trazi_znak
	movb (%esi), %cl
	subb $48, %cl
	mull %ebx
	addl %ecx, %eax  # u eax je prvi broj
	incl %esi
	jmp petlja
trazi_znak:
	incl %esi
	cmpl $'+', (%esi)
	je sabiranje
	jmp drugi_broj
sabiranje:
	incl znak
drugi_broj:
	addl $2,%esi
	movl %eax, prvi_broj # sacuvas vrijednos prvog broja
petlja_2: 
	cmpl $0, (%esi)
	je izvrisi_op
	movb (%esi), %cl
	subb $48, %cl
	mull %ebx
	addl %ecx, %eax 
	incl %esi
	jmp petlja_2
izvrisi_op:
	cmpl $0,znak
	je oduzmi
	addl prvi_broj,%eax
	jmp kraj
oduzmi:
	subl prvi_broj,%eax
kraj:
	imull %edi
	movl $1, %eax
	movl $0, %ebx
	int $0x80
