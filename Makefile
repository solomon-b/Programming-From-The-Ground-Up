all : exit maximum power factorial

factorial: factorial.o
	ld build/factorial.o -o build/factorial
	rm build/factorial.o

factorial.o:
	nasm -f elf64 src/factorial.s -o build/factorial.o

power : power.o
	ld build/power.o -o build/power
	rm build/power.o

power.o :
	mkdir -p build
	nasm -f elf64 src/power.s -o build/power.o

maximum : maximum.o
	ld build/maximum.o -o build/maximum
	rm build/maximum.o

maximum.o :
	mkdir -p build
	nasm -f elf64 src/maximum.s -o build/maximum.o

exit : exit.o
	ld build/exit.o -o build/exit
	rm build/exit.o

exit.o :
	mkdir -p build
	nasm -f elf64 src/exit.s -o build/exit.o

clean :
	rm -rf build
