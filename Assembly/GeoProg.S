.section .data
	broj: .ascii "4\n"
	broj2: .ascii "32\n"
	izlaz: .ascii ""
.section .text
.global main
main:
	movl $broj, %esi
	movl $0, %eax
	movl $10, %ebx
	movl $0, %ecx
petlja:
	cmpb $10, (%esi)
	je kraj_konverzije
	movb (%esi), %cl
	subb $48, %cl
	mull %ebx
	jc greska
	addl %ecx, %eax
	jc greska
	incl %esi
	jmp petlja
kraj_konverzije:
	movl %eax, %edi
	movl $broj2, %esi
	movl $0, %eax
petlja2:
	cmpb $10, (%esi)
	je kraj_konverzije2
	movb (%esi), %cl
	subb $48, %cl
	mull %ebx
	jc greska
	addl %ecx, %eax
	jc greska
	incl %esi
	jmp petlja
kraj_konverzije2:
	movl %eax, %esi
#prvi elemetn si stavio u edi drugi u esi
#bukavlno ti suma sad postaje eax da ne pravis gore promjenivu
	movl $0, %eax
petlja_niz:
	addl %edi,%eax
#dodao si prvi clan sad sledeci treba da bude puta dva ali da ne bi to radio sa mullom kad se siftuju ulijevo tipa 4 postaje 8 pa ako ponovo siftujes postaje 16 bukvalno siftobanje pravi geometrijusku progresiji
	shll %edi #mnozenje sa dva
	cmpl %edi,%esi
	jae petlja_niz # dok god nije vece skaci na petlju
	
	movl $10, %ebx
	movl $izlaz, %esi
	
petlja:
	cmpl $0, %eax
	je kraj_konverzije
	movl $0, %edx
	divl %ebx
	
	addb $48, %dl
	cmpb $'9', %dl
	movb %dl, (%esi)
	incl %esi
	jmp petlja
	
kraj_konverzije:
	movb $0, (%esi)
	decl %esi
	movl $izlaz,%edi
obrtanje:
	cmpl %edi, %esi
	jle kraj
	movb (%edi),%al
	movb (%esi),%cl
	movb %al, (%esi)
	movb %cl, (%edi)
	incl %edi
	decl %esi
	jmp obrtanje

kraj:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
	
