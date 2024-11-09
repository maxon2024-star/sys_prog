format ELF64

public _start

extrn initscr
extrn start_color
extrn init_pair
extrn getmaxx
extrn getmaxy
extrn raw
extrn noecho
extrn keypad
extrn stdscr
extrn move
extrn getch
extrn addch
extrn refresh
extrn endwin
extrn exit
extrn timeout
extrn usleep
extrn printw

section '.bss' writable
    xmax dq 1
    ymax dq 1
    xmid dq 1
    ymid dq 1
    xmid_st dq ?
    ymid_st dq ?
    palette dq 1
    delay dq 50000
    l_shag dq 1 ;длина шага
    c_sh dq ?
    dif dq 2; расстояние между витками

section '.text' executable

_start:
    call initscr
    mov rdi, [stdscr]
    ;максимальные значения координат окна
    call getmaxx
    dec rax
    mov [xmax], rax
    ;середина монитора
    xor rdx, rdx
    xor rcx, rcx
    mov rcx,2     
    div rcx
    mov [xmid],rax
    mov [xmid_st], rax

  call getmaxy
    dec rax
    mov [ymax], rax
    ;середина монитора
    xor rdx, rdx
    xor rcx, rcx
    mov rcx,2     
    div rcx
    mov [ymid],rax

    call start_color
    ; COLOR_GREEN
    mov rdi, 1
    mov rsi, 2
    mov rdx, 2
    call init_pair

    ; COLOR_WHITE
    mov rdi, 2
    mov rsi, 0xf
    mov rdx, 0xf
    call init_pair

    call refresh
    call noecho
    call raw

    mov rax, ' '
    or rax, 0x200
    mov [palette], rax

 .begin:
    call initscr
    mov rdi, [stdscr]
    ;максимальные значения координат окна
    call getmaxx
    dec rax
    mov [xmax], rax
    ;середина монитора
    xor rdx, rdx
    xor rcx, rcx
    mov rcx,2     
    div rcx
    mov [xmid],rax
    mov [xmid_st], rax

  call getmaxy
    dec rax
    mov [ymax], rax
    ;середина монитора
    xor rdx, rdx
    xor rcx, rcx
    mov rcx,2     
    div rcx
    mov [ymid],rax

    ; Движение по квадратной спирали
    ; Переключение цвета
    mov rax, [palette]
    and rax, 0x100
    cmp rax, 0
    jne .white

    mov rax, [palette]
    and rax, 0xff
    or rax, 0x100
    jmp @f

    .white:
    mov rax, [palette]
    and rax, 0xff
    or rax, 0x200

    @@:
    mov [palette], rax

    mov [l_shag], 0      ; Длина текущего шага

    ; Установка позиции
    mov rdi, [ymid]    ; y-позиция
    mov rsi, [xmid]    ; x-позиция
    call move

    ; Отрисовка символа
    mov rdi, [palette]
    call addch
    call refresh

    ; Пауза
    mov rdi, [delay]
    call usleep

.loop_spiral:
    mov r8, [dif]
    add [l_shag], r8

.out_check:
    ; Проверка нажатия клавиши для выхода или изменения скорости
    mov rdi, 1
    call timeout
    call getch

    cmp al, 'z'
    je .exit_program

    cmp al, 'h'
    jne .move_right

    ; Изменение скорости
    cmp [delay], 2000
    je .fast
    mov [delay], 2000
    jmp .move_right

.fast:
    mov [delay], 100

.move_right:
    mov [c_sh], 0
    .a:
        ; Установка позиции
        inc [xmid]
        mov rdi, [ymid]    ; y-позиция
        mov rsi, [xmid]    ; x-позиция
        call move

        ; Отрисовка символа
        mov rdi, [palette]
        call addch
        call refresh

        ; Пауза
        mov rdi, [delay]
        call usleep


        inc [c_sh]
        mov r8, [l_shag]
        cmp [c_sh], r8
        jl .a


.move_down:
    xor r8,r8
    mov [c_sh], 0
    .b:
        ; Установка позиции
        inc [ymid]
        mov rdi, [ymid]    ; y-позиция
        mov rsi, [xmid]    ; x-позиция
        call move

        ; Отрисовка символа
        mov rdi, [palette]
        call addch
        call refresh

        ; Пауза
        mov rdi, [delay]
        call usleep
        inc [c_sh]
        mov r8, [l_shag]
        cmp [c_sh], r8
        jl .b
mov r8, [dif]
add [l_shag], r8

.move_left:    
    xor r8,r8
    mov [c_sh], 0
        .c:
        ; Установка позиции
        dec [xmid]
        mov rdi, [ymid]    ; y-позиция
        mov rsi, [xmid]    ; x-позиция
        call move
        
        ; Отрисовка символа
        mov rdi, [palette]
        call addch
        call refresh

        ; Пауза
        mov rdi, [delay]
        call usleep
        inc [c_sh]
        mov r8, [l_shag]
        cmp [c_sh], r8
        jl .c

.move_up:
    xor r8,r8
    mov [c_sh], 0
    .d:
        ; Установка позиции
        dec [ymid]
        mov rdi, [ymid]    ; y-позиция
        mov rsi, [xmid]    ; x-позиция
        call move

        ; Отрисовка символа
        mov rdi, [palette]
        call addch
        call refresh


        ; Пауза
        mov rdi, [delay]
        call usleep

        inc [c_sh]
        mov r8, [l_shag]
        cmp [c_sh], r8
        jl .d

.prov:
    ; Проверка выхода за границы экрана и перезапуск спирали
 
    cmp [xmid], 0
    jle .begin

    mov rcx, [xmax]
    cmp [xmid], rcx
    jge .begin

    cmp [ymid], 0
    jle .begin

    mov rcx, [ymax]
    cmp [ymid], rcx
    jge .begin

    jmp .loop_spiral

.exit_program:
    call endwin
    call exit