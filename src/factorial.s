;PURPOSE - Given a number, this program computes the
; factorial. For example, the factorial of
; 3 is 3 * 2 * 1, or 6. The factorial of
; 4 is 4 * 3 * 2 * 1, or 24, and so on.
;
;This program shows how to call a function recursively.
section .data

section .text

global _start
global factorial 		; Only needed if we want to share this
				; function with other programs.
_start:
	push 6 			; Factorial takes one argument.
	call factorial 		; Run the factorial function
	mov rdi, rax 		; Factorial returns the answer in rax
				; but we want it in rdi to send as our
				; exit status.
	mov  rax, 60		; Exit (rdi is returned)
	syscall

factorial:
	push rbp 		; Save the old base pointer.
	mov rbp, rsp  		; We don't want to modify the stack
				; pointer so we use rbp.
	mov rax, [rbp + 16] 	; Move the argument to rax. (rbp + 8
				; holds the return address).
	cmp rax, 1 		; If argument is 1 then we are at the
				; base case.
	je end_factorial
	dec rax 		; Otherwise decrement rax.
	push rax 		; Push rax to the stack for our
				; recursive call.
	call factorial 		; Recurse.
	mov rbx, [rbp + 16]    	; Load the new parameter into rbx.
	imul rax, rbx 		; Multiply the parameter by the last
				; call to factorial and store in rax.

end_factorial:
	mov rsp, rbp
	pop rbp
	ret
