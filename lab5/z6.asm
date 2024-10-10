format ELF64
public _start
public asc_comp
include 'func.asm'

section '.bss' writable
  buf db 1

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
  mov rsi, 577
  mov rdx, 777o
  syscall
  cmp rax, 0
  jl .l1

  mov r9, rax

  mov r10, rax ; длина файла

  xor rbx, rbx

;тут пытаемся нормально записать буфер
.loop: 
mov rsi, buf
call asc_comp

  mov rax, 0
  mov rdi, r8
  mov rsi, buf
  mov rdx, 1
  syscall


.l2:
  mov rdi, r8
  mov rax, 3
  syscall

  mov rdi, r9
  mov rax, 3
  syscall

.l1:
  call exit


asc_comp:
mov byte rax, rsi
cmp rax,65
jne .a

; out
  ret


.a:
cmp rax,97
jne .E

; out
  ret


.E:
cmp rax,69
jne .e

; out
  ret


.e:
cmp rax,101
jne .I

; out
  ret


.I:
cmp rax,73
jne .i

; out
  ret


.i:
cmp rax,105
jne .O

; out
  ret


.O:
cmp rax,79
jne .o

; out
  ret


.o:
cmp rax,111
jne .U

; out
  ret


.U:
cmp rax,85
jne .u

; out
  ret


.a:
cmp rax, 117
jne .not_gl

; out
  ret


.not_gl:
  ret