.section .data
	broj_naredbi: .ascii "3\n"
	
	poruka1: .ascii "Unesite naredbu: \0"
	poruka1_len = .-poruka1
	
	naredba_max = 51
	naredba: .fill str_max,1,0
	
	R1: .long 0
	
	indikator_operacije: .long 0 # 0 -> -, 1 -> +, 2-> *
	
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
	movl %eax,%edi
petlja_operacije:
	cmpl $0, %edi
	je kraj_naredbi
	
	movl $4,%eax 
	movl $1,%ebx
	movl $poruka1,%ecx 
	movl $poruka1_len,%edx 
	int $0x80
	
	movl $3,%eax
	movl $0,%ebx
	movl $naredba,%ecx  
	movl $naredba_max,%edx
	int $0x80
	# primjer naredbe-> ADD 0x123.%R1
	movl $naredba,%esi
	
	cmpb $'A', (%esi)
	je sabiranje
	cmpb $'M', (%esi)
	je mnozenje
	movl $0,indikator_operacije
	jmp konverzija
sabiranje:
	movl $1,indikator_operacije
	jmp konverzija
mnozenje:
	movl $2, indikator_operacije
	jmp 
konverzija:
	#movl $broj, %esi u esiji je vec string
	movl $0,%eax
	movl $16, %ebx
	movl $0,%ecx    #ovde ne treba provjera za 0 i x 
	addl $7, %esi #jer tek ti brojevi krecu na 8 mjestu
petlja_heksadecimalni:
	cmpb $',', (%esi) #broj ti se zavrsava sa , ne sa enter
	je kraj_naredbe
	movb (%esi), %cl
	subb $48, %cl
	cmpb $10, %cl
	jl cifra
	subb $7, %cl
	cmpb $16, %cl
	jl cifra
	subb $32, %cl
cifra:
	mull %ebx
	addl %ecx, %eax
	incl %esi
	jmp petlja_heksadecimalni
kraj_naredbe:
	cmpl $0,indikator_operacije
	je oduzmi
	cmpl $1,indikator_operacije
	je saberi
	#a inace mnozi
	movl R1, %ecx
	movl %eax, R1
	movl %ecx,%eax
	mull R1
	movl %eax, R1
	#OVIM DOBIJE DA TI JE REZULTAT U EAXU I SAMO GA POMJERIS U R1 JER MORAS DA MNOZIS SA %EAX KONTAS
	jmp sledeca_naredba
oduzmi:
	subl %eax,R1
	jmp sledeca_naredba
saberi:
	addl %eax,R1
sledeca_naredba:
	decl %edi
	jmp petlja_operacije
greska:
kraj_naredbi:
	movl R1, %eax
	movl $izlaz,%esi
	movl $10, %ebx
petlja_konv:
	cmpl $0, %eax
	je kraj_konverzije1 #on je ovde stabio da skace na kraj
	movl $0,%edx
	divl %ebx
	
	addb $48, %dl
	cmpb $'9', %dl
	movb %dl, (%esi)
	incl %esi
	jmp petlja_konv
kraj_konverzije1:
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
	
	
