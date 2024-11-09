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
    palette dq 1
    delay dq 500000
    l_shag dq 1 ;длина шага
    n_shag dq 1 ;количество
    m_direct dq 0 ;направление

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

    ; Начало спирали из центра
    mov r8, [xmid]  ; Начальная x-позиция
    mov r9, [ymid]  ; Начальная y-позиция

    mov [l_shag], 1      ; Длина текущего шага
    mov [m_direct], 0      ; Направление (0: вправо, 1: вниз, 2: влево, 3: вверх)
    mov [n_shag], 0      ; Счётчик шагов до изменения длины

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
    inc [l_shag]
   ; mov [n_shag], 0      ; Счётчик шагов до изменения длины
.direction_loop:
    ; Проверка нажатия клавиши для выхода или изменения скорости
    mov rdi, 1
    call timeout
    call getch

    cmp al, 'z'
    je .exit_program

    cmp al, 'h'
    jne .no_speed_change

    ; Изменение скорости
    cmp [delay], 2000
    je .fast
    mov [delay], 2000
    jmp .no_speed_change

.fast:
    mov [delay], 100

.no_speed_change:
    ; Обновление позиции в зависимости от направления
    xor rdx, rdx
    mov rdx, [m_direct]
    cmp rdx, 0
    je .move_right
    cmp rdx, 1
    je .move_down
    cmp rdx, 2
    je .move_left
    cmp rdx, 3
    je .move_up

.move_right:
    inc [xmid]
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
    inc [m_direct]
    inc [n_shag]
    jmp .direction_continue

.move_down:
    inc [ymid]

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
    inc [m_direct]
    inc [n_shag]
    jmp .direction_continue

.move_left:
    dec [xmid]
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

    inc [m_direct]
    inc [n_shag]
    jmp .direction_continue

.move_up:
    dec [ymid]
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
    inc [m_direct]
    inc [n_shag]
    jmp .direction_continue

.direction_continue:
    ; Смена направления и увеличение длины шага каждые два поворота    
    cmp [n_shag], 3
    jne .loop_spiral
    inc [l_shag]
    mov [n_shag], 0

    cmp [m_direct], 4
    jl .loop_spiral
    mov [m_direct], 0

    ; Проверка выхода за границы экрана и перезапуск спирали
    mov rcx, [xmax]
    cmp [xmid], 0
    jl .begin

    cmp [xmid], rcx
    jge .begin

    cmp [ymid], 0
    jl .begin

    mov rcx, [ymax]
    cmp [ymid], rcx
    jge .begin

    jmp .loop_spiral

.exit_program:
    call endwin
    call exit