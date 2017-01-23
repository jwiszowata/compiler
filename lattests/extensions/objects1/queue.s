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
f:
push ebp
mov ebp, esp
sub esp, 0
push ebx
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
pop ecx
pop eax
imul eax, ecx
push eax
push dword 3
pop ecx
pop eax
add eax, ecx
push eax
pop eax
pop ebx
leave
ret
pop ebx
leave
ret
main:
push ebp
mov ebp, esp
sub esp, 4
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
push eax
pop eax
mov [ebp - 4], eax
lea eax, [ebp - 4]
push eax
pop ebx
mov ebx, [ebx]
push dword 3
call f
add esp, 4
push eax
push ebx
call IntQueue.insert
add esp, 8
push eax
pop eax
lea eax, [ebp - 4]
push eax
pop ebx
mov ebx, [ebx]
push dword 5
push ebx
call IntQueue.insert
add esp, 8
push eax
pop eax
lea eax, [ebp - 4]
push eax
pop ebx
mov ebx, [ebx]
push dword 7
push ebx
call IntQueue.insert
add esp, 8
push eax
pop eax
lea eax, [ebp - 4]
push eax
pop ebx
mov ebx, [ebx]
push ebx
call IntQueue.first
add esp, 4
push eax
call printInt
add esp, 4
push eax
pop eax
lea eax, [ebp - 4]
push eax
pop ebx
mov ebx, [ebx]
push ebx
call IntQueue.rmFirst
add esp, 4
push eax
pop eax
lea eax, [ebp - 4]
push eax
pop ebx
mov ebx, [ebx]
push ebx
call IntQueue.size
add esp, 4
push eax
call printInt
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
IntQueue.size:
push ebp
mov ebp, esp
sub esp, 8
push ebx
lea eax, [ebp + 8]
mov ecx, [eax]
lea eax, [ecx]
push eax
pop eax
mov edx, [eax]
push edx
pop eax
mov [ebp - 4], eax
push dword 0
pop eax
mov [ebp - 8], eax
.IntQueue.size0:
lea eax, [ebp - 4]
push eax
pop eax
mov edx, [eax]
push edx
push dword 0
pop edx
pop eax
cmp eax, edx
jne .IntQueue.size1
push dword 0
jmp .IntQueue.size2
.IntQueue.size1:
push dword 1
.IntQueue.size2:
pop eax
mov edx, dword 0
cmp edx, eax
je .IntQueue.size3
lea eax, [ebp - 4]
push eax
lea eax, [ebp - 4]
push eax
pop ebx
mov ebx, [ebx]
push ebx
call Node.getNext
add esp, 4
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
jmp .IntQueue.size0
.IntQueue.size3:
lea eax, [ebp - 8]
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
IntQueue.rmFirst:
push ebp
mov ebp, esp
sub esp, 0
push ebx
lea eax, [ebp + 8]
mov ecx, [eax]
lea eax, [ecx]
push eax
lea eax, [ebp + 8]
mov ecx, [eax]
lea eax, [ecx]
push eax
pop ebx
mov ebx, [ebx]
push ebx
call Node.getNext
add esp, 4
push eax
pop eax
pop edx
mov [edx], eax
pop ebx
leave
ret
IntQueue.first:
push ebp
mov ebp, esp
sub esp, 0
push ebx
lea eax, [ebp + 8]
mov ecx, [eax]
lea eax, [ecx]
push eax
pop ebx
mov ebx, [ebx]
push ebx
call Node.getElem
add esp, 4
push eax
pop eax
pop ebx
leave
ret
pop ebx
leave
ret
IntQueue.insert:
push ebp
mov ebp, esp
sub esp, 4
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
push eax
pop eax
mov [ebp - 4], eax
lea eax, [ebp - 4]
push eax
pop ebx
mov ebx, [ebx]
lea eax, [ebp + 12]
push eax
pop eax
mov edx, [eax]
push edx
push ebx
call Node.setElem
add esp, 8
push eax
pop eax
lea eax, [ebp + 8]
push eax
pop ebx
mov ebx, [ebx]
push ebx
call IntQueue.isEmpty
add esp, 4
push eax
push dword 1
pop edx
pop eax
cmp eax, edx
je .IntQueue.insert0
lea eax, [ebp + 8]
mov ecx, [eax]
lea eax, [ecx + 1]
push eax
pop ebx
mov ebx, [ebx]
lea eax, [ebp - 4]
push eax
pop eax
mov edx, [eax]
push edx
push ebx
call Node.setNext
add esp, 8
push eax
pop eax
jmp .IntQueue.insert1
.IntQueue.insert0:
lea eax, [ebp + 8]
mov ecx, [eax]
lea eax, [ecx]
push eax
lea eax, [ebp - 4]
push eax
pop eax
mov edx, [eax]
push edx
pop eax
pop edx
mov [edx], eax
.IntQueue.insert1:
lea eax, [ebp + 8]
mov ecx, [eax]
lea eax, [ecx + 1]
push eax
lea eax, [ebp - 4]
push eax
pop eax
mov edx, [eax]
push edx
pop eax
pop edx
mov [edx], eax
pop ebx
leave
ret
IntQueue.isEmpty:
push ebp
mov ebp, esp
sub esp, 0
push ebx
lea eax, [ebp + 8]
mov ecx, [eax]
lea eax, [ecx]
push eax
pop eax
mov edx, [eax]
push edx
push dword 0
pop edx
pop eax
cmp eax, edx
je .IntQueue.isEmpty0
push dword 0
jmp .IntQueue.isEmpty1
.IntQueue.isEmpty0:
push dword 1
.IntQueue.isEmpty1:
pop eax
pop ebx
leave
ret
pop ebx
leave
ret
Node.getNext:
push ebp
mov ebp, esp
sub esp, 0
push ebx
lea eax, [ebp + 8]
mov ecx, [eax]
lea eax, [ecx + 1]
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
Node.getElem:
push ebp
mov ebp, esp
sub esp, 0
push ebx
lea eax, [ebp + 8]
mov ecx, [eax]
lea eax, [ecx]
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
Node.setNext:
push ebp
mov ebp, esp
sub esp, 0
push ebx
lea eax, [ebp + 8]
mov ecx, [eax]
lea eax, [ecx + 1]
push eax
lea eax, [ebp + 12]
push eax
pop eax
mov edx, [eax]
push edx
pop eax
pop edx
mov [edx], eax
pop ebx
leave
ret
Node.setElem:
push ebp
mov ebp, esp
sub esp, 0
push ebx
lea eax, [ebp + 8]
mov ecx, [eax]
lea eax, [ecx]
push eax
lea eax, [ebp + 12]
push eax
pop eax
mov edx, [eax]
push edx
pop eax
pop edx
mov [edx], eax
pop ebx
leave
ret
