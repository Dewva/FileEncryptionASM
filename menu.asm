.code
printMenu proc
	push ebp
	mov ebp, esp
	show_string menu1
	show_string menu2
	show_string menu3
	show_string menu4
	mov esp, ebp
	pop ebp
	ret
printMenu endp

printHelp proc
	push ebp
	mov ebp, esp
	show_string help1
	show_string help2
	show_string help3
	show_string help4
	show_string help5
	show_string help6
	show_string help7
	show_string help8
	show_string help9
	show_string help10
	show_string help11
	mov esp, ebp
	pop ebp
	ret
printHelp endp