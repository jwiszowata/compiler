global main
extern printf, malloc, strcpy, strncat, strlen, scanf, exit, memset
section .data
msgInt: db "%d", 10, 0
msgStr: db "%s", 10, 0
msgErr: db "runtime error", 10, 0
msgReadInt: db "%d", 0
msgReadStr: db "%s", 0
emptyStr: db "", 0
str0: db "a0", 0
str1: db "a1", 0
str2: db "b0", 0
str3: db "b1", 0
str4: db "b2", 0
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
sub esp, 16
push ebx
push dword 2
pop eax
push eax
inc eax
mov edx, dword 4
imul edx
push eax
push eax
call malloc
add esp, 4
push dword 0
push eax
call memset
add esp, 12
pop edx
mov [eax], edx
push eax
pop eax
mov [ebp - 4], eax
push dword 3
pop eax
push eax
inc eax
mov edx, dword 4
imul edx
push eax
push eax
call malloc
add esp, 4
push dword 0
push eax
call memset
add esp, 12
pop edx
mov [eax], edx
push eax
pop eax
mov [ebp - 8], eax
push dword 0
pop edx
inc edx
lea eax, [ebp - 4]
mov eax, [eax]
lea ecx, [eax + 4 * edx]
push ecx
push dword 3
call malloc
add esp, 4
push eax
push str0
push eax
call strcpy
add esp, 8
pop eax
pop edx
mov [edx], eax
push dword 1
pop edx
inc edx
lea eax, [ebp - 4]
mov eax, [eax]
lea ecx, [eax + 4 * edx]
push ecx
push dword 3
call malloc
add esp, 4
push eax
push str1
push eax
call strcpy
add esp, 8
pop eax
pop edx
mov [edx], eax
push dword 0
pop edx
inc edx
lea eax, [ebp - 8]
mov eax, [eax]
lea ecx, [eax + 4 * edx]
push ecx
push dword 3
call malloc
add esp, 4
push eax
push str2
push eax
call strcpy
add esp, 8
pop eax
pop edx
mov [edx], eax
push dword 1
pop edx
inc edx
lea eax, [ebp - 8]
mov eax, [eax]
lea ecx, [eax + 4 * edx]
push ecx
push dword 3
call malloc
add esp, 4
push eax
push str3
push eax
call strcpy
add esp, 8
pop eax
pop edx
mov [edx], eax
push dword 2
pop edx
inc edx
lea eax, [ebp - 8]
mov eax, [eax]
lea ecx, [eax + 4 * edx]
push ecx
push dword 3
call malloc
add esp, 4
push eax
push str4
push eax
call strcpy
add esp, 8
pop eax
pop edx
mov [edx], eax
lea eax, [ebp - 4]
push eax
pop eax
mov edx, [eax]
push edx
; start for
mov eax, emptyStr
mov [ebp - 12], eax
push dword 0
.main0:
pop edx
inc edx
pop eax
mov ecx, [eax]
push eax
push edx
dec edx
cmp edx, ecx
jge .main1
inc edx
mov ecx, [eax + 4 * edx]
mov [ebp - 12], ecx
lea eax, [ebp - 8]
push eax
pop eax
mov edx, [eax]
push edx
; start for
mov eax, emptyStr
mov [ebp - 16], eax
push dword 0
.main2:
pop edx
inc edx
pop eax
mov ecx, [eax]
push eax
push edx
dec edx
cmp edx, ecx
jge .main3
inc edx
mov ecx, [eax + 4 * edx]
mov [ebp - 16], ecx
lea eax, [ebp - 12]
push eax
pop eax
mov edx, [eax]
push edx
lea eax, [ebp - 16]
push eax
pop eax
mov edx, [eax]
push edx
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
jmp .main2
.main3:
pop ecx
pop ecx
jmp .main0
.main1:
pop ecx
pop ecx
push dword 0
pop eax
pop ebx
leave
ret
pop ebx
leave
ret
