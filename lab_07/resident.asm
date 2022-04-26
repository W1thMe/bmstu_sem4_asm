.model tiny
.186

CodeSeg segment
    assume cs:CodeSeg
    org 100h

main:
    jmp init

    old_handler dd 0    
    init_flag   db 1    
    time        db 0 
    speed       db 1Fh  


mainloop proc near
    pusha
    push es
    push ds

    mov ah, 02h 
    int 1Ah             ; Считывание значения времени

    cmp dh, time
    je skip             ; Секунда не прошла

    mov time, dh        ; Секунда прошла
    dec speed           ; + Скорость

    cmp speed, 1Fh      
    jbe change_speed    ; Установка скорости если speed  меньше или равен 1Fh
    
    mov speed, 1Fh

change_speed:
    mov al, 0F3h
    out 60h, al  
    mov al, speed
    out 60h, al  

skip:
    popa
    pop es
    pop ds

    jmp dword ptr cs:old_handler  ; вызываем старый обработчик прерывния таймера

mainloop endp

init:
    mov ax, 351Ch
    int 21h   ; Определение адреса обработчика прерывания таймера (1Ch)
              ; в es - сегментная часть адреса, в bx - смещение

    cmp es:init_flag, 1
    je exit

    ; Сохранение адреса старого обработчика прерываний по частям в одну переменную
    mov word ptr old_handler, bx                           
    mov word ptr old_handler[2], es

    mov ax, 251Ch 			; Установка собственного обработчика по адресу из dx
    mov dx, offset mainloop
    int 21h

    mov dx, offset init
    int 27h

exit:
    ; Исходные настройки
    mov al, 0F3h
    out 60h, al
    mov al, 0
    out 60h, al
    
    ; Установка старого обработчика
    mov dx, word ptr es:old_handler                      
    mov ds, word ptr es:old_handler[2]
	mov ax, 251Ch
    int 21h

    mov ax, 4c00h
    int 21h
    
CodeSeg ends
end main