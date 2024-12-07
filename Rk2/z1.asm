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
extrn sin ; Синус из libm

section '.bss' writable
    xmax dq 0
    ymax dq 0
    xmid dq 0
    ymid dq 0
    delay dq 50000
    palette dq 1
    flag dq 0
    amplitude dq 8       ; Амплитуда (A)
    omega dq 2            ; Частота (ω)
    x dq 0                ; Текущая x-координата
    y dq 0                ; Текущая y-координата
    fx dq 0.0             ; x в виде float для передачи в sin
    pi dq 3.14159265359   ; Константа pi для преобразования в радианы

section '.text' executable

_start:
    call initscr
    mov rdi, [stdscr]
    
    ; Получение размеров экрана
    call getmaxx
    dec rax
    mov [xmax], rax
    call getmaxy
    dec rax
    mov [ymax], rax
    
    ; Установка начальных значений
    mov rax, [xmax]
    shr rax, 1
    mov [xmid], rax
    
    mov rax, [ymax]
    shr rax, 1
    mov [ymid], rax
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

    ; Настройка ncurses
    call noecho
    call raw
    call refresh

    mov rax, ' '
    or rax, 0x200
    mov [palette], rax

    ; Основной цикл
    ;fasm z1.asm && ld z1.o -lc -lm -lncurses -dynamic-linker /lib64/ld-linux-x86-64.so.2 -o z1.out
.loop:
; Переключение цвета
    mov rax, [palette]
    and rax, 0x100
    cmp [flag], 0
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

    mov r8, [flag]
    cmp r8,1
    jl .out_check

    mov [flag], 0
    
.out_check:
    ; Проверка нажатия клавиши для выхода или изменения скорости
    mov rdi, 1
    call timeout
    call getch

    cmp al, 'z'
    je .exit_program

    cmp al, 'h'
    jne .sin_loop

    ; Изменение скорости
    cmp [delay], 2000
    je .fast
    mov [delay], 2000
    jmp .sin_loop

.fast:
    mov [delay], 100

.sin_loop:
    ; Преобразование x в радианы
    mov rax, [x]
    cvtsi2sd xmm0, rax
    mov rax, [xmax]
    cvtsi2sd xmm1, rax
    movq xmm2, [pi]
    mulsd xmm2, xmm0
    divsd xmm2, xmm1
    addsd xmm2, xmm2
    movq [fx], xmm2

    ; Вычисление y = A * sin(ω * x)
    movsd xmm0, qword [fx]
    call sin
    movsd qword [fx], xmm0

    movsd xmm0, qword [fx]
    mov rax, [omega]
    cvtsi2sd xmm1, rax
    mulsd xmm0, xmm1
    mov rax, [amplitude]
    cvtsi2sd xmm1, rax
    mulsd xmm0, xmm1
    cvttsd2si rax, xmm0

    ; Инверсия y относительно центральной линии экрана
    mov rbx, [ymid]     ; ymid (центр экрана по вертикали)
    sub rbx, rax        ; Инверсия: y = ymid - (A * sin(...))
    mov [y], rbx

    ; Проверка и обработка y, выходящего за границы
    mov rax, [y]
    cmp rax, 0
    jl .skip_draw
    cmp rax, [ymax]
    jge .skip_draw

    ; Отрисовка символа
    mov rdi, [y]
    mov rsi, [x]
    call move
    mov rdi, [palette]
    call addch

.skip_draw:
    call refresh

    ; Увеличение x
    inc qword [x]
    mov rax, [x]
    cmp rax, [xmax]
    jl .pause

    ; Если достигли xmax, сбросить x и начать заново
    inc  [flag]
    xor rax, rax
    mov [x], rax

.pause:
    mov rdi, [delay]
    call usleep
    jmp .loop



.exit_program:
    call endwin
    call exit
