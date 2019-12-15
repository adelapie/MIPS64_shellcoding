#!/bin/sh

# egg_hunter generator with shellcode
# adp - 2018

usage() { echo "Usage: $0 -s shellcode.s" 1>&2; exit 1; }

while getopts ":s:" o; do
    case "${o}" in
        s)
            s=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done

shift $((OPTIND-1))

if [ -z "${s}" ]; then
    usage
fi

echo "s = ${s}"

gcc -m32 -c $s -o shellcode.o

cat > main.c << EOF
#include <stdio.h>
#include <string.h>

unsigned char egg[] = \
"\x90\x50\x90\x50\x90\x50\x90\x50"
EOF

./create.sh shellcode.o >> main.c

gcc -m32 -c egg_hunter.s -o egg_hunter.o

echo "unsigned char egghunter[] = \\" >> main.c
./create.sh egg_hunter.o >> main.c

cat >> main.c << EOF
int main (int argc, char ** argv)
{

  printf("Shellcode Length:  %d\n", strlen(egghunter));
  int (*ret)() = (int(*)()) egghunter;

  ret();
}
EOF

gcc -m32 -fno-stack-protector -z execstack main.c -o main

echo "[*] shellcode and egg hunter ready (main)"
 