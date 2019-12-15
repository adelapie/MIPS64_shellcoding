
all: shell_bind_tcp shellcode main

shell_bind_tcp: shell_bind_tcp.o
	gcc shell_bind_tcp.s -m32 -o shell_bind_tcp
shell_bind_tcp.o:
	gcc -c shell_bind_tcp.s -m32 -o shell_bind_tcp.o
shellcode:
	./create.sh shell_bind_tcp.o
main:
	gcc -m32 -fno-stack-protector -z execstack main.c -o main
clean:
	rm -f main shell_bind_tcp shell_bind_tcp.o