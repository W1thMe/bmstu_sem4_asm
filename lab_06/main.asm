extrn input_binary:        near
extrn get_oct_number:      near
extrn get_hex_number:      near


DATA segment para public 'DATA'
    menu  db  "Menu:", 10, 13,
              "(1) Input signed binary number.", 10, 13,
              "(2) Output unsigned octal number.", 10, 13,
              "(3) Output signed hexadecimal number.", 10, 13,
              "(0) Exit.", 10, 13,
              "Command:", '$'
    ptr_proc_array dw quit, input_binary, get_oct_number, get_hex_number
DATA ends

CODE segment para public 'CODE'
    assume cs:CODE, ds:DATA

print_line:
	mov ah, 02h
	mov dl, 13
	int 21h
	mov dl, 10
	int 21h
	
	ret

print_menu:
    mov ah, 9h
    mov dx, offset menu
    int 21h

    ret

get_action:
    mov ah, 01h
    int 21h

    mov ah, 0
    sub ax, '0'

    sal al, 1
    mov bx, ax

    ret

main:
    mov ax, DATA
    mov ds, ax

    menu_cycle:
        call print_menu
        call get_action
        call print_line
        call ptr_proc_array[bx]
        mov ax, DATA
        mov ds, ax
        call print_line
		
        jmp menu_cycle

quit:
    mov ah, 4ch
    int 21h

    ret

CODE ends
end main