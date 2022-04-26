.model flat, c
.stack
.code

public my_memmove

my_memmove proc
	push ebp ;Принадлежит вызывающей функции, не должен быть изменён на момент возврата.
	push ebx ;Принадлежит вызывающей функции, не должен быть изменён на момент возврата.

	mov ebp, esp ;Указатель на стек
	
	mov edi, [ebp + 12] ; buffer //адрес возврата + ebp + ebx(все по 4 байта они)
	mov esi, [ebp + 16] ; source
	mov ecx, [ebp + 20] ; len

	cmp edi, esi ; Если начало и конец совпадает => выход
	je exit

	; Если buf больше, определяем, пересекает ли он src
	; и если пересекает, то копируем строку с конца
	
	mov eax, edi
	sub eax, esi

	cmp eax, ecx
	jg copy
	cmp eax, 0
	jl copy

	; Иначе
	add edi, ecx
	dec edi
	add esi, ecx
	dec esi

	std
	rep movsb
	cld
	jmp exit

copy:
	rep movsb

exit:
	pop ebx
	pop ebp

	ret

my_memmove endp

end