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
sub esp, 0
push ebx
mov eax, dword 0
mov edx, 1
xor eax, edx
push eax
mov edx, dword 1
pop eax
cmp eax, edx
je .main0
push dword 100
call retTrue
add esp, 4
push eax
jmp .main1
.main0:
push dword 0
.main1:
pop eax
mov eax, dword 1
mov edx, 1
xor eax, edx
push eax
mov edx, dword 1
pop eax
cmp eax, edx
je .main2
push dword 200
call retTrue
add esp, 4
push eax
jmp .main3
.main2:
push dword 0
.main3:
pop eax
push dword 0
mov edx, dword 1
pop eax
cmp eax, edx
je .main4
push dword 300
call retTrue
add esp, 4
push eax
jmp .main5
.main4:
push dword 1
.main5:
pop eax
push dword 1
mov edx, dword 1
pop eax
cmp eax, edx
je .main6
push dword 400
call retTrue
add esp, 4
push eax
jmp .main7
.main6:
push dword 1
.main7:
pop eax
mov eax, dword 0
.main.:
pop ebx
leave
ret
retTrue:
push ebp
mov ebp, esp
sub esp, 0
push ebx
lea eax, [ebp + 8]
mov edx, [eax]
push edx
call printInt
add esp, 4
mov eax, dword 1
.retTrue.:
pop ebx
leave
ret
