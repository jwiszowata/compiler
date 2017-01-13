global main
extern printf, malloc, strcpy, strncat, strlen, scanf, exit
section .data
msgInt: db "%d", 10, 0
msgStr: db "%s", 10, 0
msgErr: db "runtime error", 10, 0
msgReadInt: db "%d", 0
msgReadStr: db "%s", 0
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
sub esp, 12
call readInt
add esp, 0
push eax
pop eax
mov [ebp - 4], eax
call readString
add esp, 0
push eax
pop eax
mov [ebp - 8], eax
call readString
add esp, 0
push eax
pop eax
mov [ebp - 12], eax
mov eax, [ebp - 4]
push eax
push dword 5
pop ecx
pop eax
sub eax, ecx
push eax
call printInt
add esp, 4
push eax
pop eax
mov eax, [ebp - 8]
push eax
mov eax, [ebp - 12]
push eax
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
