format elf64
    ;include 'func.asm'

	public create_array
	public free_memory

    public gen_random
    public fill_rnum

    public count_prime
    public count_prime_check

    public count_end_1

    public sum
    public reverse

    f  db "/dev/urandom",0

    section '.data' writable

	section '.bss' writable
        number rq 1
        array_begin rq 1
        array_begin_adress rq 1
        count rq 1




; Функция создания массива
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


; Функция освобождения памяти
free_memory:
    xor rdi, rdi               ; Начинаем с нулевого адреса
    mov rax, 12                ; Системный вызов brk
    syscall                    ; Устанавливаем кучу на исходную позицию
    ret                        ; Завершение функции

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
    mov rsi, 0
    imul rdi, 8
    
    .loop:
        cmp rsi, rdi
        je .end
        mov rax, [array_begin+rsi]
        push rsi
        call count_prime_check ; если в rax не простое число, то в rdx будет 0
        pop rsi
        cmp rdx, 0
        je .f
        inc rcx

        .f: 
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

sum:
     xor rcx, rcx
    mov rsi, 0
    imul rdi, 8 

    .loop:
        cmp rsi, rdi
        jge .end

        mov rax, [array_begin+rsi]
        add rcx, rax

        add rsi, 8
        jmp .loop
        
    .end:
    mov rax, rcx
    ret

reverse:
    xor rcx, rcx
    mov rsi, 0
    mov rax, rdi
    mov rbx, 2
    div rbx
    mov r9, rax
    dec rdi

    imul rdi, 8
    imul r9, 8 

    .loop:
        cmp rsi, r9
        jge .end
        ;cmp rsi, 
        sub rdi, rsi

        xor r11, r11
        xor rax, rax
        mov rax, [array_begin+rsi]
        mov r11, [array_begin+rdi]

        mov [array_begin+rsi], r11
        mov [array_begin+rdi], rax
        
        add rsi, 8
        jmp .loop

    .end:
      ret