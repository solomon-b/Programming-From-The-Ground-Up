	;PURPOSE: This program finds the maximum number of a
	; set of data items.
	;
	;VARIABLES: The registers have the following uses:
	;
	; %rdi - Holds the index of the data item being examined
	; %rbx - Largest data item found
	; %rax - Current data item
	; %rcx - An iterator value for my while loop
	;
	; The following memory locations are used:
	;
	; data_items - contains the item data. A 0 is used
	; to terminate the data
	;
section .data
data_items: dq 3,67,34,222,45,75,54,34,44,33,22,11,66

data_length: dq 13

section .text

global _start
_start:
	mov  rcx, [data_length]          ; Load the list length into rcx
	mov  rdi, 0                      ; Load 0 into the index register
	mov  rax, [data_items + rdi * 8] ; Load the first byte of data
	mov  rbx, rax                    ; Since this is the first item. %rax holds the largest value

start_loop:
	cmp  rcx, 0                      ; Check if we have hit the end of the list
	je   loop_exit
	dec  rcx                         ; Decrement rcx by 1
	inc  rdi                         ; Increment the index
	mov  rax, [data_items + rdi * 8] ; Load the next byte of data

	cmp  rax, rbx                    ; Compare values
	jle  start_loop                  ; Jump to start of loop of rbx is larger then rax
	mov  rbx, rax                    ; Else move %eax to rbx.
	jmp  start_loop                  ; And jump to start of loop

loop_exit:
	mov  rax, 60                     ; Set status code to 1
	mov  rdi, rbx
	syscall
