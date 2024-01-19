extern printf: proc
extern scanf: proc
extern fopen: proc
extern fread: proc
extern fwrite: proc
extern fclose: proc
show_int macro nr, f
	push nr
	push offset f
	call printf
	add esp, 8
endm

show_string macro f
	push offset f
	call printf
	add esp, 4
endm

read_int macro nr, f
	push offset nr
	push offset f
	call scanf
	add esp, 8
endm