format ELF64

public _start

include 'func.asm' 

section '.text' executable
  _start:
    mov rsi, [rsp+16]
    mov al, byte [rsi]
    mov bl, 10
    xor rcx, rcx

    ;в строку
    .iter:
        xor ah, ah
        div bl
        add ah, '0'
        mov dl, ah
        push rdx
        inc cl ;количество символов
        cmp al, 0
        jne .iter

    ;вывод
    .iter2:
        pop rdx
        mov [rsi], dl
        call print_str
        dec cl
        cmp cl, 0
        jne .iter2
    call exit