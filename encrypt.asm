.data
fileR DD 0
fileD DD 0
buffer DD 0
buffer_small DB 0
affineM DD 26
affineAInv DD 0
A EQU 65
permutationArray DD 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
auxArray DB 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
permutationEnd DD 0
.code
xor_encr proc
	push ebp
	mov ebp, esp
	;fopen fisier de criptat
	push offset formatReadBin
	push offset fileToR
	call fopen
	add esp, 8
	test eax, eax
		jz FENDR
	mov fileR, eax
		
	;fopen fisier destinatar
	push offset formatWriteBin
	push offset fileToW
	call fopen
	add esp, 8
	test eax, eax
		jz FENDD
	mov fileD, eax
		
	;citesc cate un byte si il printez
	readLoopXE:
		push fileR
		push 1
		push 1
		push offset buffer_small
		call fread
		add esp, 16
		test eax, eax
			jz FEND
		
		mov eax, key
		xor buffer_small, al
		push fileD
		push 1
		push 1
		push offset buffer_small
		call fwrite
		add esp, 16
	jmp readLoopXE
	
	FEND:
	push fileD
	call fclose
	add esp, 8
	FENDD:
	push fileR
	call fclose
	add esp, 8
	
	FENDR:
	mov esp, ebp
	pop ebp
	ret 4
	
xor_encr endp

caesar_encr proc
	push ebp
	mov ebp, esp
	;fopen fisier de criptat
	push offset formatReadBin
	push offset fileToR
	call fopen
	add esp, 8
	test eax, eax
		jz FENDR
	mov fileR, eax
	
	;fopen fisier destinatar
	push offset formatWriteBin
	push offset fileToW
	call fopen
	add esp, 8
	test eax, eax
		jz FENDD
	mov fileD, eax
	
	;citesc cate un byte si il printez
	readLoopCE:
		push fileR
		push 1
		push 1
		push offset buffer_small
		call fread
		add esp, 16
		test eax, eax
			jz FEND
		
		mov eax, key
		add buffer_small, al
		push fileD
		push 1
		push 1
		push offset buffer_small
		call fwrite
		add esp, 16
	jmp readLoopCE
	
	FEND:
	push fileD
	call fclose
	add esp, 8
	FENDD:
	push fileR
	call fclose
	add esp, 8
	
	FENDR:
	mov esp, ebp
	pop ebp
	ret
caesar_encr endp

caesar_decr proc
	push ebp
	mov ebp, esp
	;fopen fisier de criptat
	push offset formatReadBin
	push offset fileToR
	call fopen
	add esp, 8
	test eax, eax
		jz FENDR
	mov fileR, eax
		
	;fopen fisier destinatar
	push offset formatWriteBin
	push offset fileToW
	call fopen
	add esp, 8
	test eax, eax
		jz FENDD
	mov fileD, eax
		
	;citesc cate un byte si il printez
	readLoopCD:
		push fileR
		push 1
		push 1
		push offset buffer_small
		call fread
		add esp, 16
		test eax, eax
			jz FEND
		
		mov eax, key
		sub buffer_small, al
		push fileD
		push 1
		push 1
		push offset buffer_small
		call fwrite
		add esp, 16
	jmp readLoopCD
	
	FEND:
	push fileD
	call fclose
	add esp, 8
	FENDD:
	push fileR
	call fclose
	add esp, 8
	
	FENDR:
	mov esp, ebp
	pop ebp
	ret
caesar_decr endp

affine_encr proc
	push ebp
	mov ebp, esp
	;fopen fisier de criptat
	push offset formatReadBin
	push offset fileToR
	call fopen
	add esp, 8
	test eax, eax
		jz FENDR
	mov fileR, eax
		
	;fopen fisier destinatar
	push offset formatWriteBin
	push offset fileToW
	call fopen
	add esp, 8
	test eax, eax
		jz FENDD
	mov fileD, eax
		
	;citesc cate un byte si il printez
	readLoopAE:
		push fileR
		push 1
		push 1
		push offset buffer_small
		call fread
		add esp, 16
		test eax, eax
			jz FEND
		cmp buffer_small, 32
			je skipE
	;---ALGORITM CRIPTARE---;
		xor eax, eax
		mov al, buffer_small
		sub eax, A
		mul affineA
		add eax, affineB
		xor edx, edx
		div affineM
		mov buffer_small, dl
		add buffer_small, A
		
	skipE:
		push fileD
		push 1
		push 1
		push offset buffer_small
		call fwrite
		add esp, 16
	jmp readLoopAE
	
	FEND:
	push fileD
	call fclose
	add esp, 8
	FENDD:
	push fileR
	call fclose
	add esp, 8
	
	FENDR:
	mov esp, ebp
	pop ebp
	ret
affine_encr endp

