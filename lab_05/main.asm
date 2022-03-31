tmp_len     equ 256
max_row_len equ 9
divider     equ 9
matr_size   equ 81

DATA segment para public 'DATA'
	row_input_msg 	db "Input number of rows (1-9): $"
	col_input_msg 	db "Input number of columns (1-9): $"
	res_msg       	db "Result matrix: $"
	req_elems_msg 	db "Input matrix: $"
	tmp_array     	dw tmp_len dup(0)
DATA ends

MTRX segment para public 'DATA'
	matrix      	 db matr_size dup('0')
	rows        	 db 0
	columns     	 db 0
	max              db 0
MTRX ends

CODE segment para public 'CODE'
	assume ds:DATA, cs:CODE, es:MTRX

count_matrix_elems:
	mov al, rows
	mov bl, columns
	mul bl
	
	ret

inc_arr_elem:
	mov bp, bx
	lea bx, tmp_array
	
	mov dx, [bx][di]
	inc dx
	mov [bx][di], dx
	mov bx, bp
	
	ret

fill_array:
	mov cl, columns
	xor si, si
	xor di, di
	
	inc_cycle:
		mov di, [bx][si]
		add di, '0'
		and di, 00ffh
		call inc_arr_elem
		inc si
	
		loop inc_cycle
	
	ret

count_num_of_each_elem:
	mov cl, rows
	lea bx, matrix
	
	cycle:
		mov al, cl
		call fill_array
		add bl, max_row_len
		mov cl, al
		
		loop cycle

	ret

find_max_num_of_entritt:
	xor si, si
    xor di, di
	sub al, al
	mov cx, tmp_len
	lea bx, tmp_array
	
	big:
		cmp al, [bx + di]
		ja next
	
	mov al, [bx+di]
	mov si, di
	
	next:
		inc di
		
	loop big
	
	mov max, al
	
	ret
	
scanf_int:
	mov ah, 1
	int 21h
	
	mov  ah, 0
	sub  al, '0'
	
	ret

print_space:
	mov ah, 02h
	mov dl, 32
	int 21h
	
	ret

print_line:
	mov ah, 02h
	mov dl, 13
	int 21h
	mov dl, 10
	int 21h
	
	ret
	
intput_row_nums:
	mov ah, 09h
	mov dx, offset row_input_msg
	int 21h
	
	call scanf_int
	mov rows, al
	
	call print_line
	
	ret
	
input_column_nums:
	mov ah, 09h
	mov dx, offset col_input_msg
	int 21h
	
	call scanf_int	
	mov columns, al
	
	call print_line
	
	ret

scanf_row:
	mov di, cx
	mov cl, columns
	xor si, si
	
	scanf_while:
		call scanf_int
		
		mov  [bx][si], al
		call print_space
		inc  si
		
		loop scanf_while
	
	call print_line
	mov  cx, di
	
	ret

input_elems:
	mov  ah, 09h
	mov  dx, offset req_elems_msg
	int  21h
	call print_line
	
	mov cl, rows
	lea bx, matrix
	
	read_rows:
		call scanf_row
		add  bl, max_row_len
		loop read_rows
		
	call print_line
	
	ret

input_matrix:
	call intput_row_nums
	call input_column_nums
	call input_elems
	
	ret

;;;                               OUTPUT
printf_elem:
	mov ah, 02h
	add dl, '0'
	int 21h
	
	ret

printf_row:
	xor dx, dx
	xor si, si
	mov di, cx
	mov cl, columns
	
	printf_while:
		mov dl, [bx][si]

		call printf_elem
		inc  si
		call print_space
	
		loop printf_while

	call print_line
	mov  cx, di

	ret

print_matrix:
	call print_line
	
	mov  ah, 9h
	mov  dx, offset res_msg
	int  21h
	call print_line
	
	mov cl, rows
	lea bx, matrix
	
	output_row:
		call printf_row
		add  bl, max_row_len
		loop output_row

	ret
;;;;                               OUTPUT



;;;;                               TRANSFORM
transform_row:
	push cx
	xor  di, di
	mov  cl, columns

	find_elems:
		mov dl, [bx][di]
		add dl, '0'
		mov dh, 0
		
		cmp  dx, si
		jne  skip
		
		mov [bx][di], ah
		
		skip:
		inc di
	
		loop find_elems
			
	pop cx
	
	ret
	
transform_matrix:
	xor cx, cx
	lea bx, matrix
	mov cl, rows
	
	transform_cycle:
		call transform_row
		add  bl, max_row_len
		loop transform_cycle
		
	ret

get_remainder:
	mov al, al
	mov bl, divider
	div bl

	ret	
;;;;                          TRANSFORM	


main:
	mov ax, DATA
	mov ds, ax
	
	mov ax, MTRX
	mov es, ax
	
	call input_matrix

	call count_matrix_elems
	call count_num_of_each_elem
	call find_max_num_of_entritt
	call get_remainder
	call transform_matrix
	
	call print_matrix
	
	mov ax, 4c00h
	int 21h
CODE ends
end main