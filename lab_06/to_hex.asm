public get_hex_number
bin_len equ 16

extrn bin_number:   byte

DATA segment para public 'DATA'
    res_hex_msg    db "Converted number: ", 10, 13, '$'
    hex_num        db  4 dup(0), '$'
    ;hex_len        db  0
DATA ends


CODE segment para public 'CODE'
    assume cs:CODE, ds:DATA

print_hex:
    mov ah, 09h
    mov dx, offset res_hex_msg
    int 21h

    mov dx, offset hex_num
    int 21h

    ret

get_hex_number:
    xor dx, dx
    xor bx, bx
    xor cx, cx
    xor ax, ax
    
    mov si, 3
    mov cl, bin_len
    mov di, cx
    ;dec di
    mov cl, 4
    mov dl, 0

    _while:
        mov bl, 1
        xor dx, dx

        oct:
            xor ax, ax
            mov al, bin_number[di + 2]  ; считали двоичную цифру
            sub al, '0'             
            mul bl                 
            add dx, ax              ; Копим сумму тетрады

			sal bx, 1       

            dec di

            cmp bx, 0fh       ; проверка, что тетрада закончилась
            jle oct

        mov hex_num[si], dl
        add hex_num[si], '0' 

        cmp dl, 0Ah 
        jl skip                 ; Если значение < 10, то пропуск
        add hex_num[si], 7

        skip:
        ;inc hex_len          ; увеличили длину числа
        dec si

        loop _while

        call print_hex
    ret

CODE ends
end