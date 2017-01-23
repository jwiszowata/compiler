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
sub esp, 28
push ebx
mov eax, dword 0
mov [ebp - 4], eax
lea eax, [ebp - 4]
push eax
mov eax, dword 2
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
mov edx, [eax]
push edx
; start for
mov eax, dword 0
mov [ebp - 8], eax
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
mov [ebp - 8], ecx
lea eax, [ebp - 8]
mov edx, [eax]
push edx
call printInt
add esp, 4
jmp .main0
.main1:
pop ecx
pop ecx
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
mov [ebp - 12], eax
lea eax, [ebp - 12]
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
mov edx, [eax]
push edx
call printInt
add esp, 4
jmp .main2
.main3:
pop ecx
pop ecx
mov edx, dword 1
inc edx
lea eax, [ebp - 4]
mov eax, [eax]
lea ecx, [eax + 4 * edx]
push ecx
mov eax, dword 1
pop edx
mov [edx], eax
mov edx, dword 1
inc edx
lea eax, [ebp - 12]
mov eax, [eax]
lea ecx, [eax + 4 * edx]
push ecx
mov eax, dword 2
pop edx
mov [edx], eax
mov edx, dword 1
inc edx
lea eax, [ebp - 4]
mov eax, [eax]
lea ecx, [eax + 4 * edx]
mov eax, ecx
mov edx, [eax]
push edx
call printInt
add esp, 4
mov edx, dword 1
inc edx
lea eax, [ebp - 12]
mov eax, [eax]
lea ecx, [eax + 4 * edx]
mov eax, ecx
mov edx, [eax]
push edx
call printInt
add esp, 4
mov edx, dword 1
inc edx
lea eax, [ebp - 4]
mov eax, [eax]
lea ecx, [eax + 4 * edx]
mov eax, ecx
mov edx, [eax]
push edx
mov edx, dword 1
inc edx
lea eax, [ebp - 4]
mov eax, [eax]
lea ecx, [eax + 4 * edx]
mov eax, ecx
mov edx, [eax]
inc edx
lea eax, [ebp - 12]
mov eax, [eax]
lea ecx, [eax + 4 * edx]
mov eax, ecx
mov edx, [eax]
mov ecx, edx
pop eax
add eax, ecx
push eax
call printInt
add esp, 4
lea eax, [ebp - 4]
mov ecx, eax
mov edx, [ecx]
mov eax, [edx]
push eax
call printInt
add esp, 4
lea eax, [ebp - 12]
mov ecx, eax
mov edx, [ecx]
mov eax, [edx]
push eax
call printInt
add esp, 4
lea eax, [ebp - 4]
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
mov edx, [eax]
push edx
call printInt
add esp, 4
jmp .main4
.main5:
pop ecx
pop ecx
lea eax, [ebp - 12]
mov edx, [eax]
push edx
; start for
mov eax, dword 0
mov [ebp - 24], eax
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
mov [ebp - 24], ecx
lea eax, [ebp - 24]
mov edx, [eax]
push edx
call printInt
add esp, 4
jmp .main6
.main7:
pop ecx
pop ecx
lea eax, [ebp - 12]
push eax
lea eax, [ebp - 4]
mov edx, [eax]
push edx
lea eax, [ebp - 12]
mov edx, [eax]
push edx
call fun
add esp, 8
pop edx
mov [edx], eax
lea eax, [ebp - 12]
mov edx, [eax]
push edx
; start for
mov eax, dword 0
mov [ebp - 28], eax
push dword 0
.main8:
pop edx
inc edx
pop eax
mov ecx, [eax]
push eax
push edx
dec edx
cmp edx, ecx
jge .main9
inc edx
mov ecx, [eax + 4 * edx]
mov [ebp - 28], ecx
lea eax, [ebp - 28]
mov edx, [eax]
push edx
call printInt
add esp, 4
jmp .main8
.main9:
pop ecx
pop ecx
mov eax, dword 0
.main.:
pop ebx
leave
ret
fun:
push ebp
mov ebp, esp
sub esp, 0
push ebx
lea eax, [ebp + 12]
mov edx, [eax]
mov eax, edx
.fun.:
pop ebx
leave
ret
