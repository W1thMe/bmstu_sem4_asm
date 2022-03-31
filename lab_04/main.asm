;***********************************************
; Требуется написать программу, в которой ввести
; строку и затем вывести первые 10 её символов

max_len equ 255

DATA SEGMENT PARA 'DATA'
	msg db "Input string: ", 0Dh, 0Ah, '$'
	string db max_len, ?, max_len + 1 dup('$')
DATA ENDS

CODE SEGMENT PARA PUBLIC 'CODE'
	assume CS:CODE, DS:DATA
	
main:
	mov ax, DATA
	mov ds, ax
	mov cx, 10
	mov bx, 0

	;Приглашение к вводу
	mov ah, 09h
	mov dx, offset msg
	int 21h
	
	
	mov ah, 0Ah
	mov dx, offset string
	int 21h
	
	;Ввод строки
	mov ah, 02h
	
	;Переход строки
	mov dl, 0ah
	int 21h
	mov dl, 0dh
	int 21h
	
	;Вывод первых 10 символов строки
output:
	mov dl, [string + 2 + bx]
	int 21h
	inc bx;
	loop output
	
	mov ah, 4Ch
	int 21h
CODE ENDS

END main