	;PURPOSE: build an output file from an input file with all
	;characters converted to spongecase.
	;
	;PROCESSING:
	; 1. Open the input file.
	; 2. Open the output file.
	; 3. While we're not at the end of the file:
	;    A. Read part of the input file into the memory buffer.
	;    B. Go through each byte of memory. If the byte is a
	;    lowercase letter, then convert it to uppercase.
	;    C. Write the memory buffer to the output file.

	;; CONSTANTS
section .data
	; System call numbers
	sys_read equ 0
	sys_write equ 1
	sys_open equ 2
	sys_close equ 3
	sys_exit equ 60

	; Options for open (look at /usr/include/asm/fcntl.h for
	; various values. You can combine them by adding them or ORing
	; them). This is discussed at greater length in "Counting
	; Like a Computer"
	rdonly equ 0
	creat_wrongly_trunc equ 0o1101

	; Standard file descriptors
	stdin equ 0
	stdout equ 1
	stderr equ 2

	; The return value of read, which means we've hit the end of
	; the file.
	eof equ 0
	num_args equ 2

        ;; constants for the case conversion function.
	; Lower boundary of the search.
	lowercase_a equ 'a'
	; Upper boundary of the search.
	lowercase_z equ 'z'
	; Conversion between upper and lower case
	upper_conversion equ 'A' - 'a'

	; Conversion function buffer length
	st_buffer_len equ 16
	; Conversion function buffer
	st_buffer equ 24

section .bss
        ;; Reserve read/write buffer
	buffer_size equ 500

buffer_data: resb buffer_size

section .text
	;; Stack Positions
	st_size_reserve equ 16
	st_fd_in equ -8
	st_fd_out equ -16
	st_argc equ 0
	st_argv_0 equ 8
	st_argv_1 equ 16
	st_argv_2 equ 24

global _start
_start:
	;; Initialize Program
	mov rbp, rsp

	; Allocate space for our file descriptors on the stack.
	sub rsp, st_size_reserve
	; Initialize file descripter variables with stdin and stdout
	mov byte [rbp + st_fd_in], stdin
	mov byte [rbp + st_fd_out], stdout

	; Skip reading files if no args provided
	cmp byte [rbp + st_argc], 1
	je read_loop_begin
	
open_files:
open_fd_in:
	; open syscall
	mov rax, sys_open
	; input filename into rdi
	mov rdi, [rbp + st_argv_1]
	; set read only flag in rsi
	mov rsi, rdonly
	; set permissions (not important for reading)
	mov rdx, 0o666
	; call Linux
	syscall

store_fd_in:
	; Save the input file descriptor
	mov [rbp + st_fd_in], rax

open_fd_out:
	; Open output file
	mov rax, sys_open
	; output filename into rdi
	mov rdi, [rbp + st_argv_2]
	; set flags for writing to the file
	mov rsi, creat_wrongly_trunc
	; set permissions for new file
	mov rdx, 0o666
	; call Linux
	syscall

store_fd_out:
	; Store output file descriptor
	mov [rbp + st_fd_out], rax

read_loop_begin:
	; Read in a block from the input file
	mov rax, sys_read
	; get the input file descriptor
	mov rdi, [rbp + st_fd_in]
	; set the location to read into
	mov rsi, buffer_data
	; set the size of buffer
	mov rdx, buffer_size
	syscall

	; Check for end of file marker
	cmp rax, eof
	; if found or on error, jump to the end
	jle end_loop

continue_read_loop:
	;; Convert the block to upper case
	; Push the location and size of the buffer to the stack.
	push buffer_data
	push rax
	call convert_to_upper
	; get the size back?
	pop rax
	; restore the stack pointer
	add rsp, 8

	;; Write the block out to the output file
	; size of the buffer
	mov rdx, rax
	mov rax, sys_write
	; file to use
	mov rdi, [rbp + st_fd_out]
	; location of the buffer
	mov rsi, buffer_data
	syscall

	jmp read_loop_begin

end_loop:
	;; Close the files
	; NOTE: We don't need to do error checking on these, because
	; error conditions don't signify anything special here.
	mov rax, sys_close
	mov rdi, [rbp + st_fd_out]
	syscall

	mov rax, sys_close
	mov rdi, [rbp + st_fd_in]
	syscall

	; Exit
	mov rax, sys_exit
	mov rdi, 0
	syscall

	; Purpose: Case conversion function
        ; Input: The first parameter is the length of the block of
        ; memory to convert. The second is the starting address of
        ; that block of memory.
	; Output: This function overwrites the current buffer with the
	; upper-casified version.
	; Variables:
	;   rax - The beginning of the buffer
	;   rbx - The length of the buffer
	;   rdi - The current buffer offset
	;   cl  - Current byte being examined (first part of ecx)
convert_to_upper:
	push rbp
	mov rbp, rsp

	; Setup the variables
	mov rax, [rbp + st_buffer]
	mov rbx, [rbp + st_buffer_len]
	mov rdi, 0

	; If a buffer with a zero length was given, then end.
	cmp rbx, 0
	je end_convert_loop

convert_loop:
	; Get the current byte
	mov cl, [rax + rdi]

	; Go to the next byte unless it is between 'a' and 'z'.
	cmp cl, lowercase_a
	jl next_byte
	cmp cl, lowercase_z
	jg next_byte

	; Otherwise convert the byte to uppercase.
	add cl, upper_conversion
	; And store it.
	mov [rax + rdi], cl

next_byte:
	; Increment the byte offset
	inc rdi
	inc rdi
	; continue, unless we've reached the end of the buffer.
	cmp rbx, rdi
	jne convert_loop

end_convert_loop:
	; terminate without a return value.
	mov rsp, rbp
	pop rbp
	ret

fail:
	mov rax, sys_exit
	mov rdi, 1
	syscall