affine_decr proc
	push ebp
	mov ebp, esp
	;fopen fisier de criptat
	push offset formatReadBin
	push offset fileToR
	call fopen
	add esp, 8
	test eax, eax
		jz FENDR
	mov fileR, eax
		
	;fopen fisier destinatar
	push offset formatWriteBin
	push offset fileToW
	call fopen
	add esp, 8
	test eax, eax
		jz FENDD
	mov fileD, eax
	;---FIND INV KEY TO DECRYPT---;
	mov ecx, affineM
	findInvLoop:
			xor edx, edx
			mov eax, affineA
			mul ecx
			div affineM
			cmp edx, 1
				je foundInv
	loop findInvLoop
		foundInv:
			mov affineAInv, ecx	
	;citesc cate un byte si il printez
	readLoopAD:
		push fileR
		push 1
		push 1
		push offset buffer_small
		call fread
		add esp, 16
		test eax, eax
			jz FEND
		cmp buffer_small, 32
			je skipD
	;---ALGORTIM DECRIPTARE---;	
		xor eax, eax
		mov al, buffer_small
		add eax, A
		sub eax, affineB
		mul affineAInv
		xor edx, edx
		div affineM
		mov buffer_small, dl
		add buffer_small, A
	skipD:
		push fileD
		push 1
		push 1
		push offset buffer_small
		call fwrite
		add esp, 16
	jmp readLoopAD
	
	FEND:
	push fileD
	call fclose
	add esp, 8
	FENDD:
	push fileR
	call fclose
	add esp, 8
	
	FENDR:
	mov esp, ebp
	pop ebp
	ret
affine_decr endp

permutation_encr proc
	push ebp
	mov ebp, esp
	mov permutationEnd, 0
	;fopen fisier de criptat
	push offset formatReadBin
	push offset fileToR
	call fopen
	add esp, 8
	test eax, eax
		jz FENDR
	mov fileR, eax
		
	;fopen fisier destinatar
	push offset formatWriteBin
	push offset fileToW
	call fopen
	add esp, 8
	test eax, eax
		jz FENDD
	mov fileD, eax
	;---ENCRYPTION ALGORITHM---;
	readLoopPE:
		lea edi, auxArray

		mov cnt, 0
		readNbytes:
			push fileR
			push 1
			push 1
			push offset buffer_small
			call fread
			add esp, 16
			test eax, eax
				jz checkPadding
			jmp continuePermutation
			checkPadding:
				mov ecx, cnt
				cmp ecx, 0
					je FEND
				mov buffer_small, ''

			continuePermutation:
			mov al, buffer_small
			mov ecx, cnt
			mov [edi + 4 * ecx], al

			inc cnt
			mov ecx, cnt
		cmp ecx, key
			jl readNbytes
		
		lea esi, permutationArray
		mov cnt, 0
		printNBytes:
			mov ecx, cnt
			mov eax, [esi + 4 * ecx]
			dec eax ;indexul la care corespunde elementul cnt din cei n bytes
			mov al, [edi + 4 * eax]
			mov buffer_small, al
			
			
			push fileD
			push 1
			push 1
			push offset buffer_small
			call fwrite
			add esp, 16
			
			inc cnt
			mov ecx, cnt			
		cmp ecx, key
			jl printNBytes
	jmp readloopPE
		
	FEND:
	push fileD
	call fclose
	add esp, 8
	FENDD:
	push fileR
	call fclose
	add esp, 8
	
	FENDR:
	mov edi, 0
	mov esi, 0
	mov esp, ebp
	pop ebp
	ret
permutation_encr endp

permutation_decr proc
	push ebp
	mov ebp, esp
	;fopen fisier de criptat
	push offset formatReadBin
	push offset fileToR
	call fopen
	add esp, 8
	test eax, eax
		jz FENDR
	mov fileR, eax
		
	;fopen fisier destinatar
	push offset formatWriteBin
	push offset fileToW
	call fopen
	add esp, 8
	test eax, eax
		jz FENDD
	mov fileD, eax
	;---DECRYPTION ALGORITHM---;
	readLoopPD:
		lea edi, auxArray
		lea esi, permutationArray
		mov cnt, 0
		readNbytesD:
			push fileR
			push 1
			push 1
			push offset buffer_small
			call fread
			add esp, 16
			test eax, eax
				jz FEND
			
			cmp buffer_small, ''
				je removePadding
			jmp continuePermutation
			removePadding:
				mov buffer_small, ' '
			
			continuePermutation:
			mov ecx, cnt
			mov ecx, [esi + 4 * ecx]
			dec ecx
			mov al, buffer_small
			mov [edi + 4 * ecx], al

			inc cnt
			mov ecx, cnt
		cmp ecx, key
			jl readNbytesD
		
		
		mov cnt, 0
		printNBytesD:
			mov ecx, cnt
			mov eax, [edi + 4 * ecx]
			mov buffer_small, al
			
			
			push fileD
			push 1
			push 1
			push offset buffer_small
			call fwrite
			add esp, 16
			
			inc cnt
			mov ecx, cnt			
		cmp ecx, key
			jl printNBytesD
			
	jmp readLoopPD

	
	FEND:
	push fileD
	call fclose
	add esp, 8
	FENDD:
	push fileR
	call fclose
	add esp, 8
	
	FENDR:
	add esp, 8
	mov esp, ebp
	pop ebp
	ret
permutation_decr endp