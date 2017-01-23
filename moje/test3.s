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
p:
push ebp
mov ebp, esp
sub esp, 0
push ebx
lea eax, [ebp + 8]
mov edx, [eax]
push edx
mov edx, dword 1
pop eax
cmp eax, edx
je .p0
mov eax, dword 4
jmp .p.
jmp .p1
.p0:
mov eax, dword 3
jmp .p.
.p1:
.p.:
pop ebx
leave
ret
main:
push ebp
mov ebp, esp
sub esp, 12
push ebx
mov eax, dword 1
mov [ebp - 4], eax
mov eax, dword 0
mov [ebp - 8], eax
mov eax, dword 0
mov [ebp - 12], eax
lea eax, [ebp - 4]
mov edx, [eax]
push edx
mov edx, dword 1
pop eax
cmp eax, edx
je .main0
push dword 0
jmp .main1
.main0:
push dword 1
.main1:
mov edx, dword 1
pop eax
cmp eax, edx
je .main2
jmp .main3
.main2:
lea eax, [ebp - 8]
push eax
push dword 5
lea eax, [ebp - 4]
mov edx, [eax]
pop eax
cmp eax, edx
jg .main4
push dword 0
jmp .main5
.main4:
push dword 1
.main5:
call p
add esp, 4
pop edx
mov [edx], eax
lea eax, [ebp - 12]
push eax
push dword 5
lea eax, [ebp - 4]
mov edx, [eax]
pop eax
cmp eax, edx
jl .main6
push dword 0
jmp .main7
.main6:
push dword 1
.main7:
call p
add esp, 4
pop edx
mov [edx], eax
.main3:
lea eax, [ebp - 4]
mov edx, [eax]
push edx
call printInt
add esp, 4
lea eax, [ebp - 8]
mov edx, [eax]
push edx
call printInt
add esp, 4
lea eax, [ebp - 12]
mov edx, [eax]
push edx
call printInt
add esp, 4
lea eax, [ebp - 8]
mov edx, [eax]
push edx
lea eax, [ebp - 12]
mov edx, [eax]
mov ecx, edx
pop eax
add eax, ecx
lea eax, [ebp - 8]
mov edx, [eax]
push edx
lea eax, [ebp - 12]
mov edx, [eax]
mov ecx, edx
pop eax
add eax, ecx
push eax
call printInt
add esp, 4
mov eax, dword 0
.main.:
pop ebx
leave
ret
