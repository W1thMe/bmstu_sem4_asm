.model flat, c
.stack
.code

public my_memmove

my_memmove proc
	push ebp ;����������� ���������� �������, �� ������ ���� ������ �� ������ ��������.
	push ebx ;����������� ���������� �������, �� ������ ���� ������ �� ������ ��������.

	mov ebp, esp ;��������� �� ����
	
	mov edi, [ebp + 12] ; buffer //����� �������� + ebp + ebx(��� �� 4 ����� ���)
	mov esi, [ebp + 16] ; source
	mov ecx, [ebp + 20] ; len

	cmp edi, esi ; ���� ������ � ����� ��������� => �����
	je exit

	; ���� buf ������, ����������, ���������� �� �� src
	; � ���� ����������, �� �������� ������ � �����
	
	mov eax, edi
	sub eax, esi

	cmp eax, ecx
	jg copy
	cmp eax, 0
	jl copy

	; �����
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