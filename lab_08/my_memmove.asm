.model flat, c
.stack
.code

public my_memmove

my_memmove proc
	push ebp ;����������� ���������� �������, �� ������ ���� ������ �� ������ ��������.
	push ebx ;����������� ���������� �������, �� ������ ���� ������ �� ������ ��������.

	mov ebp, esp ;��������� �� ����
	
	mov edi, [ebp + 12] ; buffer +12 �. �. call ���������� � ���� ����� ��������, � � ebp � ebx(�� 4 ����� ���)
	mov esi, [ebp + 16] ; source
	mov ecx, [ebp + 20] ; len
	mov ebx, edi

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
	sub edi, 1
	add esi, ecx
	sub esi, 1

	std
	rep movsb
	cld
	jmp exit

copy:
	push esi
	mov esi, ecx
	pop esi

	rep movsb

exit:
	pop ebx
	pop ebp

	ret

my_memmove endp

end