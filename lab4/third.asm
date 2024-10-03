format ELF64
public _start
include '/workspaces/sys_prog/lab3/func.asm'
section '.bss' writable 
  n dq ?
  output dq ?


section '.text' executable 
 _start:
    mov rax, 0
    mov rdi, 0
    mov rsi, n
    mov rdx, 255
    syscall
    mov rax, n
    call len_str
    mov byte [n + rax], 0
    call str_number
    xor r8, r8


    xor rsi,rsi
    xor rdi,rdi ; summa
    mov rsi, rax    ; schetchik    
    xor rbx, rbx   ; promez res    
    xor rdx, rdx   ; peremennaya
    .su:     
    xor rdx, rdx
     xor rbx, rbx
     mov rdx, rsi

     add rbx, rdx ; i     

     inc rdx
     imul rbx, rdx ; i(i+1)
     dec rdx
     imul rdx, 3 
   
     inc rdx
     imul rbx, rdx ;i(i+1)(3i+1)

     inc rdx
     imul rbx, rdx ; i(i+1)(3i+1)(3i+2) 
   
     ; считаем минус или +     
     xor rdx, rdx
     ; делим rax на rcx остаток в rdx    
      xor rax,rax
     mov rax,rsi     
     xor rcx, rcx
     mov rcx,2     
    div rcx
     cmp rdx,0    
     je .fl1
      neg rbx
     .fl1:
     add rdi,rbx ; summiruem
     dec rsi
     mov rax, rdi
     cmp rsi, 0     
  jne .su

;mov rax, [sum]
mov rax, rdi
call print_num
call exit