global main
extern printf, malloc, strcpy, strncat, strlen, scanf, exit
section .data
msgInt: db "%d", 10, 0
msgStr: db "%s", 10, 0
msgErr: db "runtime error", 10, 0
msgReadInt: db "%d", 0
msgReadStr: db "%s", 0
str0: db "string", 0
str1: db " ", 0
str2: db "concatenation", 0
str3: db "false", 0
str4: db "true", 0
section .text
printInt:
push ebp
mov ebp, esp
mov eax, [ebp + 8]
push eax
push msgInt
call printf
add esp, 8
leave
ret
printString:
push ebp
mov ebp, esp
mov eax, [ebp + 8]
push eax
push msgStr
call printf
add esp, 8
leave
ret
error:
push ebp
mov ebp, esp
push msgErr
call printf
add esp, 4
push dword -1
call exit
add esp, 4
leave
ret
readInt:
push ebp
mov ebp, esp
push dword 4
call malloc
add esp, 4
push eax
push eax
push msgReadInt
call scanf
add esp, 8
pop eax
mov edx, [eax]
mov eax, edx
leave
ret
readString:
push ebp
mov ebp, esp
push dword 256
call malloc
add esp, 4
push eax
push eax
push msgReadStr
call scanf
add esp, 8
pop eax
leave
ret
main:
push ebp
mov ebp, esp
sub esp, 8
push dword 56
pop eax
mov [ebp - 4], eax
push dword 23
pop eax
neg eax
push eax
pop eax
mov [ebp - 8], eax
mov eax, [ebp - 4]
push eax
mov eax, [ebp - 8]
push eax
pop ecx
pop eax
add eax, ecx
push eax
call printInt
add esp, 4
push eax
pop eax
mov eax, [ebp - 4]
push eax
mov eax, [ebp - 8]
push eax
pop ecx
pop eax
sub eax, ecx
push eax
call printInt
add esp, 4
push eax
pop eax
mov eax, [ebp - 4]
push eax
mov eax, [ebp - 8]
push eax
pop ecx
pop eax
imul eax, ecx
push eax
call printInt
add esp, 4
push eax
pop eax
push dword 45
push dword 2
pop ecx
pop eax
cdq
idiv ecx
push eax
call printInt
add esp, 4
push eax
pop eax
push dword 78
push dword 3
pop ecx
pop eax
cdq
idiv ecx
push edx
call printInt
add esp, 4
push eax
pop eax
mov eax, [ebp - 4]
push eax
mov eax, [ebp - 8]
push eax
pop ecx
pop eax
sub eax, ecx
push eax
mov eax, [ebp - 4]
push eax
mov eax, [ebp - 8]
push eax
pop ecx
pop eax
add eax, ecx
push eax
pop edx
pop eax
cmp eax, edx
jg .main0
push dword 0
jmp .main1
.main0:
push dword 1
.main1:
call printBool
add esp, 4
push eax
pop eax
mov eax, [ebp - 4]
push eax
mov eax, [ebp - 8]
push eax
pop ecx
pop eax
cdq
idiv ecx
push eax
mov eax, [ebp - 4]
push eax
mov eax, [ebp - 8]
push eax
pop ecx
pop eax
imul eax, ecx
push eax
pop edx
pop eax
cmp eax, edx
jle .main2
push dword 0
jmp .main3
.main2:
push dword 1
.main3:
call printBool
add esp, 4
push eax
pop eax
push dword 7
call malloc
add esp, 4
push eax
push str0
push eax
call strcpy
add esp, 8
push dword 2
call malloc
add esp, 4
push eax
push str1
push eax
call strcpy
add esp, 8
pop ecx
pop eax
push eax
push ecx
push eax
call strlen
add esp, 4
pop ecx
push eax
push ecx
push ecx
call strlen
add esp, 4
pop ecx
pop edx
pop edi
push eax
push ecx
push edi
add edx, eax
inc edx
push edx
call malloc
add esp, 4
push eax
call strcpy
add esp, 8
push eax
call strncat
add esp, 12
push eax
push dword 14
call malloc
add esp, 4
push eax
push str2
push eax
call strcpy
add esp, 8
pop ecx
pop eax
push eax
push ecx
push eax
call strlen
add esp, 4
pop ecx
push eax
push ecx
push ecx
call strlen
add esp, 4
pop ecx
pop edx
pop edi
push eax
push ecx
push edi
add edx, eax
inc edx
push edx
call malloc
add esp, 4
push eax
call strcpy
add esp, 8
push eax
call strncat
add esp, 12
push eax
call printString
add esp, 4
push eax
pop eax
push dword 0
pop eax
leave
ret
leave
ret
printBool:
push ebp
mov ebp, esp
sub esp, 0
mov eax, [ebp + 8]
push eax
push dword 1
pop edx
pop eax
cmp eax, edx
je .printBool0
push dword 6
call malloc
add esp, 4
push eax
push str3
push eax
call strcpy
add esp, 8
call printString
add esp, 4
push eax
pop eax
leave
ret
jmp .printBool1
.printBool0:
push dword 5
call malloc
add esp, 4
push eax
push str4
push eax
call strcpy
add esp, 8
call printString
add esp, 4
push eax
pop eax
leave
ret
.printBool1:
leave
ret
