format elf64
    ;include 'func.asm'

	public create_array
	public free_memory
    public gen_random
    public fill_rnum

    public count_prime
    public count_prime_check
    public count_end_1

    public add_end
    public del_beg

    f  db "/dev/urandom",0

    section '.data' writable

	section '.bss' writable
        number rq 1
        array_begin rq 1
        count rq 1



;rdi - n of mas
create_array:
	mov [count], rdi
	;; Получаем начальное значение адреса кучи
	xor rdi,rdi
	mov rax, 12
	syscall

	mov [array_begin], rax
	mov rdi, [array_begin]
	add rdi, [count]
	mov rax, 12
	syscall
	mov rax, array_begin
	ret

free_memory:
	xor rdi,[array_begin]
	mov rax, 12
	syscall
	ret

gen_random:
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

    mov rax, [number]
    .l1:
    ret

fill_rnum:
    xor rbx, rbx
    imul rdi, 8
    .ci:
        push rdi
        push rbx
        call gen_random
        pop rbx
        mov [array_begin+rbx], rax
        pop rdi

        add rbx, 8
        cmp rbx, rdi
        jl .ci
    ret


count_prime:
    xor rcx, rcx
    mov rsi, [array_begin]
    mov r8,[count]
    imul r8, 8
    
    .loop:
        cmp rsi, [array_begin + r8]
        je .end

        mov rax, [rsi]
        call count_prime_check ; если в rax не простое число, то в rdx будет 0
        cmp rdx, 0
        inc rcx

        add rsi, 8
        jmp .loop
    .end:
    mov rax, rcx
    ret


count_prime_check:
; проверяет rax на простоту, в rdx 0, если не простое
    cmp rax, 2
    jnl .f1
    xor rdx, rdx
    jmp .end

    .f1:
    mov r8, 2
    mov r9, rax

    .loop:
        cmp r8, r9
        je .end

        xor rdx, rdx
        push rax
        div r8
        pop rax
        cmp rdx, 0
        je .end

        inc r8
        jmp .loop
    
    .end:
    ret

add_end:
    imul rdi, 8
    mov [array_begin+rdi], rsi
    ret

del_beg:
xor rbx, rbx
    mov rax, rdi
    imul rax,8
    add [array_begin], 8
	dec [count]
    ;leave
    ret

    xor rax, rax
    cmp [count], 0
    je @f
    cmp [array_begin], 0
    je @f
    mov rsi, [array_begin]
    mov rax, [rsi]
    add [array_begin], 8
    dec [count]
    
    @@:
    ret

; считает количество чисел в очереди, которые оканчиваются на 1
count_end_1:
    xor rcx, rcx
    mov rsi, 0
    imul rdi, 8 

    .loop:
        cmp rsi, rdi
        jge .end

        xor rdx, rdx
        mov rax, [array_begin+rsi]
        mov rbx, 10
        div rbx

        cmp rdx, 1
        jne .f
        inc rcx

        .f:
        add rsi, 8
        jmp .loop

    .end:
    mov rax, rcx
    ret