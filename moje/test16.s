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
sub esp, 4
push ebx
mov eax, 1
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
mov [ebp - 4], eax
lea eax, [ebp - 4]
mov ecx, eax
mov edx, [ecx]
mov eax, dword 0
lea ecx, [edx + 4 * eax]
push ecx
mov eax, dword 3
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
pop edx
mov [edx], eax
lea eax, [ebp - 4]
mov ecx, eax
mov edx, [ecx]
mov ecx, dword 0
mov eax, [edx + 4 * ecx]
push eax
mov edx, dword 0
pop eax
inc edx
lea ecx, [eax + 4 * edx]
push ecx
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
pop edx
mov [edx], eax
lea eax, [ebp - 4]
mov ecx, eax
mov edx, [ecx]
mov ecx, dword 0
mov eax, [edx + 4 * ecx]
push eax
mov edx, dword 0
pop eax
inc edx
lea ecx, [eax + 4 * edx]
mov edx, [ecx]
mov eax, dword 0
lea ecx, [edx + 4 * eax]
push ecx
mov eax, dword 10
pop edx
mov [edx], eax
lea eax, [ebp - 4]
mov ecx, eax
mov edx, [ecx]
mov ecx, dword 0
mov eax, [edx + 4 * ecx]
push eax
mov edx, dword 0
pop eax
inc edx
lea ecx, [eax + 4 * edx]
mov edx, [ecx]
mov eax, dword 1
lea ecx, [edx + 4 * eax]
push ecx
mov eax, dword 2
pop edx
mov [edx], eax
lea eax, [ebp - 4]
mov ecx, eax
mov edx, [ecx]
mov ecx, dword 0
mov eax, [edx + 4 * ecx]
push eax
mov edx, dword 0
pop eax
inc edx
lea ecx, [eax + 4 * edx]
mov edx, [ecx]
mov eax, dword 0
lea ecx, [edx + 4 * eax]
mov eax, ecx
mov edx, [eax]
push edx
call printInt
add esp, 4
lea eax, [ebp - 4]
mov ecx, eax
mov edx, [ecx]
mov ecx, dword 0
mov eax, [edx + 4 * ecx]
push eax
mov edx, dword 0
pop eax
inc edx
lea ecx, [eax + 4 * edx]
mov edx, [ecx]
mov eax, dword 1
lea ecx, [edx + 4 * eax]
mov eax, ecx
mov edx, [eax]
push edx
call printInt
add esp, 4
mov eax, dword 0
.main.:
pop ebx
leave
ret
