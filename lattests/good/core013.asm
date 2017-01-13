global main
extern printf, malloc, strcpy, strncat, strlen, scanf, exit
section .data
msgInt: db "%d", 10, 0
msgStr: db "%s", 10, 0
msgErr: db "runtime error", 10, 0
msgReadInt: db "%d", 0
msgReadStr: db "%s", 0
str0: db "&&", 0
str1: db "||", 0
str2: db "!", 0
str3: db "true", 0
str4: db "false", 0
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
push dword 3
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
push dword 1
pop eax
neg eax
push eax
call test
add esp, 4
push eax
pop eax
mov edx, 1
xor eax, edx
push eax
push dword 1
pop edx
pop eax
cmp eax, edx
je .main0
push dword 0
call test
add esp, 4
push eax
jmp .main1
.main0:
push dword 0
.main1:
call printBool
add esp, 4
push eax
pop eax
push dword 2
pop eax
neg eax
push eax
call test
add esp, 4
push eax
pop eax
mov edx, 1
xor eax, edx
push eax
push dword 1
pop edx
pop eax
cmp eax, edx
je .main2
push dword 1
call test
add esp, 4
push eax
jmp .main3
.main2:
push dword 0
.main3:
call printBool
add esp, 4
push eax
pop eax
push dword 3
call test
add esp, 4
push eax
pop eax
mov edx, 1
xor eax, edx
push eax
push dword 1
pop edx
pop eax
cmp eax, edx
je .main4
push dword 5
pop eax
neg eax
push eax
call test
add esp, 4
push eax
jmp .main5
.main4:
push dword 0
.main5:
call printBool
add esp, 4
push eax
pop eax
push dword 234234
call test
add esp, 4
push eax
pop eax
mov edx, 1
xor eax, edx
push eax
push dword 1
pop edx
pop eax
cmp eax, edx
je .main6
push dword 21321
call test
add esp, 4
push eax
jmp .main7
.main6:
push dword 0
.main7:
call printBool
add esp, 4
push eax
pop eax
push dword 3
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
push dword 1
pop eax
neg eax
push eax
call test
add esp, 4
push eax
push dword 1
pop edx
pop eax
cmp eax, edx
je .main8
push dword 0
call test
add esp, 4
push eax
jmp .main9
.main8:
push dword 1
.main9:
call printBool
add esp, 4
push eax
pop eax
push dword 2
pop eax
neg eax
push eax
call test
add esp, 4
push eax
push dword 1
pop edx
pop eax
cmp eax, edx
je .main10
push dword 1
call test
add esp, 4
push eax
jmp .main11
.main10:
push dword 1
.main11:
call printBool
add esp, 4
push eax
pop eax
push dword 3
call test
add esp, 4
push eax
push dword 1
pop edx
pop eax
cmp eax, edx
je .main12
push dword 5
pop eax
neg eax
push eax
call test
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
push dword 234234
call test
add esp, 4
push eax
push dword 1
pop edx
pop eax
cmp eax, edx
je .main14
push dword 21321
call test
add esp, 4
push eax
jmp .main15
.main14:
push dword 1
.main15:
call printBool
add esp, 4
push eax
pop eax
push dword 2
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
push dword 1
call printBool
add esp, 4
push eax
pop eax
push dword 0
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
printBool:
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
je .printBool0
push dword 5
call malloc
add esp, 4
push eax
push str3
push eax
call strcpy
add esp, 8
call printString
add esp, 4
push eax
pop eax
jmp .printBool1
.printBool0:
push dword 6
call malloc
add esp, 4
push eax
push str4
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
test:
push ebp
mov ebp, esp
sub esp, 0
mov eax, [ebp + 8]
push eax
call printInt
add esp, 4
push eax
pop eax
mov eax, [ebp + 8]
push eax
push dword 0
pop edx
pop eax
cmp eax, edx
jg .test0
push dword 0
jmp .test1
.test0:
push dword 1
.test1:
pop eax
leave
ret
leave
ret
