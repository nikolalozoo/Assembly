.section .data
	broj: .ascii "32 78 5 7 987\n"
	parna_suma: .long 0
	broj_parnih: .long 0
	neparna_suma: .long 0
	broj_neparnih: .long 0
.section .text
.global main
main:
	movl $broj, %esi
	movl $0, %eax
	movl $10, %ebx
	movl $0, %ecx
petlja:
	cmpb $10, (%esi)#gleda da li je dosa do kraj stringa [n]
	je posljednja_konverzija
	cmpb $32, (%esi)#gleda da li je naisao na spejs tj kraj broja
	je kraj_konverzije
	movb (%esi), %cl
	subb $48, %cl
	mull %ebx
	jc greska
	addl %ecx, %eax
	jc greska
	incl %esi
	jmp petlja
#kad zavrsis konverziju broj ostaje u eaxu 
kraj_konverzije:	
	testl $1, %eax
	jz paran # ako je 0 paran je inace je neparan
	addl %eax, neparna_suma
	incl broj_neparnih
	jmp sledeci_broj
paran:
	addl %eax, parna_suma
	incl broj_parnih
sledeci_broj:
	movl $0, %eax #nuliras eax da bi tu smjestio sledec broj
	incl %esi #predjes na sledeci broj jer si na spejsu tren
	jmp petlja
posljednja_konverzija:
	testl $1, %eax
	jz paran1 # ako je 0 paran je inace je neparan
	addl %eax, neparna_suma
	incl broj_neparnih
	jmp uporedi
paran1:
	addl %eax, parna_suma
	incl broj_parnih 
uporedi:
	#aritmetcka sredina parnih
	movl parna_suma,%eax
	movl $0,%edx
	divl broj_parnih
	movl %eax, %edi
	#aritmetcka sredina neparnih
	movl neparna_suma,%eax
	movl $0,%edx
	divl broj_neparnih
	
	cmpl %edi,%eax
	ja neparnih_vise 
	je jednako
	jmp parnih_vise
neparnih_vise:
jednako:
parnih_vise:
greska:
kraj:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
	
