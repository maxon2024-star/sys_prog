format ELF64

public _start

include '/workspaces/sys_prog/lab3/func.asm'

section '.bss' writable 
  output dq 0
  string dq ?

section '.text' executable
  _start:
  mov rax, 0
    mov rdi, 0
    mov rsi, string
    mov rdx, 255
    syscall
    mov rax, string
    call len_str
    mov byte [string + rax], 0
    mov rbx, rax
    call str_number
    xor r8, r8

     mov rcx, rax
    .iter:
        push rcx
        mov rax, [string+rcx]
        call print_symb
        pop rcx
        dec rcx
        cmp rcx, 0
        jne .iter ; выход как только 0

    call print_symb
    call exit
    
