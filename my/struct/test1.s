global main
extern printf, malloc, strcpy, strncat, strlen, scanf, exit, memset
section .data
msgInt: db "%d", 10, 0
msgStr: db "%s", 10, 0
msgErr: db "runtime error", 10, 0
msgReadInt: db "%d", 0
msgReadStr: db "%s", 0
emptyStr: db "", 0
str0: db "fail", 0
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
assert:
push ebp
mov ebp, esp
sub esp, 0
lea eax, [ebp + 8]
push eax
pop eax
mov edx, [eax]
push edx
pop eax
mov edx, 1
xor eax, edx
push eax
push dword 1
pop edx
pop eax
cmp eax, edx
je .assert0
jmp .assert1
.assert0:
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
.assert1:
leave
ret
main:
push ebp
mov ebp, esp
sub esp, 8
mov eax, dword 0
mov [ebp - 4], eax
mov eax, dword 0
mov [ebp - 8], eax
lea eax, [ebp - 4]
push eax
pop eax
mov edx, [eax]
push edx
lea eax, [ebp - 4]
push eax
pop eax
mov edx, [eax]
push edx
pop edx
pop eax
cmp eax, edx
je .main0
push dword 0
jmp .main1
.main0:
push dword 1
.main1:
call assert
add esp, 4
push eax
pop eax
lea eax, [ebp - 4]
push eax
pop eax
mov edx, [eax]
push edx
push dword 0
pop edx
pop eax
cmp eax, edx
je .main2
push dword 0
jmp .main3
.main2:
push dword 1
.main3:
call assert
add esp, 4
push eax
pop eax
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
pop eax
cmp eax, edx
je .main4
push dword 0
jmp .main5
.main4:
push dword 1
.main5:
call assert
add esp, 4
push eax
pop eax
lea eax, [ebp - 4]
push eax
push dword 0
pop eax
pop edx
mov [edx], eax
lea eax, [ebp - 4]
push eax
pop eax
mov edx, [eax]
push edx
lea eax, [ebp - 4]
push eax
pop eax
mov edx, [eax]
push edx
pop edx
pop eax
cmp eax, edx
je .main6
push dword 0
jmp .main7
.main6:
push dword 1
.main7:
call assert
add esp, 4
push eax
pop eax
lea eax, [ebp - 4]
push eax
pop eax
mov edx, [eax]
push edx
push dword 0
pop edx
pop eax
cmp eax, edx
je .main8
push dword 0
jmp .main9
.main8:
push dword 1
.main9:
call assert
add esp, 4
push eax
pop eax
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
pop eax
cmp eax, edx
je .main10
push dword 0
jmp .main11
.main10:
push dword 1
.main11:
call assert
add esp, 4
push eax
pop eax
lea eax, [ebp - 4]
push eax
mov eax, 0
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
pop eax
mov edx, [eax]
push edx
lea eax, [ebp - 4]
push eax
pop eax
mov edx, [eax]
push edx
pop edx
pop eax
cmp eax, edx
je .main12
push dword 0
jmp .main13
.main12:
push dword 1
.main13:
call assert
add esp, 4
push eax
pop eax
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
pop eax
cmp eax, edx
jne .main14
push dword 0
jmp .main15
.main14:
push dword 1
.main15:
call assert
add esp, 4
push eax
pop eax
lea eax, [ebp - 8]
push eax
mov eax, 0
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
pop eax
mov edx, [eax]
push edx
lea eax, [ebp - 8]
push eax
pop eax
mov edx, [eax]
push edx
pop edx
pop eax
cmp eax, edx
jne .main16
push dword 0
jmp .main17
.main16:
push dword 1
.main17:
call assert
add esp, 4
push eax
pop eax
lea eax, [ebp - 4]
push eax
push dword 0
pop eax
pop edx
mov [edx], eax
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
pop eax
cmp eax, edx
jne .main18
push dword 0
jmp .main19
.main18:
push dword 1
.main19:
call assert
add esp, 4
push eax
pop eax
lea eax, [ebp - 8]
push eax
push dword 0
pop eax
pop edx
mov [edx], eax
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
pop eax
cmp eax, edx
je .main20
push dword 0
jmp .main21
.main20:
push dword 1
.main21:
call assert
add esp, 4
push eax
pop eax
push dword 0
pop eax
leave
ret
leave
ret
