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
push dword 50
push dword 1
call fromTo
add esp, 8
push eax
call length
add esp, 4
push eax
call printInt
add esp, 4
push eax
pop eax
push dword 100
push dword 1
call fromTo
add esp, 8
push eax
call length2
add esp, 4
push eax
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
head:
push ebp
mov ebp, esp
sub esp, 0
push ebx
lea eax, [ebp + 8]
push eax
pop ecx
mov edx, [ecx]
mov eax, dword 0
lea ecx, [edx + 4 * eax]
push ecx
pop eax
mov edx, [eax]
push edx
pop eax
pop ebx
leave
ret
pop ebx
leave
ret
cons:
push ebp
mov ebp, esp
sub esp, 4
push ebx
mov eax, dword 0
mov [ebp - 4], eax
lea eax, [ebp - 4]
push eax
mov eax, 2
mov edx, 4
imul edx
push eax
push eax
call malloc
add esp, 4
push dword 0
push eax
call memset
add esp, 12
push eax
pop eax
pop edx
mov [edx], eax
lea eax, [ebp - 4]
push eax
pop ecx
mov edx, [ecx]
mov eax, dword 0
lea ecx, [edx + 4 * eax]
push ecx
lea eax, [ebp + 8]
push eax
pop eax
mov edx, [eax]
push edx
pop eax
pop edx
mov [edx], eax
lea eax, [ebp - 4]
push eax
pop ecx
mov edx, [ecx]
mov eax, dword 1
lea ecx, [edx + 4 * eax]
push ecx
lea eax, [ebp + 12]
push eax
pop eax
mov edx, [eax]
push edx
pop eax
pop edx
mov [edx], eax
lea eax, [ebp - 4]
push eax
pop eax
mov edx, [eax]
push edx
pop eax
pop ebx
leave
ret
pop ebx
leave
ret
length:
push ebp
mov ebp, esp
sub esp, 0
push ebx
lea eax, [ebp + 8]
push eax
pop eax
mov edx, [eax]
push edx
push dword 0
pop edx
pop eax
cmp eax, edx
je .length0
push dword 0
jmp .length1
.length0:
push dword 1
.length1:
push dword 1
pop edx
pop eax
cmp eax, edx
je .length2
push dword 1
lea eax, [ebp + 8]
push eax
pop ecx
mov edx, [ecx]
mov eax, dword 1
lea ecx, [edx + 4 * eax]
push ecx
pop eax
mov edx, [eax]
push edx
call length
add esp, 4
push eax
pop ecx
pop eax
add eax, ecx
push eax
pop eax
pop ebx
leave
ret
jmp .length3
.length2:
push dword 0
pop eax
pop ebx
leave
ret
.length3:
pop ebx
leave
ret
fromTo:
push ebp
mov ebp, esp
sub esp, 0
push ebx
lea eax, [ebp + 8]
push eax
pop eax
mov edx, [eax]
push edx
lea eax, [ebp + 12]
push eax
pop eax
mov edx, [eax]
push edx
pop edx
pop eax
cmp eax, edx
jg .fromTo0
push dword 0
jmp .fromTo1
.fromTo0:
push dword 1
.fromTo1:
push dword 1
pop edx
pop eax
cmp eax, edx
je .fromTo2
lea eax, [ebp + 12]
push eax
pop eax
mov edx, [eax]
push edx
lea eax, [ebp + 8]
push eax
pop eax
mov edx, [eax]
push edx
push dword 1
pop ecx
pop eax
add eax, ecx
push eax
call fromTo
add esp, 8
push eax
lea eax, [ebp + 8]
push eax
pop eax
mov edx, [eax]
push edx
call cons
add esp, 8
push eax
pop eax
pop ebx
leave
ret
jmp .fromTo3
.fromTo2:
push dword 0
pop eax
pop ebx
leave
ret
.fromTo3:
pop ebx
leave
ret
length2:
push ebp
mov ebp, esp
sub esp, 4
push ebx
push dword 0
pop eax
mov [ebp - 4], eax
.length20:
lea eax, [ebp + 8]
push eax
pop eax
mov edx, [eax]
push edx
push dword 0
pop edx
pop eax
cmp eax, edx
jne .length21
push dword 0
jmp .length22
.length21:
push dword 1
.length22:
pop eax
mov edx, dword 0
cmp edx, eax
je .length23
lea eax, [ebp - 4]
push eax
pop eax
mov edx, [eax]
inc edx
mov [eax], edx
lea eax, [ebp + 8]
push eax
lea eax, [ebp + 8]
push eax
pop ecx
mov edx, [ecx]
mov eax, dword 1
lea ecx, [edx + 4 * eax]
push ecx
pop eax
mov edx, [eax]
push edx
pop eax
pop edx
mov [edx], eax
jmp .length20
.length23:
lea eax, [ebp - 4]
push eax
pop eax
mov edx, [eax]
push edx
pop eax
pop ebx
leave
ret
pop ebx
leave
ret
