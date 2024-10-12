format ELF64
public _start

include 'func.asm'

section '.bss' writable
  buf db 1
  output dq ?

_start:
  pop rcx
  cmp rcx, 1
  je .l1

  mov rdi,[rsp+8]
  mov rax, 2
  mov rsi, 0o
  syscall
  cmp rax, 0
  jl .l1

  mov r8, rax

  mov rdi,[rsp+16]
  mov rax, 2
  mov rsi, 1101o
  syscall
  cmp rax, 0
  jl .l1

  mov r9, rax

  xor rbx, rbx ; счетчик
;./a.out ot_input.txt ot_output.txt

;тут пытаемся нормально записать буфер
.loop: 
cmp rax, 0
je .next

push rcx
mov rax, 0
mov rdi, r8
mov rsi, buf
mov rdx, 1
syscall
pop rcx

cmp byte [buf], 'B'
je .sogl

cmp byte [buf], 'b'
je .sogl

cmp byte [buf], 'C'
je .sogl

cmp byte [buf], 'c'
je .sogl

cmp byte [buf], 'D'
je .sogl

cmp byte [buf], 'd'
je .sogl

cmp byte [buf], 'F'
je .sogl

cmp byte [buf], 'f'
je .sogl

cmp byte [buf], 'G'
je .sogl

cmp byte [buf], 'g'
je .sogl

cmp byte [buf], 'H'
je .sogl

cmp byte [buf], 'h'
je .sogl

cmp byte [buf], 'J'
je .sogl

cmp byte [buf], 'j'
je .sogl

cmp byte [buf], 'K'
je .sogl

cmp byte [buf], 'k'
je .sogl

cmp byte [buf], 'L'
je .sogl

cmp byte [buf], 'l'
je .sogl

cmp byte [buf], 'M'
je .sogl

cmp byte [buf], 'm'
je .sogl

cmp byte [buf], 'N'
je .sogl

cmp byte [buf], 'n'
je .sogl

cmp byte [buf], 'P'
je .sogl

cmp byte [buf], 'p'
je .sogl

cmp byte [buf], 'Q'
je .sogl

cmp byte [buf], 'q'
je .sogl

cmp byte [buf], 'R'
je .sogl

cmp byte [buf], 'r'
je .sogl

cmp byte [buf], 's'
je .sogl

cmp byte [buf], 'S'
je .sogl

cmp byte [buf], 'T'
je .sogl

cmp byte [buf], 't'
je .sogl

cmp byte [buf], 'V'
je .sogl

cmp byte [buf], 'v'
je .sogl

cmp byte [buf], 'W'
je .sogl

cmp byte [buf], 'w'
je .sogl

cmp byte [buf], 'X'
je .sogl

cmp byte [buf], 'x'
je .sogl

cmp byte [buf], 'Y'
je .sogl

cmp byte [buf], 'y'
je .sogl

cmp byte [buf], 'Z'
je .sogl

cmp byte [buf], 'z'
je .sogl

jmp .gl

.sogl:
mov rsi, buf
mov rdx, rax
mov rax, 1
mov rdi, r9
syscall
jmp .gl

.gl:
  inc rbx
  mov rsi, buf
  mov rdx, rax
  mov rax, 1
  mov rdi, r9
  syscall
  jmp .loop

.next:
mov rax, buf
call len_str
cmp rax, 0
je .l2
mov rsi, buf
mov rdx, rax
mov rax, 1
mov rdi, r9
syscall

.l2:
  mov rdi, r8
  mov rax, 3
  syscall

  mov rdi, r9
  mov rax, 3
  syscall

  call exit

.l1:
  call exit