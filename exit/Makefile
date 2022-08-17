all : exit.o
	ld exit.o -o exit

exit.o :
	nasm -f elf64 exit.s -o exit.o

clean :
	rm exit exit.o 
