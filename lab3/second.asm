format ELF64 
 
public _start 
public print_num
public str_number
 
include 'func.asm' 
 
section '.bss' writable 
  ;buffer db ?
  a dq ?
  b dq ?
  c dq ?
  output dq 0

;((((a/c)-a)-b)-c)
_start:
    ; Сохраним указатель на массив аргументов
    mov     rsi, [rsp + 16]      ; В rsi - указатель на argv
    call str_number
    mov [a], rax

    mov     rsi, [rsp + 24]       ; Получаем 1-й аргумент (argv[1])
    call str_number
    mov [b], rax
    mov     rsi, [rsp + 32]
    call str_number
    mov [c], rax

  xor rax,rax
  ;add rax, a
  ;add rax, b
  ;add rax, c

  mov rax,[a]
  div [c]
  sub rax, [a]
  sub rax, [b]
  sub rax, [c]


  call print_num
  call exit