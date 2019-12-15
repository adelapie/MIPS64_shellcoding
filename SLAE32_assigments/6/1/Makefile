
all: decoder.o shellcode main

decoder.o:
	gcc -c decoder.s -m32 -o decoder.o
shellcode:
	./create.sh decoder.o
main:
	gcc -m32 -fno-stack-protector -z execstack main.c -o main
clean:
	rm -f main decoder decoder.o