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
doubleArray:
push ebp
mov ebp, esp
sub esp, 12
lea eax, [ebp + 8]
push eax
pop ecx
mov edx, [ecx]
push edx
pop eax
mov edx, [eax]
push edx
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
mov [ebp - 4], eax
push dword 0
pop eax
mov [ebp - 8], eax
lea eax, [ebp + 8]
push eax
pop eax
mov edx, [eax]
push edx
; start for
mov eax, dword 0
mov [ebp - 12], eax
push dword 0
.doubleArray0:
pop edx
inc edx
pop eax
mov ecx, [eax]
push eax
push edx
dec edx
cmp edx, ecx
jge .doubleArray1
inc edx
mov ecx, [eax + 4 * edx]
mov [ebp - 12], ecx
lea eax, [ebp - 8]
push eax
pop eax
mov edx, [eax]
push edx
pop edx
inc edx
mov eax, [ebp - 4]
lea ecx, [eax + 4 * edx]
push ecx
push dword 2
lea eax, [ebp - 12]
push eax
pop eax
mov edx, [eax]
push edx
pop ecx
pop eax
imul eax, ecx
push eax
pop eax
pop edx
mov [edx], eax
lea eax, [ebp - 8]
push eax
pop eax
mov edx, [eax]
inc edx
mov [eax], edx
jmp .doubleArray0
.doubleArray1:
pop ecx
pop ecx
lea eax, [ebp - 4]
push eax
pop eax
mov edx, [eax]
push edx
pop eax
leave
ret
leave
ret
shiftLeft:
push ebp
mov ebp, esp
sub esp, 8
push dword 0
pop edx
inc edx
mov eax, [ebp + 8]
lea ecx, [eax + 4 * edx]
push ecx
pop eax
mov edx, [eax]
push edx
pop eax
mov [ebp - 4], eax
push dword 0
pop eax
mov [ebp - 8], eax
.shiftLeft0:
lea eax, [ebp - 8]
push eax
pop eax
mov edx, [eax]
push edx
lea eax, [ebp + 8]
push eax
pop ecx
mov edx, [ecx]
push edx
pop eax
mov edx, [eax]
push edx
push dword 1
pop ecx
pop eax
sub eax, ecx
push eax
pop edx
pop eax
cmp eax, edx
jl .shiftLeft1
push dword 0
jmp .shiftLeft2
.shiftLeft1:
push dword 1
.shiftLeft2:
pop eax
mov edx, dword 0
cmp edx, eax
je .shiftLeft3
lea eax, [ebp - 8]
push eax
pop eax
mov edx, [eax]
push edx
pop edx
inc edx
mov eax, [ebp + 8]
lea ecx, [eax + 4 * edx]
push ecx
lea eax, [ebp - 8]
push eax
pop eax
mov edx, [eax]
push edx
push dword 1
pop ecx
pop eax
add eax, ecx
push eax
pop edx
inc edx
mov eax, [ebp + 8]
lea ecx, [eax + 4 * edx]
push ecx
pop eax
mov edx, [eax]
push edx
pop eax
pop edx
mov [edx], eax
lea eax, [ebp - 8]
push eax
pop eax
mov edx, [eax]
inc edx
mov [eax], edx
jmp .shiftLeft0
.shiftLeft3:
lea eax, [ebp + 8]
push eax
pop ecx
mov edx, [ecx]
push edx
pop eax
mov edx, [eax]
push edx
push dword 1
pop ecx
pop eax
sub eax, ecx
push eax
pop edx
inc edx
mov eax, [ebp + 8]
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
leave
ret
leave
ret
scalProd:
push ebp
mov ebp, esp
sub esp, 8
push dword 0
pop eax
mov [ebp - 4], eax
push dword 0
pop eax
mov [ebp - 8], eax
.scalProd0:
lea eax, [ebp - 8]
push eax
pop eax
mov edx, [eax]
push edx
lea eax, [ebp + 8]
push eax
pop ecx
mov edx, [ecx]
push edx
pop eax
mov edx, [eax]
push edx
pop edx
pop eax
cmp eax, edx
jl .scalProd1
push dword 0
jmp .scalProd2
.scalProd1:
push dword 1
.scalProd2:
pop eax
mov edx, dword 0
cmp edx, eax
je .scalProd3
lea eax, [ebp - 4]
push eax
lea eax, [ebp - 4]
push eax
pop eax
mov edx, [eax]
push edx
lea eax, [ebp - 8]
push eax
pop eax
mov edx, [eax]
push edx
pop edx
inc edx
mov eax, [ebp + 8]
lea ecx, [eax + 4 * edx]
push ecx
pop eax
mov edx, [eax]
push edx
lea eax, [ebp - 8]
push eax
pop eax
mov edx, [eax]
push edx
pop edx
inc edx
mov eax, [ebp + 12]
lea ecx, [eax + 4 * edx]
push ecx
pop eax
mov edx, [eax]
push edx
pop ecx
pop eax
imul eax, ecx
push eax
pop ecx
pop eax
add eax, ecx
push eax
pop eax
pop edx
mov [edx], eax
lea eax, [ebp - 8]
push eax
pop eax
mov edx, [eax]
inc edx
mov [eax], edx
jmp .scalProd0
.scalProd3:
lea eax, [ebp - 4]
push eax
pop eax
mov edx, [eax]
push edx
pop eax
leave
ret
leave
ret
main:
push ebp
mov ebp, esp
sub esp, 20
push dword 5
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
mov [ebp - 4], eax
push dword 0
pop eax
mov [ebp - 8], eax
.main0:
lea eax, [ebp - 8]
push eax
pop eax
mov edx, [eax]
push edx
lea eax, [ebp - 4]
push eax
pop ecx
mov edx, [ecx]
push edx
pop eax
mov edx, [eax]
push edx
pop edx
pop eax
cmp eax, edx
jl .main1
push dword 0
jmp .main2
.main1:
push dword 1
.main2:
pop eax
mov edx, dword 0
cmp edx, eax
je .main3
lea eax, [ebp - 8]
push eax
pop eax
mov edx, [eax]
push edx
pop edx
inc edx
mov eax, [ebp - 4]
lea ecx, [eax + 4 * edx]
push ecx
lea eax, [ebp - 8]
push eax
pop eax
mov edx, [eax]
push edx
pop eax
pop edx
mov [edx], eax
lea eax, [ebp - 8]
push eax
pop eax
mov edx, [eax]
inc edx
mov [eax], edx
jmp .main0
.main3:
lea eax, [ebp - 4]
push eax
pop eax
mov edx, [eax]
push edx
call shiftLeft
add esp, 4
push eax
pop eax
lea eax, [ebp - 4]
push eax
pop eax
mov edx, [eax]
push edx
call doubleArray
add esp, 4
push eax
pop eax
mov [ebp - 12], eax
lea eax, [ebp - 4]
push eax
pop eax
mov edx, [eax]
push edx
; start for
mov eax, dword 0
mov [ebp - 16], eax
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
jmp .main4
.main5:
pop ecx
pop ecx
lea eax, [ebp - 12]
push eax
pop eax
mov edx, [eax]
push edx
; start for
mov eax, dword 0
mov [ebp - 20], eax
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
jmp .main6
.main7:
pop ecx
pop ecx
lea eax, [ebp - 12]
push eax
pop eax
mov edx, [eax]
push edx
lea eax, [ebp - 4]
push eax
pop eax
mov edx, [eax]
push edx
call scalProd
add esp, 8
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
