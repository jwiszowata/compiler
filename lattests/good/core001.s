global main
extern printf, malloc, strcpy, strncat, strlen, scanf, exit, memset
section .data
msgInt: db "%d", 10, 0
msgStr: db "%s", 10, 0
msgErr: db "runtime error", 10, 0
msgReadInt: db "%d", 0
msgReadStr: db "%s", 0
emptyStr: db "", 0
str0: db "=", 0
str1: db "hello */", 0
str2: db "/* world", 0
str3: db "", 0
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
sub esp, 12
push ebx
push dword 10
call fac
add esp, 4
push eax
call printInt
add esp, 4
push eax
pop eax
push dword 10
call rfac
add esp, 4
push eax
call printInt
add esp, 4
push eax
pop eax
push dword 10
call mfac
add esp, 4
push eax
call printInt
add esp, 4
push eax
pop eax
push dword 10
call ifac
add esp, 4
push eax
call printInt
add esp, 4
push eax
pop eax
mov eax, emptyStr
mov [ebp - 4], eax
push dword 10
pop eax
mov [ebp - 8], eax
push dword 1
pop eax
mov [ebp - 12], eax
.main0:
lea eax, [ebp - 8]
push eax
pop eax
mov edx, [eax]
push edx
push dword 0
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
lea eax, [ebp - 12]
push eax
lea eax, [ebp - 12]
push eax
pop eax
mov edx, [eax]
push edx
lea eax, [ebp - 8]
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
dec edx
mov [eax], edx
jmp .main0
.main3:
lea eax, [ebp - 12]
push eax
pop eax
mov edx, [eax]
push edx
call printInt
add esp, 4
push eax
pop eax
push dword 60
push dword 2
call malloc
add esp, 4
push eax
push str0
push eax
call strcpy
add esp, 8
call repStr
add esp, 8
push eax
call printString
add esp, 4
push eax
pop eax
push dword 9
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
push dword 9
call malloc
add esp, 4
push eax
push str2
push eax
call strcpy
add esp, 8
call printString
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
fac:
push ebp
mov ebp, esp
sub esp, 8
push ebx
mov eax, dword 0
mov [ebp - 4], eax
mov eax, dword 0
mov [ebp - 8], eax
lea eax, [ebp - 4]
push eax
push dword 1
pop eax
pop edx
mov [edx], eax
lea eax, [ebp - 8]
push eax
lea eax, [ebp + 8]
push eax
pop eax
mov edx, [eax]
push edx
pop eax
pop edx
mov [edx], eax
.fac0:
lea eax, [ebp - 8]
push eax
pop eax
mov edx, [eax]
push edx
push dword 0
pop edx
pop eax
cmp eax, edx
jg .fac1
push dword 0
jmp .fac2
.fac1:
push dword 1
.fac2:
pop eax
mov edx, dword 0
cmp edx, eax
je .fac3
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
pop ecx
pop eax
imul eax, ecx
push eax
pop eax
pop edx
mov [edx], eax
lea eax, [ebp - 8]
push eax
lea eax, [ebp - 8]
push eax
pop eax
mov edx, [eax]
push edx
push dword 1
pop ecx
pop eax
sub eax, ecx
push eax
pop eax
pop edx
mov [edx], eax
jmp .fac0
.fac3:
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
rfac:
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
je .rfac0
push dword 0
jmp .rfac1
.rfac0:
push dword 1
.rfac1:
push dword 1
pop edx
pop eax
cmp eax, edx
je .rfac2
lea eax, [ebp + 8]
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
sub eax, ecx
push eax
call rfac
add esp, 4
push eax
pop ecx
pop eax
imul eax, ecx
push eax
pop eax
pop ebx
leave
ret
jmp .rfac3
.rfac2:
push dword 1
pop eax
pop ebx
leave
ret
.rfac3:
pop ebx
leave
ret
mfac:
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
je .mfac0
push dword 0
jmp .mfac1
.mfac0:
push dword 1
.mfac1:
push dword 1
pop edx
pop eax
cmp eax, edx
je .mfac2
lea eax, [ebp + 8]
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
sub eax, ecx
push eax
call nfac
add esp, 4
push eax
pop ecx
pop eax
imul eax, ecx
push eax
pop eax
pop ebx
leave
ret
jmp .mfac3
.mfac2:
push dword 1
pop eax
pop ebx
leave
ret
.mfac3:
pop ebx
leave
ret
nfac:
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
jne .nfac0
push dword 0
jmp .nfac1
.nfac0:
push dword 1
.nfac1:
push dword 1
pop edx
pop eax
cmp eax, edx
je .nfac2
push dword 1
pop eax
pop ebx
leave
ret
jmp .nfac3
.nfac2:
lea eax, [ebp + 8]
push eax
pop eax
mov edx, [eax]
push edx
push dword 1
pop ecx
pop eax
sub eax, ecx
push eax
call mfac
add esp, 4
push eax
lea eax, [ebp + 8]
push eax
pop eax
mov edx, [eax]
push edx
pop ecx
pop eax
imul eax, ecx
push eax
pop eax
pop ebx
leave
ret
.nfac3:
pop ebx
leave
ret
ifac:
push ebp
mov ebp, esp
sub esp, 0
push ebx
lea eax, [ebp + 8]
push eax
pop eax
mov edx, [eax]
push edx
push dword 1
call ifac2f
add esp, 8
push eax
pop eax
pop ebx
leave
ret
pop ebx
leave
ret
ifac2f:
push ebp
mov ebp, esp
sub esp, 4
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
je .ifac2f0
push dword 0
jmp .ifac2f1
.ifac2f0:
push dword 1
.ifac2f1:
push dword 1
pop edx
pop eax
cmp eax, edx
je .ifac2f2
jmp .ifac2f3
.ifac2f2:
lea eax, [ebp + 8]
push eax
pop eax
mov edx, [eax]
push edx
pop eax
pop ebx
leave
ret
.ifac2f3:
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
jg .ifac2f4
push dword 0
jmp .ifac2f5
.ifac2f4:
push dword 1
.ifac2f5:
push dword 1
pop edx
pop eax
cmp eax, edx
je .ifac2f6
jmp .ifac2f7
.ifac2f6:
push dword 1
pop eax
pop ebx
leave
ret
.ifac2f7:
mov eax, dword 0
mov [ebp - 4], eax
lea eax, [ebp - 4]
push eax
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
pop ecx
pop eax
add eax, ecx
push eax
push dword 2
pop ecx
pop eax
cdq
idiv ecx
push eax
pop eax
pop edx
mov [edx], eax
lea eax, [ebp - 4]
push eax
pop eax
mov edx, [eax]
push edx
lea eax, [ebp + 8]
push eax
pop eax
mov edx, [eax]
push edx
call ifac2f
add esp, 8
push eax
lea eax, [ebp + 12]
push eax
pop eax
mov edx, [eax]
push edx
lea eax, [ebp - 4]
push eax
pop eax
mov edx, [eax]
push edx
push dword 1
pop ecx
pop eax
add eax, ecx
push eax
call ifac2f
add esp, 8
push eax
pop ecx
pop eax
imul eax, ecx
push eax
pop eax
pop ebx
leave
ret
pop ebx
leave
ret
repStr:
push ebp
mov ebp, esp
sub esp, 8
push ebx
push dword 1
call malloc
add esp, 4
push eax
push str3
push eax
call strcpy
add esp, 8
pop eax
mov [ebp - 4], eax
push dword 0
pop eax
mov [ebp - 8], eax
.repStr0:
lea eax, [ebp - 8]
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
jl .repStr1
push dword 0
jmp .repStr2
.repStr1:
push dword 1
.repStr2:
pop eax
mov edx, dword 0
cmp edx, eax
je .repStr3
lea eax, [ebp - 4]
push eax
lea eax, [ebp - 4]
push eax
pop eax
mov edx, [eax]
push edx
lea eax, [ebp + 8]
push eax
pop eax
mov edx, [eax]
push edx
pop ecx
pop eax
push eax
push ecx
push eax
call strlen
add esp, 4
pop ecx
push eax
push ecx
push ecx
call strlen
add esp, 4
pop ecx
pop edx
pop edi
push eax
push ecx
push edi
add edx, eax
inc edx
push edx
call malloc
add esp, 4
push eax
call strcpy
add esp, 8
push eax
call strncat
add esp, 12
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
jmp .repStr0
.repStr3:
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
