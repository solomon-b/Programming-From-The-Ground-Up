ifeq ($(PREFIX),)
    PREFIX := /usr/local
endif

all : maximum

maximum : maximum.o
	ld maximum.o -o maximum

maximum.o :
	as maximum.s -o maximum.o

clean :
	rm maximum maximum.o 
