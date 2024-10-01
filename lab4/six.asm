format ELF64

public _start

include '/workspaces/sys_prog/lab3/func.asm'

section '.bss' writable 
  output dq 0
  ;sum dq 0
  n dq ?

section '.text' executable
  _start:
    mov     rsi, [rsp + 16]      ; В rsi - указатель на argv
    call str_number
    mov [n], rax