section .data
section .text

global _start
_start:
	mov rdi, [rsp + 16]
	mov rax, 60
	syscall
