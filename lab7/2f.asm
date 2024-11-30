
format ELF64

include 'func1.asm'

public _start

THREAD_FLAGS=2147585792
ARRLEN=665      ;len array

section '.bss' writable
    array rb ARRLEN
    digits rq 10
    buffer rb 10
    f db "/dev/random", 0   ;подключаем рандом
    stack1 rq 4096
    msg1 db "Количество чисел, сумма цифр  которых кратна 3:", 0xA, 0
    msg2 db "Среднее арифметическое значение:", 0xA, 0
    msg3 db "Медиана:", 0xA, 0
    msg4 db "Наиболее редко встречающаяся цифра в случайных числах:", 0xA, 0
    
section '.text' executable
_start:
    mov rax, 2
    mov rdi, f
    mov rsi, 0
    syscall
    mov r8, rax
    
    mov rax, 0
    mov rdi, r8
    mov rsi, array
    mov rdx, ARRLEN
    syscall

    .filter_loop:
        call sort
        cmp rax, 0
        jne .filter_loop
    
    mov rax, 56                 ; first child [%3 = 0]
    mov rdi, THREAD_FLAGS
    mov rsi, 4096
    add rsi, stack1
    syscall

    cmp rax, 0
    je .div3
    
    mov rax, 61
    mov rdi, -1
    mov rdx, 0
    mov r10, 0
    syscall

    call input_keyboard

    mov rax, 56                 ; second child [mid_v]
    mov rdi, THREAD_FLAGS
    mov rsi, 4096
    add rsi, stack1
    syscall

    cmp rax, 0
    je .mid_v
    
    mov rax, 61
    mov rdi, -1
    mov rdx, 0
    mov r10, 0
    syscall

    call input_keyboard

    mov rax, 56                 ; third child [median]
    mov rdi, THREAD_FLAGS
    mov rsi, 4096
    add rsi, stack1
    syscall

    cmp rax, 0
    je .median
    
    mov rax, 61
    mov rdi, -1
    mov rdx, 0
    mov r10, 0
    syscall

    call input_keyboard

    mov rax, 56                 ; fourth child [rarest digit]
    mov rdi, THREAD_FLAGS
    mov rsi, 4096
    add rsi, stack1
    syscall

    cmp rax, 0
    je .rare_digit
    
    mov rax, 61
    mov rdi, -1
    mov rdx, 0
    mov r10, 0
    syscall

    call exit
    call exit

    ;    <------- Реализация функций ------->

    .div3:
        mov rsi, msg1
        call print_str

        xor r8, r8 ; счетчик
        xor rax, rax
        xor r9, r9 ; итератор

        .ar_iter: 
            xor rbx, rbx
            xor rax, rax
            xor rdx, rdx
            mov al, [array + r9]
            mov rbx, 3
            div rbx

            inc r9

            cmp rdx, 0      ;остаток 0 -> число кратно 3 -> сумма кратна 3 
            jne .ar_iter

            inc r8
            cmp r9, ARRLEN 
            jl .ar_iter

        xor rax, rax
        mov rax, r8    
        mov rsi, buffer
        call number_str
        call print_str
        call new_line
        call exit
        call exit

    .mid_v:
        mov rsi, msg2
        call print_str

        xor r8, r8 ; счетчик
        xor rax, rax
        xor r9, r9 ; итератор

        .arr_iter: 
            mov al, [array+r9]
            add r8, rax
            
            inc r9
            cmp r9, ARRLEN
            jl .arr_iter

        xor rax, rax
        mov rax, r8
        mov rbx, ARRLEN
        div rbx
        
        mov rsi, buffer
        call number_str
        call print_str
        call new_line
        call exit
        call exit


    .median:
        mov rsi, msg3
        call print_str

        xor rbx, rbx
        xor rax, rax
        xor rdx, rdx
        mov rax, ARRLEN
        mov rbx, 2
        div rbx
        mov bl, [array+rax]
        mov rax, rbx
        mov rsi, buffer
        call number_str
        call print_str
        call new_line
        call exit
        call exit


    .rare_digit:
        mov rsi, msg4
        call print_str

        mov rsi, array ; iter
        add rsi, ARRLEN ; arr end
        dec rsi
        xor rbx, rbx
        mov rbx, 10
        .loop666:
            cmp rsi, array
            jl .next666

            xor rax, rax
            mov al, byte[rsi]
            .decomp_loop:
                xor rdx, rdx
                div rbx
                push rax
                mov rax, 8
                mul rdx
                mov rdx, rax
                pop rax
                mov r10, [digits+rdx]
                inc r10
                mov [digits+rdx], r10
                cmp rax, 0
                je @f
                jmp .decomp_loop
            
            @@:
            dec rsi
            jmp .loop666

        .next666:
        mov rax, 9999999 ; min count
        xor rbx, rbx ; digit
        xor rcx, rcx
        .comp_loop:
            cmp rcx, 10
            je .next777

            push rax
            mov rax, 8
            mul rcx
            mov rdx, rax
            pop rax

            cmp rax, [digits+rdx]
            jl @f
            mov rax, [digits+rdx]
            mov rbx, rcx

            @@:
            inc rcx
            jmp .comp_loop
        
        .next777: 
        mov rax, rbx
        mov rsi, buffer
        call number_str
        call print_str
        call new_line
        call exit
        call exit


;output rax = 0 if sorted
sort:
    xor rax, rax ; swap counter
    mov rsi, array ; iter
    mov rcx, ARRLEN
    dec rcx
    .check:
        mov dl, [rsi]
        mov dh, [rsi+1]
        cmp dl, dh
        jbe .ok

        mov [rsi], dh
        mov [rsi+1], dl
        inc rax

        .ok:
        inc rsi
    loop .check
    ret
