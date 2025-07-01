.section .data
	broj: .ascii "[5,10]{1,3,5,7,10,25,30,}ostatak se ne posmatra\n"
	donja_granica: .long 0 #znaci imas neki interval koji je zadtat na pocetku stringa u kockastim zagradama i onda u viticastim trazis brojeve koji su u tom intervalu i sabiras ih i koje nisu isto
	gornja_granica: .long 0
	suma_intervala: .long 0
	suma_izvan: .long 0
	
	izlaz: .ascii ""
.section .text
.global main
main:
	movl $broj, %esi
	movl $0, %eax
	movl $10, %ebx
	movl $0, %ecx
	incl %esi #ovo radis da odma predjes na broj [->5
petlja_donja:
	cmpb $',', (%esi)
	je naso_broj
	movb (%esi), %cl
	subb $48, %cl
	mull %ebx
	jc greska
	addl %ecx, %eax
	jc greska
	incl %esi
	jmp petlja_donja
nasao_broj:
	movl %eax, donja_granica
	movl $0, %eax
	incl %esi
#znaci naso si pocetak intervala sad propads na petlju za kraj
petlja_gornja:
	cmpb $',', (%esi)
	je naso_broj2
	movb (%esi), %cl
	subb $48, %cl
	mull %ebx
	jc greska
	addl %ecx, %eax
	jc greska
	incl %esi
	jmp petlja_gornja
nasao_broj2:
	movl %eax, gornja_granica
	movl $0, %eax
	addl $3, %esi #ovo radis da preskocis zagrde 
petlja_niz:
	cmpb $'}', (%esi)
	je kraj_niz
	cmpb $',', (%esi)
	je naso_broj_niz
	movb (%esi), %cl
	subb $48, %cl
	mull %ebx
	jc greska
	addl %ecx, %eax
	jc greska
	incl %esi
	jmp petlja_niz
naso_broj_niz:
	cmpl donja_granica, %eax
	jb izvan_int
	cmpl gornja_granica
	ja izvan_int
	
	addl %eax, suma_intervala
	jmp sledeci_broj_niz
izvan_int
	addl %eax, suma_izvan
sledeci_broj_niz:
	incl %esi
	movl $0,%eax
	jmp petlja_niz
kraj_niz:
	movl suma_intervala, %eax
	cmpl suma_izvan,%eax
	ja unutar_veca
unutar_manja:
unutar_veca:
#korisniku treva da ispises vecu sumu u heksadecimalnom broju
	movl $16, %ebx
	movl $izlaz, %esi
	movl $'0', (%esi)
	#incl %esi #ne znam trebas li ovo radit on nije mada ima logike
	movl $'x', 1(%esi)
	addl $2, %esi
	#znaci ovo vazda moras uradit kod konvezije restartujes bazu napravis prazna string i sibas u njega taj konvertovani
petlja:
	cmpl $0, %eax
	je kraj_konverzije
	movl $0, %edx
	divl %ebx
	
	addb $48, %dl
	cmpb $'9', %dl
	jle cifra
	addb $7, %dl
cifra:
	movb %dl, (%esi)
	incl %esi
	jmp petlja
kraj_konverzije:
	movb $0, (%esi)
	decl %esi
	movl $0, %edi
	addl $2, %edi
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
greska:
kraj:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
	
