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
push dword 0
push dword 1
call implies
add esp, 8
push eax
call printBool
add esp, 4
push dword 1
push dword 0
call implies
add esp, 8
push eax
call printBool
add esp, 4
mov eax, dword 0
.main.:
pop ebx
leave
ret
implies:
push ebp
mov ebp, esp
sub esp, 0
push ebx
lea eax, [ebp + 8]
mov edx, [eax]
push edx
call printBool
add esp, 4
lea eax, [ebp + 12]
mov edx, [eax]
push edx
call printBool
add esp, 4
lea eax, [ebp + 8]
mov edx, [eax]
mov eax, edx
mov edx, 1
xor eax, edx
push eax
call printBool
add esp, 4
lea eax, [ebp + 8]
mov edx, [eax]
push edx
lea eax, [ebp + 12]
mov edx, [eax]
pop eax
cmp eax, edx
je .implies0
push dword 0
jmp .implies1
.implies0:
push dword 1
.implies1:
call printBool
add esp, 4
lea eax, [ebp + 8]
mov edx, [eax]
mov eax, edx
mov edx, 1
xor eax, edx
push eax
mov edx, dword 1
pop eax
cmp eax, edx
je .implies2
lea eax, [ebp + 8]
mov edx, [eax]
push edx
lea eax, [ebp + 12]
mov edx, [eax]
pop eax
cmp eax, edx
je .implies4
push dword 0
jmp .implies5
.implies4:
push dword 1
.implies5:
jmp .implies3
.implies2:
push dword 1
.implies3:
call printBool
add esp, 4
lea eax, [ebp + 8]
mov edx, [eax]
mov eax, edx
mov edx, 1
xor eax, edx
push eax
mov edx, dword 1
pop eax
cmp eax, edx
je .implies6
lea eax, [ebp + 8]
mov edx, [eax]
push edx
lea eax, [ebp + 12]
mov edx, [eax]
pop eax
cmp eax, edx
je .implies8
push dword 0
jmp .implies9
.implies8:
push dword 1
.implies9:
jmp .implies7
.implies6:
push dword 1
.implies7:
pop eax
.implies.:
pop ebx
leave
ret
printBool:
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
je .printBool0
push dword 0
call printInt
add esp, 4
jmp .printBool1
.printBool0:
push dword 1
call printInt
add esp, 4
.printBool1:
.printBool.:
pop ebx
leave
ret
