global main
extern printf, malloc, strcpy, strncat, strlen, scanf, exit, memset
section .data
msgInt: db "%d", 10, 0
msgStr: db "%s", 10, 0
msgErr: db "runtime error", 10, 0
msgReadInt: db "%d", 0
msgReadStr: db "%s", 0
emptyStr: db "", 0
str0: db "done", 0
str1: db "done", 0
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
sub esp, 32
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
push eax
pop eax
mov [ebp - 4], eax
lea eax, [ebp - 4]
push eax
pop ecx
mov edx, [ecx]
mov eax, dword 0
lea ecx, [edx + 4 * eax]
push ecx
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
pop edx
mov [edx], eax
lea eax, [ebp - 4]
push eax
pop ecx
mov edx, [ecx]
mov ecx, dword 0
mov eax, [edx + 4 * ecx]
push eax
push dword 0
pop edx
pop eax
inc edx
lea ecx, [eax + 4 * edx]
push ecx
push dword 1
pop eax
pop edx
mov [edx], eax
lea eax, [ebp - 4]
push eax
pop ecx
mov edx, [ecx]
mov ecx, dword 0
mov eax, [edx + 4 * ecx]
push eax
push dword 1
pop edx
pop eax
inc edx
lea ecx, [eax + 4 * edx]
push ecx
push dword 2
pop eax
pop edx
mov [edx], eax
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
mov [ebp - 8], eax
lea eax, [ebp - 8]
push eax
pop ecx
mov edx, [ecx]
mov eax, dword 0
lea ecx, [edx + 4 * eax]
push ecx
lea eax, [ebp - 4]
push eax
pop eax
mov edx, [eax]
push edx
pop eax
pop edx
mov [edx], eax
lea eax, [ebp - 8]
push eax
pop ecx
mov edx, [ecx]
mov eax, dword 1
lea ecx, [edx + 4 * eax]
push ecx
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
pop edx
mov [edx], eax
lea eax, [ebp - 8]
push eax
pop ecx
mov edx, [ecx]
mov ecx, dword 1
mov eax, [edx + 4 * ecx]
push eax
push dword 0
pop edx
pop eax
inc edx
lea ecx, [eax + 4 * edx]
push ecx
lea eax, [ebp - 4]
push eax
pop eax
mov edx, [eax]
push edx
pop eax
pop edx
mov [edx], eax
lea eax, [ebp - 8]
push eax
pop ecx
mov edx, [ecx]
mov ecx, dword 1
mov eax, [edx + 4 * ecx]
push eax
push dword 1
pop edx
pop eax
inc edx
lea ecx, [eax + 4 * edx]
push ecx
lea eax, [ebp - 4]
push eax
pop eax
mov edx, [eax]
push edx
pop eax
pop edx
mov [edx], eax
lea eax, [ebp - 8]
push eax
pop ecx
mov edx, [ecx]
mov ecx, dword 1
mov eax, [edx + 4 * ecx]
push eax
push dword 2
pop edx
pop eax
inc edx
lea ecx, [eax + 4 * edx]
push ecx
lea eax, [ebp - 4]
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
mov eax, dword 0
lea ecx, [edx + 4 * eax]
push ecx
pop eax
mov edx, [eax]
push edx
; start for
mov eax, dword 0
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
lea eax, [ebp - 12]
push eax
pop eax
mov edx, [eax]
push edx
call printInt
add esp, 4
push eax
pop eax
jmp .main0
.main1:
pop ecx
pop ecx
push dword 5
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
lea eax, [ebp - 8]
push eax
pop ecx
mov edx, [ecx]
mov eax, dword 0
lea ecx, [edx + 4 * eax]
push ecx
pop ecx
mov edx, [ecx]
mov eax, dword 0
lea ecx, [edx + 4 * eax]
push ecx
pop eax
mov edx, [eax]
push edx
; start for
mov eax, dword 0
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
lea eax, [ebp - 16]
push eax
pop eax
mov edx, [eax]
push edx
call printInt
add esp, 4
push eax
pop eax
jmp .main2
.main3:
pop ecx
pop ecx
push dword 5
call malloc
add esp, 4
push eax
push str1
push eax
call strcpy
add esp, 8
call printString
add esp, 4
push eax
pop eax
lea eax, [ebp - 8]
push eax
pop ecx
mov edx, [ecx]
mov ecx, dword 1
mov eax, [edx + 4 * ecx]
push eax
push dword 1
pop edx
pop eax
inc edx
lea ecx, [eax + 4 * edx]
push ecx
pop ecx
mov edx, [ecx]
mov eax, dword 0
lea ecx, [edx + 4 * eax]
push ecx
pop eax
mov edx, [eax]
push edx
; start for
mov eax, dword 0
mov [ebp - 20], eax
push dword 0
.main4:
pop edx
inc edx
pop eax
mov ecx, [eax]
push eax
push edx
dec edx
cmp edx, ecx
jge .main5
inc edx
mov ecx, [eax + 4 * edx]
mov [ebp - 20], ecx
lea eax, [ebp - 20]
push eax
pop eax
mov edx, [eax]
push edx
call printInt
add esp, 4
push eax
pop eax
jmp .main4
.main5:
pop ecx
pop ecx
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
mov [ebp - 24], eax
push dword 1
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
mov [ebp - 28], eax
push dword 0
pop edx
inc edx
mov eax, [ebp - 28]
lea ecx, [eax + 4 * edx]
push ecx
push dword 4
pop eax
pop edx
mov [edx], eax
push dword 0
pop edx
inc edx
mov eax, [ebp - 24]
lea ecx, [eax + 4 * edx]
push ecx
lea eax, [ebp - 28]
push eax
pop eax
mov edx, [eax]
push edx
pop eax
pop edx
mov [edx], eax
push dword 1
pop edx
inc edx
mov eax, [ebp - 24]
lea ecx, [eax + 4 * edx]
push ecx
lea eax, [ebp - 28]
push eax
pop eax
mov edx, [eax]
push edx
pop eax
pop edx
mov [edx], eax
push dword 0
pop edx
inc edx
mov eax, [ebp - 24]
lea ecx, [eax + 4 * edx]
push ecx
pop eax
mov edx, [eax]
push edx
; start for
mov eax, dword 0
mov [ebp - 32], eax
push dword 0
.main6:
pop edx
inc edx
pop eax
mov ecx, [eax]
push eax
push edx
dec edx
cmp edx, ecx
jge .main7
inc edx
mov ecx, [eax + 4 * edx]
mov [ebp - 32], ecx
lea eax, [ebp - 32]
push eax
pop eax
mov edx, [eax]
push edx
call printInt
add esp, 4
push eax
pop eax
jmp .main6
.main7:
pop ecx
pop ecx
push dword 0
pop eax
leave
ret
leave
ret
