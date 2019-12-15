
#include <stdio.h>
#include <string.h>

unsigned char exec_shellcode[] = \
"\xcd\x80";

main()
{
	int i = 0;
	
	printf("Shellexec_shellcode Length:  %d\n", strlen(exec_shellcode));

	for(i = 0; i < strlen(exec_shellcode); i++) {
	  	printf("0x%02x,", (((exec_shellcode[i] << 1) & 0xFF) | (exec_shellcode[i] >> (8-1))));	  	
	}

	/* shellcode end mark */
		
	printf("0x%02x,", 0xff);
}
