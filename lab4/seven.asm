format ELF64

public _start

include '/workspaces/sys_prog/lab3/func.asm'

section '.bss' writable 
  output dq 0
  string rb 255
  s db ?


section '.text' executable
  _start:
  mov rax, 0
    mov rdi, 0
    mov rsi, string
    call input_keyboard
    mov rax, string
    call len_str
    mov rbx, rax

     mov rcx, rax
    dec rcx
    mov al, [string]
    mov byte [s], al


     ;inc rcx
    .iter:
        push rcx
        push rax
        mov al, [string+rcx]
        call print_symb
        pop rax
        pop rcx
        dec rcx
        cmp rcx, 0
        jne .iter ; выход как только 0

    mov al, [s]
    ;dec rcx    
    ;mov al, [string]
    ;call print_str
    ;mov al, bl
    call print_symb
    call exit
    

print_symb:
  mov [string], al
  mov rax, 4
  mov rbx, 1
  mov rcx, string
  mov rdx, 1
  int 0x80
  ret
