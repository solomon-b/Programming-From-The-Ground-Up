	;PURPOSE: Program to illustrate how functions work
	; This program will compute the value of
	; 2^3 + 5^2
	;
	;Everything in the main program is stored in registers,
	;so the data section doesn’t have anything.
section .data
section .text
global _start
_start:
	push 3        ; push second argument
	push 2        ; push first argument
	call power    ; call the function
	add  rsp, 16  ; move the stack pointer back
	push rax      ; save the first answer before calling the next function

	push 2        ; push second argument
	push 5        ; push first argument
	call power    ; call the function
	add  rsp, 16   ; move the stack pointer back

	pop  rdi      ; pop the second answer off the stack.
	add  rdi, rax ; Add both answers and store in rbx.

	mov  rax, 60  ; Exit (rbx is returned)
	syscall

	;PURPOSE: This function is used to compute
	; the value of a number raised to
	; a power.
	;
	;INPUT:	First argument - the base number
	; Second argument - the power to
	; raise it to
	;
	;OUTPUT: Will give the result as a return value
	;
	;NOTES:	The power must be 1 or greater
	;
	;VARIABLES:
	; rbx - holds the base number
	; rcx - holds the power
	;
	; [rbp - 8] - holds the current result
	;
	; rax is used for temporary storage
	;
power:
	push rbp             ; Save old base pointer
	mov  rbp, rsp        ; Set the stack pointer to the base pointer
	sub  rsp, 8          ; Get room for local storage

	mov  rax, [rbp + 16] ; Put first argument in rax
	mov  rcx, [rbp + 24] ; Put second argument in rcx

	mov  [rbp - 8], rax  ; Store current result

power_loop_start:
	cmp  rcx, 0            ; If the power is 0, return 1
	je   zero_case
	cmp  rcx, 1            ; If the power is 1, we are done
	je   end_power
	mov  rbx, [rbp - 8]    ; Move the currrent result into rbx
	imul rbx, rax          ; Multiply the current result by the base number
	mov  [rbp - 8], rbx    ; Store the current result
	dec  rcx               ; Decrease the power
	jmp   power_loop_start ; Run the next power

end_power:
	mov  rax, [rbp - 8] ; Return value goes in rax
	mov  rsp, rbp       ; Restore the stack pointer
	pop  rbp            ; Restore the base pointer
	ret

zero_case:
	mov  rax, 0
	mov  rsp, rbp       ; Restore the stack pointer
	pop  rbp            ; Restore the base pointer
	ret
	
