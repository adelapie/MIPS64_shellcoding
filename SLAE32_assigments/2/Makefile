
all: reverse_tcp shellcode main

reverse_tcp: reverse_tcp.o
	gcc reverse_tcp.s -m32 -o reverse_tcp
reverse_tcp.o:
	gcc -c reverse_tcp.s -m32 -o reverse_tcp.o
shellcode:
	./create.sh reverse_tcp.o
main:
	gcc -m32 -fno-stack-protector -z execstack main.c -o main
clean:
	rm -f main reverse_tcp reverse_tcp.o