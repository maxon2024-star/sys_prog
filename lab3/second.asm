format ELF64 
 
public _start 

 
include 'func.asm' 
 
section '.bss' writable 
  buffer db ?

_start:
    ; Сохраним указатель на массив аргументов
    mov     rsi, [rsp + 16]      ; В rsi - указатель на argv
    mov     rdi, [rsi + 8]       ; Получаем 1-й аргумент (argv[1])

