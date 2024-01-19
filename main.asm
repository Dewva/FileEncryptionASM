.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
include macro.asm
include printMessages.asm
include menu.asm
include encrypt.asm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
menuSelect DD 0
fileToR DB '?' dup(100)
fileToW DB '?' dup(100)
encryptionType DB '?' dup(10)
command DB '?' dup(100)
key DD 0
cnt DD 0
;string ajutator
stringEncrypt DB "encrypt", 0
stringDecrypt DB "decrypt", 0
stringHelp DB "help", 0
stringExit DB "exit", 0

stringXor DB "-xor", 0
stringAtbash DB "-atbash", 0
stringAffine DB "-affine", 0
stringCaesar DB "-caesar", 0
stringPermutation DB "-permutation", 0

affineA DD 0
affineB DD 0
affineString DB '?' dup(5)
;sex
.code
;functie de comparare a string-urilor
compareString proc
	push ebp
	mov ebp, esp
	
	mov esi, [ebp + 8]
	mov edi, [ebp + 12]
	
	cmp_loop:
        lodsb
        scasb             
        jne not_equal_string     
        test al, al      
    jnz cmp_loop        
	mov eax, 1
	jmp compareFin
	
	not_equal_string:
	mov eax, 0
	
compareFin:
	mov esp,ebp
	pop ebp
	ret 12
compareString endp

		;---START MAIN---;
start:
	call printMenu
