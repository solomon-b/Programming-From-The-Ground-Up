all : maximum

maximum : maximum.o
	ld maximum.o -o maximum

maximum.o :
	nasm -f elf64 maximum.s -o maximum.o

clean :
	rm maximum maximum.o 
