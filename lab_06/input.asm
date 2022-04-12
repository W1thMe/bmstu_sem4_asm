public input_binary
public bin_number

bin_len equ 16

DATA segment para public 'DATA'
    input_msg      db "Input signed binary number: ", 10, 13, '$'
    bin_number     db  bin_len, ?, bin_len + 1 dup(0)
                    db '$'
     
DATA ends

CODE segment para public 'CODE' 
    assume cs:CODE, ds:DATA

input_binary:
    ; Вывод приглашения к вводу
    mov ah, 09h
    mov dx, offset input_msg
    int 21h
	
    xor cx,cx
    xor di,di

    mov di, 0
    mov cl, 17
    mov ah, 01h

    input:
        mov bin_number[di + 2], al
        cmp cx, 1
        je skip

        int 21h
        inc di
        skip:

        loop input
    ret

CODE ends
end

