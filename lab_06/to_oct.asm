public get_oct_number
bin_len equ 16

extrn bin_number:   byte

DATA segment para public 'DATA'
    res_oct_msg    db "Converted number: ", 10, 13, '$'
    oct_num        db  5 dup(0), '$'
    ;oct_len        db  0
    direct_code    db bin_len dup(0), '$'
DATA ends


CODE segment para public 'CODE'
    assume cs:CODE, ds:DATA

copy_to_direct_code:
    xor cx, cx
    xor di, di

    mov cl, bin_len
    mov di, cx
    mov si, cx
    dec si

    copy_bin_num:
        mov al, bin_number[di + 2]
        mov direct_code[si], al
        dec di
        dec si

        loop  copy_bin_num

    ret

invert_bits:
    xor cx, cx
    xor di, di

    mov cl, bin_len
    mov di, cx
    dec di

    invert:
        cmp direct_code[di], '1'
        je bit_to_zero
        mov direct_code[di], '1'

        jmp _next

        bit_to_zero:
            mov direct_code[di], '0'
            

        _next:

        dec di
        loop invert


    ret

get_direct_code:
    xor cx, cx
    mov cl, bin_len
    mov di, cx
    dec di

    cmp direct_code[di], '1'
    je _skip
   
    minus:
        mov direct_code[di], '1'
        dec di

        cmp direct_code[di], '1'
        je next

        cmp di, 0
        je next

        jmp minus

    next:
    mov direct_code[di], '0'
    call invert_bits
    ret

    _skip:
        mov direct_code[di], '0' 

    call invert_bits
    ret

print_oct:
    mov ah, 09h
    mov dx, offset res_oct_msg
    int 21h

    mov dx, offset oct_num
    int 21h

    ret


get_oct_number:
    xor dx, dx
    xor bx, bx
    xor cx, cx
    xor ax, ax

    call copy_to_direct_code
    cmp bin_number[3], '0'
    je skip

    call get_direct_code

    skip:
    mov si, 4
    mov cl, bin_len
    mov di, cx
    mov cx, 5
    dec di

    _while:
        mov bl, 1
        xor dx, dx

        oct:
            xor ax, ax
            mov al, direct_code[di]  ; считали двоичную цифру
            sub al, '0'                
            mul bl                       ; умножили считанное число
            add dx, ax                   ; Копим сумму триады

			sal bx, 1

            dec di
            cmp bx, 7       ; проверка, что триада закончилась
            jle oct

        mov oct_num[si], dl  ; сохранили число
        add oct_num[si], '0' 
        ;inc oct_len
        dec si

        loop _while

    call print_oct
    
    ret

CODE ends
end