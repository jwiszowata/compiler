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
sub esp, 24
push ebx
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
mov [ebp - 4], eax
lea eax, [ebp - 4]
mov ebx, eax
mov ebx, [ebx]
push dword 5
push ebx
call Nad.getPT
add esp, 8
mov [ebp - 8], eax
mov edx, dword 2
inc edx
lea eax, [ebp - 8]
mov eax, [eax]
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
mov eax, dword 1
lea ecx, [edx + 4 * eax]
mov eax, ecx
mov edx, [eax]
mov eax, edx
mov [ebp - 12], eax
mov edx, dword 2
inc edx
lea eax, [ebp - 12]
mov eax, [eax]
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
mov ecx, dword 1
mov eax, [edx + 4 * ecx]
push eax
mov edx, dword 4
pop eax
inc edx
lea ecx, [eax + 4 * edx]
mov eax, ecx
mov edx, [eax]
mov eax, edx
mov [ebp - 16], eax
lea eax, [ebp - 16]
mov ecx, eax
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
mov ecx, dword 1
mov eax, [edx + 4 * ecx]
push eax
mov edx, dword 2
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
mov [ebp - 20], eax
lea eax, [ebp - 20]
mov ecx, eax
mov edx, [ecx]
mov eax, dword 0
lea ecx, [edx + 4 * eax]
push ecx
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
pop edx
mov [edx], eax
lea eax, [ebp - 20]
mov ebx, eax
mov ebx, [ebx]
push ebx
call Nad.getPod
add esp, 4
mov edx, eax
mov eax, dword 0
lea ecx, [edx + 4 * eax]
mov eax, ecx
mov edx, [eax]
mov eax, edx
mov [ebp - 24], eax
lea eax, [ebp - 24]
mov edx, [eax]
push edx
call printInt
add esp, 4
mov eax, dword 0
.main.:
pop ebx
leave
ret
Pod.setX:
push ebp
mov ebp, esp
sub esp, 0
push ebx
lea eax, [ebp + 8]
mov ecx, [eax]
lea eax, [ecx]
push eax
lea eax, [ebp + 12]
mov edx, [eax]
mov eax, edx
pop edx
mov [edx], eax
.Pod.setX.:
pop ebx
leave
ret
Pod.getX:
push ebp
mov ebp, esp
sub esp, 0
push ebx
lea eax, [ebp + 8]
mov ecx, [eax]
lea eax, [ecx]
mov edx, [eax]
mov eax, edx
.Pod.getX.:
pop ebx
leave
ret
Nad.getPT:
push ebp
mov ebp, esp
sub esp, 8
push ebx
lea eax, [ebp + 8]
mov ecx, [eax]
lea eax, [ecx + 4]
push eax
lea eax, [ebp + 12]
mov edx, [eax]
mov eax, edx
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
mov eax, dword 0
mov [ebp - 4], eax
lea eax, [ebp + 8]
mov ecx, [eax]
lea eax, [ecx + 4]
mov ecx, eax
mov edx, [ecx]
mov eax, [edx]
push eax
call printInt
add esp, 4
.Nad.getPT0:
lea eax, [ebp - 4]
mov edx, [eax]
push edx
lea eax, [ebp + 8]
mov ecx, [eax]
lea eax, [ecx + 4]
mov ecx, eax
mov edx, [ecx]
mov eax, [edx]
mov edx, eax
pop eax
cmp eax, edx
jl .Nad.getPT1
push dword 0
jmp .Nad.getPT2
.Nad.getPT1:
push dword 1
.Nad.getPT2:
pop eax
mov edx, dword 0
cmp edx, eax
je .Nad.getPT3
lea eax, [ebp - 4]
mov edx, [eax]
inc edx
lea eax, [ebp + 8]
mov ecx, [eax]
lea eax, [ecx + 4]
mov eax, [eax]
lea ecx, [eax + 4 * edx]
push ecx
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
pop edx
mov [edx], eax
lea eax, [ebp - 4]
mov edx, [eax]
inc edx
lea eax, [ebp + 8]
mov ecx, [eax]
lea eax, [ecx + 4]
mov eax, [eax]
lea ecx, [eax + 4 * edx]
mov ebx, ecx
mov ebx, [ebx]
lea eax, [ebp - 4]
mov edx, [eax]
push edx
push ebx
call Pod.setX
add esp, 8
lea eax, [ebp - 4]
mov edx, [eax]
inc edx
lea eax, [ebp + 8]
mov ecx, [eax]
lea eax, [ecx + 4]
mov eax, [eax]
lea ecx, [eax + 4 * edx]
mov eax, ecx
mov edx, [eax]
mov eax, edx
mov [ebp - 8], eax
lea eax, [ebp - 8]
mov ebx, eax
mov ebx, [ebx]
push ebx
call Pod.getX
add esp, 4
push eax
call printInt
add esp, 4
lea eax, [ebp - 4]
mov edx, [eax]
inc edx
mov [eax], edx
jmp .Nad.getPT0
.Nad.getPT3:
lea eax, [ebp + 8]
mov ecx, [eax]
lea eax, [ecx + 4]
mov edx, [eax]
mov eax, edx
.Nad.getPT.:
pop ebx
leave
ret
Nad.getPod:
push ebp
mov ebp, esp
sub esp, 0
push ebx
lea eax, [ebp + 8]
mov ecx, [eax]
lea eax, [ecx]
mov edx, [eax]
mov eax, edx
.Nad.getPod.:
pop ebx
leave
ret
