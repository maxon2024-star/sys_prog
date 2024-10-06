format ELF64
public _start

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

.loop: 




.l2:
  mov rdi, r8
  mov rax, 3
  syscall

  mov rdi, r9
  mov rax, 3
  syscall

.l1:
  call exit