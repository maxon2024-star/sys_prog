format elf64

public _start

extrn usleep

include "func.asm"

section '.data' writable
msg db "Hi, I am process number ", 0
msg_end db "Parent process finished. Terminating process.", 0xA, 0
buffer db 0
pid1 dq 1
pid2 dq 1
output dq ?
	
section '.text' executable	

;fasm z2.asm && ld z2.o -lc -lm -dynamic-linker /lib64/ld-linux-x86-64.so.2 -o z2.out
_start:
    pop rax
    cmp rax, 2
    jl finale

    ;input
    mov rsi, [rsp+8]
    call str_number

    ;parenting
    push rax
    mov rax, 57
    syscall
    pop r8
    cmp rax, 0
    je child

    mov [pid1], rax
    mov rax, 62
    mov rsi, 19
    mov rdi, [pid1]
    syscall

    mov rax, 57
    syscall
    cmp rax, 0
    je child

    mov [pid2], rax
    mov rax, 62
    mov rsi, 19
    mov rdi, [pid2]
    syscall
    jmp parent

child:
    mov rsi, msg
    call print_str
    mov rax, 39
    syscall

    mov rsi, buffer
    call number_str
    call print_str
    call new_line

    push r8
    mov rdi, 3000
    call usleep
    pop r8
    dec r8

    cmp r8, 0
    jg child
    call exit

parent:
    mov rax, 62
    mov rsi, 18
    mov rdi, [pid1]
    syscall

    push r8
    mov rdi, 2000
    call usleep

    mov rax, 62
    mov rsi, 19
    mov rdi, [pid1]
    syscall

    mov rax, 62
    mov rsi, 18
    mov rdi, [pid2]
    syscall

    mov rdi, 2000
    call usleep

    mov rax, 62
    mov rsi, 19
    mov rdi, [pid2]
    syscall

    pop r8
    dec r8
    cmp r8, 0
    jg parent

    call new_line
    mov rsi, msg_end
    call print_str
    
finale:
    call exit