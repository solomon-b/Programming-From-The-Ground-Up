all : exit maximum power factorial toupper spongebob

spongebob: mkBuildDir
	nasm -f elf64 src/spongebob.s -o build/spongebob.o
	ld build/spongebob.o -o build/spongebob
	rm build/spongebob.o

toupper: mkBuildDir
	nasm -f elf64 src/toupper.s -o build/toupper.o
	ld build/toupper.o -o build/toupper
	rm build/toupper.o

factorial: mkBuildDir
	nasm -f elf64 src/factorial.s -o build/factorial.o
	ld build/factorial.o -o build/factorial
	rm build/factorial.o

power : mkBuildDir
	nasm -f elf64 src/power.s -o build/power.o
	ld build/power.o -o build/power
	rm build/power.o

maximum : mkBuildDir
	nasm -f elf64 src/maximum.s -o build/maximum.o
	ld build/maximum.o -o build/maximum
	rm build/maximum.o

exit : mkBuildDir
	nasm -f elf64 src/exit.s -o build/exit.o
	ld build/exit.o -o build/exit
	rm build/exit.o

mkBuildDir:
	mkdir -p build

clean :
	rm -rf build
