format ELF64

public _start

include 'func.asm'

section '.bss' writable 
  output dq 0
  input rb 255
  ;sum dq 0
  ;n dq ?

section '.text' executable
  _start:
    mov rax, 0
    mov rdi, 0
    mov rsi, input
    call input_keyboard
    mov rsi, input
    ;call len_str
    ;mov byte [input + rax], 0
    call str_number
    xor r8, r8

    mov rbx, rax ; исх число
    xor rdi, rdi ; n чисел
    cmp rax, 5
    jl .end1
    mov rsi, 5 ; счетчик

    
  .su:

     xor rcx, rcx
     xor rdx,rdx

     cmp rsi, rbx
     jg .end1

     .fl1:
     xor rax,rax
     mov rax,rsi     
     xor rcx, rcx
     xor rdx,rdx
     mov rcx,7     
     div rcx
     cmp rdx,0 
     jg .fl2

     add rsi, 5
     cmp rsi, rbx
     jg .end1

    .fl2:
     xor rax,rax
     mov rax,rsi     
     xor rcx, rcx
     xor rdx,rdx
     mov rcx,3     
     div rcx
     cmp rdx,0 
     jg .fl3

     add rsi, 5
     cmp rsi, rbx
     jg .end1


     .fl3:
     add rdi,1
     add rsi,5
     cmp rsi,rbx
     jl .su

    
.end1:
mov rax, rdi
call print_num
call exit  
