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
inc:
push ebp
mov ebp, esp
sub esp, 0
lea eax, [ebp + 8]
push eax
pop eax
mov edx, [eax]
inc edx
mov [eax], edx
lea eax, [ebp + 8]
push eax
pop eax
mov edx, [eax]
push edx
pop eax
leave
ret
leave
ret
dec:
push ebp
mov ebp, esp
sub esp, 0
lea eax, [ebp + 8]
push eax
pop eax
mov edx, [eax]
dec edx
mov [eax], edx
lea eax, [ebp + 8]
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
sub esp, 4
push dword 3
call inc
add esp, 4
push eax
pop eax
mov [ebp - 4], eax
push dword 3
call inc
add esp, 4
push eax
call printInt
add esp, 4
push eax
pop eax
lea eax, [ebp - 4]
push eax
pop eax
mov edx, [eax]
push edx
call printInt
add esp, 4
push eax
pop eax
lea eax, [ebp - 4]
push eax
pop eax
mov edx, [eax]
push edx
call inc
add esp, 4
push eax
call printInt
add esp, 4
push eax
pop eax
lea eax, [ebp - 4]
push eax
pop eax
mov edx, [eax]
push edx
call dec
add esp, 4
push eax
call printInt
add esp, 4
push eax
pop eax
lea eax, [ebp - 4]
push eax
push dword 6
call dec
add esp, 4
push eax
pop eax
pop edx
mov [edx], eax
lea eax, [ebp - 4]
push eax
pop eax
mov edx, [eax]
push edx
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
