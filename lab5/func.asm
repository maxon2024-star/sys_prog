;Function exit 
exit:
    mov rax,1
    mov rbx,0
    int 0x80

;Function printing of string
;input rsi - place of memory of begin string
print_str:
    push rax
    push rdi
    push rdx
    push rcx
    mov rax, rsi
    call len_str
    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    syscall
    pop rcx  
    pop rdx
    pop rdi
    pop rax
    ret

;The function makes new line
new_line:
   push rax
   push rdi
   push rsi
   push rdx
   push rcx
   mov rax, 0xA
   push rax
   mov rdi, 1
   mov rsi, rsp
   mov rdx, 1
   mov rax, 1
   syscall
   pop rax
   pop rcx
   pop rdx
   pop rsi
   pop rdi
   pop rax
   ret


;The function finds the length of a string
;input rax - place of memory of begin string
;output rax - length of the string
len_str:
  push rdx
  mov rdx, rax
  .iter:
      cmp byte [rax], 0
      je .next
      inc rax
      jmp .iter
  .next:
     sub rax, rdx
     pop rdx
     ret
     
;Function converting the string to the number
;input rsi - place of memory of begin string
;output rax - the number from the string
;Function converting the string to the number
;input rsi - place of memory of begin string
;output rax - the number from the string
str_number:
    push rcx
    push rbx

    xor rax,rax
    xor rcx,rcx
    xor r8, r8
    cmp byte [rsi], '-'
    jne .loop
    inc rcx
    mov r8, 1
    
.loop:
    xor     rbx, rbx
    mov     bl, byte [rsi+rcx]
    cmp     bl, 48
    jl      .finished
    cmp     bl, 57
    jg      .finished

    sub     bl, 48
    add     rax, rbx
    mov     rbx, 10
    mul     rbx
    inc     rcx
    jmp     .loop

.finished:
    cmp     rcx, 0
    je      .restore
    mov     rbx, 10
    div     rbx

.restore:
    pop rbx
    pop rcx
    cmp r8, 1
    jne .fin
    neg rax
.fin:
xor r8, r8
ret

print:
push rcx
mov [output], rax
mov eax, 1
mov edi, 1
mov rsi, output
mov edx, 1
syscall
pop rcx
ret

; rax input

print_num:
xor rbx, rbx
mov rcx, 10
test rax, rax
jns .loop
push rax
mov rax, '-'
call print
pop rax
neg rax

.loop:
xor rdx, rdx
div rcx
push rdx
inc rbx
cmp rax, 0
jne .loop

.print_loop:
pop rax
add rax, 48
call print
dec rbx
cmp rbx, 0
jne .print_loop
call new_line
ret

; inp - rsi
input_keyboard:
  push rax
  push rdi
  push rdx

  mov rax, 0
  mov rdi, 0
  mov rdx, 255
  syscall

  xor rcx, rcx
  .loop:
     mov al, [rsi+rcx]
     inc rcx
     cmp rax, 0x0A
     jne .loop
  dec rcx
  mov byte [rsi+rcx], 0
  
  pop rdx
  pop rdi
  pop rax
  ret