all : power

power : power.o
	ld power.o -o power

power.o :
	nasm -f elf64 power.s -o power.o

clean :
	rm power power.o 
