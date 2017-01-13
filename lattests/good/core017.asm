global main
extern printf, malloc, strcpy, strncat, strlen, scanf, exit
section .data
msgInt: db "%d", 10, 0
msgStr: db "%s", 10, 0
msgErr: db "runtime error", 10, 0
msgReadInt: db "%d", 0
msgReadStr: db "%s", 0
str0: db "apa", 0
str1: db "false", 0
str2: db "true", 0
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
push dword 4
pop eax
mov [ebp - 4], eax
push dword 3
mov eax, [ebp - 4]
push eax
pop edx
pop eax
cmp eax, edx
jle .main0
push dword 0
jmp .main1
.main0:
push dword 1
.main1:
pop eax
mov edx, 1
xor eax, edx
push eax
push dword 1
pop edx
pop eax
cmp eax, edx
je .main2
push dword 4
push dword 2
pop edx
pop eax
cmp eax, edx
jne .main4
push dword 0
jmp .main5
.main4:
push dword 1
.main5:
pop eax
mov edx, 1
xor eax, edx
push eax
push dword 1
pop edx
pop eax
cmp eax, edx
je .main6
push dword 1
jmp .main7
.main6:
push dword 0
.main7:
jmp .main3
.main2:
push dword 0
.main3:
push dword 1
pop edx
pop eax
cmp eax, edx
je .main8
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
jmp .main9
.main8:
push dword 1
call printBool
add esp, 4
push eax
pop eax
.main9:
push dword 1
push dword 1
pop edx
pop eax
cmp eax, edx
je .main10
push dword 0
jmp .main11
.main10:
push dword 1
.main11:
push dword 1
pop edx
pop eax
cmp eax, edx
je .main12
push dword 1
call dontCallMe
add esp, 4
push eax
jmp .main13
.main12:
push dword 1
.main13:
call printBool
add esp, 4
push eax
pop eax
push dword 4
push dword 5
pop eax
neg eax
push eax
pop edx
pop eax
cmp eax, edx
jl .main14
push dword 0
jmp .main15
.main14:
push dword 1
.main15:
pop eax
mov edx, 1
xor eax, edx
push eax
push dword 1
pop edx
pop eax
cmp eax, edx
je .main16
push dword 2
call dontCallMe
add esp, 4
push eax
jmp .main17
.main16:
push dword 0
.main17:
call printBool
add esp, 4
push eax
pop eax
push dword 4
mov eax, [ebp - 4]
push eax
pop edx
pop eax
cmp eax, edx
je .main18
push dword 0
jmp .main19
.main18:
push dword 1
.main19:
pop eax
mov edx, 1
xor eax, edx
push eax
push dword 1
pop edx
pop eax
cmp eax, edx
je .main20
push dword 1
push dword 0
pop eax
mov edx, 1
xor eax, edx
push eax
pop edx
pop eax
cmp eax, edx
je .main22
push dword 0
jmp .main23
.main22:
push dword 1
.main23:
pop eax
mov edx, 1
xor eax, edx
push eax
push dword 1
pop edx
pop eax
cmp eax, edx
je .main24
push dword 1
jmp .main25
.main24:
push dword 0
.main25:
jmp .main21
.main20:
push dword 0
.main21:
call printBool
add esp, 4
push eax
pop eax
push dword 0
push dword 0
call implies
add esp, 8
push eax
call printBool
add esp, 4
push eax
pop eax
push dword 1
push dword 0
call implies
add esp, 8
push eax
call printBool
add esp, 4
push eax
pop eax
push dword 0
push dword 1
call implies
add esp, 8
push eax
call printBool
add esp, 4
push eax
pop eax
push dword 1
push dword 1
call implies
add esp, 8
push eax
call printBool
add esp, 4
push eax
pop eax
push dword 0
pop eax
leave
ret
leave
ret
dontCallMe:
push ebp
mov ebp, esp
sub esp, 0
mov eax, [ebp + 8]
push eax
call printInt
add esp, 4
push eax
pop eax
push dword 1
pop eax
leave
ret
leave
ret
printBool:
push ebp
mov ebp, esp
sub esp, 0
mov eax, [ebp + 8]
push eax
push dword 1
pop edx
pop eax
cmp eax, edx
je .printBool0
push dword 6
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
jmp .printBool1
.printBool0:
push dword 5
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
.printBool1:
leave
ret
leave
ret
implies:
push ebp
mov ebp, esp
sub esp, 0
mov eax, [ebp + 8]
push eax
pop eax
mov edx, 1
xor eax, edx
push eax
push dword 1
pop edx
pop eax
cmp eax, edx
je .implies0
mov eax, [ebp + 8]
push eax
mov eax, [ebp + 12]
push eax
pop edx
pop eax
cmp eax, edx
je .implies2
push dword 0
jmp .implies3
.implies2:
push dword 1
.implies3:
jmp .implies1
.implies0:
push dword 1
.implies1:
pop eax
leave
ret
leave
ret
