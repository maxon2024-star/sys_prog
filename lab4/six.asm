format ELF64

public _start

include '/workspaces/sys_prog/lab3/func.asm'

section '.bss' writable 
  output dq 0
  input dq ?
  ;sum dq 0
  ;n dq ?

section '.text' executable
  _start:
    mov rax, 0
    mov rdi, 0
    mov rsi, input
    mov rdx, 255
    syscall
    mov rax, input
    call len_str
    mov byte [input + rax], 0
    call str_number
    xor r8, r8

    ;mov rbx, rax ; число
    mov rsi, rax ; счетчик
    xor rdi, rdi ; n чисел
    mov rdi,0

  .su:
     xor rax,rax
     cmp rsi,9
     jg .f1
    
    inc rdi
    mov rax, rdi
    call print_num
    call exit  

     .f1:
     mov rax,rsi     
     xor rcx, rcx
     mov rcx,5     
     div rcx
     cmp rdx,0 
     je .fl1

     dec rsi
     cmp rsi,0
     jne .su

     .fl1:
     cmp rsi, 22
     jl .fl3

     xor rax,rax
     mov rax,rsi     
     xor rcx, rcx
     mov rcx,21     
     div rcx
     cmp rdx,0 
     jg .fl2

     dec rsi
     cmp rsi,0
     jne .su

     .fl2:
     add rdi,1
     dec rsi
     cmp rsi,0
     jne .su

     .fl3:
     cmp rsi, 20
     jl .fl4

     add rdi,3
     mov rax, rdi
     call print_num
     call exit 

     .fl4:
     cmp rsi, 10
     jl .fl5

     add rdi,2
     mov rax, rdi
     call print_num
     call exit 

     .fl5:
     cmp rsi, 5
     jl .su

     add rdi,1
     mov rax, rdi
     call print_num
     call exit
     



inc rdi
mov rax, rdi
call print_num
call exit  
