format elf64
public _start

include 'func.asm'


section '.data' writable

f  db "/dev/urandom",0

section '.bss' writable
  output dq ?
  number rq 1
  place rb 255
  min dq ?
  max dq ?
  num dq ?
  win db 'You win!!'
  less db 'Less'
  greater db 'Greater'

section '.text' executable

_start:
   mov rdi, f
   mov rax, 2 
   mov rsi, 0o
   syscall 
   cmp rax, 0 
   jl .l1 
   mov r8, rax

   mov rax, 0 
   mov rdi, r8
   mov rsi, number
   mov rdx, 1
   syscall

    mov     rsi, [rsp + 16]      ; В rsi - указатель на argv
    call str_number
    mov [min], rax

    mov     rsi, [rsp + 24]       ; Получаем 1-й аргумент (argv[1])
    call str_number
    mov [max], rax
  

  sub rax, [min]
  inc rax
  mov [max], rax

  ; делим rax на rcx остаток в rdx    
  xor rdx, rdx
  xor rax, rax
  xor rdx,rdx
  mov rcx,[max]
  mov rax, [num]
  div rcx

  ;итоговое число записыываем в num
  add rdx, [min]
  mov [num], rdx

  mov rax, [num]
   call print_num
   call new_line

  .loop:
  xor rsi,rsi
  mov rsi, place
  call input_keyboard
  mov rax, place
  call str_number

  cmp rax, [num]
  je .end

  cmp rax, [num]
  jl .greater

  cmp rax, [num]
  jg .less

  .less:
   mov rsi, less
   call print_str
   call new_line
   jmp .loop
   
   .greater:
   mov rsi, greater
   call print_str
   call new_line
   jmp .loop

  .end:
   mov rax, [num]
   call print_num
   call new_line
   jmp .l1


.l1:
  mov rsi, win
  call print_str
  call exit