mainMenu:
	;---CITIRE COMANDA---;
	show_string comanda1
	push offset command
	push offset commandRead
	call scanf
	add esp, 8
	
	;---CRIPTARE---;
	push offset command
	push offset stringEncrypt
	call compareString
	cmp eax, 1
		je en
	;---DECRIPTARE---;
	push offset command
	push offset stringDecrypt
	call compareString
	cmp eax, 1
		je de
	;---HELP---;
	push offset command
	push offset stringHelp
	call compareString
	cmp eax, 1
		je help	
	;---EXIT---;
	push offset command
	push offset stringExit
	call compareString
	cmp eax, 1
		je fin
	jmp mainMenu
	
	;---CRIPTARE---;
	en:
		;---CITIRE TIP CRIPTARE---;
		push offset encryptionType
		push offset commandRead
		call scanf
		add esp, 8
	;---COMPARARE STRING---;
		push offset encryptionType
		push offset stringXor
		call compareString
		cmp eax, 1
			je TAG_XOR
		push offset encryptionType
		push offset stringAtbash
		call compareString
		cmp eax, 1
			je TAG_ATBASH_ENCRYPT
		push offset encryptionType
		push offset stringAffine
		call compareString
		cmp eax, 1
			je TAG_AFFINE_ENCRYPT
		push offset encryptionType
		push offset stringPermutation
		call compareString
		cmp eax, 1
			je TAG_PERMUTATION_ENCRYPT
		push offset encryptionType
		push offset stringCaesar
		call compareString
		cmp eax, 1
			je TAG_CAESAR_ENCRYPT
	jmp mainMenu
	TAG_XOR:
		push offset key
		push offset formatDecimalRead
		call scanf
		add esp, 8
		
		push offset fileToR
		push offset commandRead
		call scanf
		add esp, 8
		
		push offset fileToW
		push offset commandRead
		call scanf
		add esp, 8

		call xor_encr
	jmp mainMenu	
	
	TAG_ATBASH_ENCRYPT:
		push offset fileToR
		push offset commandRead
		call scanf
		add esp, 8
		
		push offset fileToW
		push offset commandRead
		call scanf
		add esp, 8
		
		mov affineA, 25
		mov affineB, 25
		call affine_encr
	jmp mainMenu	
	TAG_AFFINE_ENCRYPT:
		push offset affineString
		push offset commandRead
		call scanf
		add esp, 8
		
		push offset affineA
		push offset formatDecimalRead
		call scanf
		add esp, 8
		
		push offset affineString
		push offset commandRead
		call scanf
		add esp, 8
		
		push offset affineB
		push offset formatDecimalRead
		call scanf
		add esp, 8
		
		push offset fileToR
		push offset commandRead
		call scanf
		add esp, 8
		
		push offset fileToW
		push offset commandRead
		call scanf
		add esp, 8
		
		call affine_encr
	jmp mainMenu
	TAG_PERMUTATION_ENCRYPT:
		push offset affineString
		push offset commandRead
		call scanf
		add esp, 8
		
		push offset key
		push offset formatDecimalRead
		call scanf
		add esp, 8

		mov cnt, 0
		lea edi, permutationArray
		readPermutationE:
			push offset buffer
			push offset formatDecimalRead
			call scanf
			add esp, 8
			
			mov eax, buffer
			cmp eax, key
				jg mainMenu
			
			mov ecx, cnt
			mov [edi + 4 * ecx], eax
			
			inc cnt
			mov ecx, cnt
		cmp ecx, key
			jl readPermutationE
			
		push offset fileToR
		push offset commandRead
		call scanf
		add esp, 8
		
		push offset fileToW
		push offset commandRead
		call scanf
		add esp, 8
		mov cnt, 0
		
		call permutation_encr
	jmp mainMenu
	TAG_CAESAR_ENCRYPT:
		push offset key
		push offset formatDecimalRead
		call scanf
		add esp, 8
		
		push offset fileToR
		push offset commandRead
		call scanf
		add esp, 8
		
		push offset fileToW
		push offset commandRead
		call scanf
		add esp, 8

		call caesar_encr
	jmp mainMenu	
	;---DECRIPTARE---;
	
	de:
		;---CITIRE TIP DECRIPTARE---;
		push offset encryptionType
		push offset commandRead
		call scanf
		add esp, 8
	;---COMPARARE STRING---;
		push offset encryptionType
		push offset stringXor
		call compareString
		cmp eax, 1
			je TAG_XOR
		push offset encryptionType
		push offset stringAtbash
		call compareString
		cmp eax, 1
			je TAG_ATBASH_DECRYPT
		push offset encryptionType
		push offset stringAffine
		call compareString
		cmp eax, 1
			je TAG_AFFINE_DECRYPT
		push offset encryptionType
		push offset stringPermutation
		call compareString
		cmp eax, 1
			je TAG_PERMUTATION_DECRYPT
		push offset encryptionType
		push offset stringCaesar
		call compareString
		cmp eax, 1
			je TAG_CAESAR_DECRYPT
	jmp mainMenu
	TAG_ATBASH_DECRYPT:
		push offset fileToR
		push offset commandRead
		call scanf
		add esp, 8
		
		push offset fileToW
		push offset commandRead
		call scanf
		add esp, 8
		
		mov affineA, 25
		mov affineB, 25
		call affine_encr
	jmp mainMenu	
	TAG_AFFINE_DECRYPT:
		push offset affineString
		push offset commandRead
		call scanf
		add esp, 8
		
		push offset affineA
		push offset formatDecimalRead
		call scanf
		add esp, 8
		
		push offset affineString
		push offset commandRead
		call scanf
		add esp, 8
		
		push offset affineB
		push offset formatDecimalRead
		call scanf
		add esp, 8
		
		push offset fileToR
		push offset commandRead
		call scanf
		add esp, 8
		
		push offset fileToW
		push offset commandRead
		call scanf
		add esp, 8
		
		
		call affine_decr
	jmp mainMenu
	TAG_PERMUTATION_DECRYPT:
		push offset affineString
		push offset commandRead
		call scanf
		add esp, 8
		
		push offset key
		push offset formatDecimalRead
		call scanf
		add esp, 8

		mov cnt, 0
		lea edi, permutationArray
		readPermutationD:
			push offset buffer
			push offset formatDecimalRead
			call scanf
			add esp, 8
			
			mov eax, buffer
			cmp eax, key
				jg fin
			
			mov ecx, cnt
			mov [edi + 4 * ecx], eax
			
			inc cnt
			mov ecx, cnt
		cmp ecx, key
			jl readPermutationD
			
		push offset fileToR
		push offset commandRead
		call scanf
		add esp, 8
		
		push offset fileToW
		push offset commandRead
		call scanf
		add esp, 8
		mov cnt, 0
		
		call permutation_decr
	jmp mainMenu
	
	TAG_CAESAR_DECRYPT:
		push offset key
		push offset formatDecimalRead
		call scanf
		add esp, 8
		
		push offset fileToR
		push offset commandRead
		call scanf
		add esp, 8
		
		push offset fileToW
		push offset commandRead
		call scanf
		add esp, 8

		call caesar_decr
	jmp mainMenu		
help:
	call printHelp
	jmp start

fin:
	push 0
	call exit
end start
