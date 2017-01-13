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
sub esp, 4
push dword 1
pop eax
mov [ebp - 4], eax
mov eax, [ebp - 4]
push eax
push dword 1
pop edx
pop eax
cmp eax, edx
je .main0
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
jmp .main3
.main2:
push dword 1
call printInt
add esp, 4
push eax
pop eax
push dword 1
pop eax
leave
ret
.main3:
mov eax, [ebp - 4]
push eax
push dword 2
pop edx
pop eax
cmp eax, edx
je .main4
push dword 0
jmp .main5
.main4:
push dword 1
.main5:
push dword 1
pop edx
pop eax
cmp eax, edx
je .main6
jmp .main7
.main6:
push dword 1
pop eax
leave
ret
.main7:
mov eax, [ebp - 4]
push eax
push dword 3
pop edx
pop eax
cmp eax, edx
je .main8
push dword 0
jmp .main9
.main8:
push dword 1
.main9:
push dword 1
pop edx
pop eax
cmp eax, edx
je .main10
jmp .main11
.main10:
push dword 3
pop eax
leave
ret
.main11:
push dword 0
pop eax
leave
ret
leave
ret
