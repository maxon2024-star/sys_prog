format ELF64
public _start
include 'func.asm'
section '.bss' writable 
  n dq ?
  output dq ?


section '.text' executable 
 _start:
    mov     rsi, [rsp + 16]      ; В rsi - указатель на argv
    call str_number
    mov [n], rax
    xor r8, r8

    xor rcx,rcx ; summa       
    xor rbx, rbx   ; promez res    
    xor rdx, rdx   ; peremennaya
    mov rbx,1   ; schetchik
    mov rdx,1
    add rcx, rbx

    cmp rax, 1
    jl .fl

    cmp rax, 1
    je .fl1

    .su:     
        imul rdx,10
        inc rdx  
        add rcx,rdx

        inc rbx
        cmp rbx, rax    
        jne .su

    .fl1:
    mov rax, rcx
    call print_num
    call exit

    .fl:
    mov rax, 0
    call print_num
    call exit