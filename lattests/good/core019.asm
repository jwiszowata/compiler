global main
extern printf, malloc, strcpy, strncat, strlen, scanf, exit
section .data
msgInt: db "%d", 10, 0
msgStr: db "%s", 10, 0
msgErr: db "runtime error", 10, 0
msgReadInt: db "%d", 0
msgReadStr: db "%s", 0
str0: db "foo", 0
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
push dword 78
pop eax
mov [ebp - 4], eax
push dword 1
pop eax
mov [ebp - 8], eax
mov eax, [ebp - 8]
push eax
call printInt
add esp, 4
push eax
pop eax
mov eax, [ebp - 4]
push eax
call printInt
add esp, 4
push eax
pop eax
.main0:
mov eax, [ebp - 4]
push eax
push dword 76
pop edx
pop eax
cmp eax, edx
jg .main1
push dword 0
jmp .main2
.main1:
push dword 1
.main2:
pop eax
mov edx, dword 0
cmp edx, eax
je .main3
mov eax, [ebp - 4]
dec eax
mov [ebp - 4], eax
mov eax, [ebp - 4]
push eax
call printInt
add esp, 4
push eax
pop eax
mov eax, [ebp - 4]
push eax
push dword 7
pop ecx
pop eax
add eax, ecx
push eax
pop eax
mov [ebp - 12], eax
mov eax, [ebp - 12]
push eax
call printInt
add esp, 4
push eax
pop eax
jmp .main0
.main3:
mov eax, [ebp - 4]
push eax
call printInt
add esp, 4
push eax
pop eax
mov eax, [ebp - 4]
push eax
push dword 4
pop edx
pop eax
cmp eax, edx
jg .main4
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
push dword 4
call malloc
add esp, 4
push eax
push str0
push eax
call strcpy
add esp, 8
call printString
add esp, 4
push eax
pop eax
jmp .main7
.main6:
push dword 4
pop eax
mov [ebp - 16], eax
mov eax, [ebp - 16]
push eax
call printInt
add esp, 4
push eax
pop eax
.main7:
mov eax, [ebp - 4]
push eax
call printInt
add esp, 4
push eax
pop eax
push dword 0
pop eax
leave
ret
leave
ret
