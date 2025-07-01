.section .data
	broj: .ascii "+12345\0"
.section .text
.global main
main:
	movl $broj, %esi #prebacis citav string u esi
	movl $0, %eax #konvertobani broj
	movl $10, %ebx #baza konverzije
	movl $0, %ecx
	movl $1, %edi
	
	cmpl $2, %ebx 	#baza ne moze bit manja od 2 ni veca od 36
	jl greska_baza
	cmpl $36, %ebx
	jg greska_baza
	
	cmpl $'+', (%esi) #provjeravas da li je poz ili neg
	je prvi_znak
	cmpl $'-', (%esi)
	jne petlja
	negl %edi #ako je negativan negiras jednicu i na kraju konverzije pomnozis broj sa tim brojem
prvi_znak:
	incl %esi # povecas esi da predjes na broj da ne gledas plus i minus kao broj
petlja:
	cmpl $0, (%esi)
	je kraj		
	movb (%esi), %cl
	subb $48, %cl	# oduzmes da bi dobio broj
	mull %ebx #mnozis malo prije da bi imo neku nevezanu nulu na kraju konverzije
	jc greska # ako dodje do prekoracenja pri mnozenju ili pri sabiranju
	addl %ecx, %eax
	jc greska
	incl %esi
	jmp petlja
greska_baza:
	....
kraj:
	mull %edi
	movl $1, %eax
	movl $0, %ebx
	int $0x80
