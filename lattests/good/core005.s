global main
extern printf, malloc, strcpy, strncat, strlen, scanf, exit, memset
section .data
msgInt: db "%d", 10, 0
msgStr: db "%s", 10, 0
msgErr: db "runtime error", 10, 0
msgReadInt: db "%d", 0
msgReadStr: db "%s", 0
emptyStr: db "", 0
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
push ebx
mov eax, dword 0
mov [ebp - 4], eax
push dword 56
pop eax
mov [ebp - 8], eax
lea eax, [ebp - 8]
push eax
pop eax
mov edx, [eax]
push edx
push dword 45
pop ecx
pop eax
add eax, ecx
push eax
push dword 2
pop edx
pop eax
cmp eax, edx
jle .main0
push dword 0
jmp .main1
.main0:
push dword 1
.main1:
push dword 1
pop edx
pop eax
cmp eax, edx
je .main2
lea eax, [ebp - 4]
push eax
push dword 2
pop eax
pop edx
mov [edx], eax
jmp .main3
.main2:
lea eax, [ebp - 4]
push eax
push dword 1
pop eax
pop edx
mov [edx], eax
.main3:
lea eax, [ebp - 4]
push eax
pop eax
mov edx, [eax]
push edx
call printInt
add esp, 4
push eax
pop eax
push dword 0
pop eax
pop ebx
leave
ret
pop ebx
leave
ret
