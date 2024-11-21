format ELF64

public _start

include 'func.asm'

section '.bss' writable 
  output dq 0
  input dq 0
  string rb 255
  s db ?


section '.text' executable
  _start:
    mov rax, 0
    mov rdi, 0
    mov rsi, input
    call input_keyboard
    mov rsi, input

    call str_number
    xor r8, r8

    ;rax- number
    xor r11, r11 ; rev_number
    xor r9, r9 ; digits
    
    .su:  
        
     xor rdx, rdx
     ; делим rax на rcx остаток в rdx       
    xor rcx, rcx
    mov rcx,10     
    div rcx

    imul r11, 10
    add r11, rdx

    cmp rax, 0
    jg .su

  xor rax, rax
  mov rax, r11
  call print_num
  call exit
