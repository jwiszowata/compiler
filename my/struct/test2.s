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
createA:
push ebp
mov ebp, esp
sub esp, 4
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
pop eax
mov edx, [eax]
push edx
pop eax
leave
ret
leave
ret
createB:
push ebp
mov ebp, esp
sub esp, 4
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
pop eax
mov edx, [eax]
push edx
pop eax
leave
ret
leave
ret
createPair:
push ebp
mov ebp, esp
sub esp, 4
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
pop ecx
mov edx, [ecx]
mov eax, dword 0
lea ecx, [edx + 4 * eax]
push ecx
call createA
add esp, 0
push eax
pop eax
pop edx
mov [edx], eax
lea eax, [ebp - 4]
push eax
pop ecx
mov edx, [ecx]
mov eax, dword 1
lea ecx, [edx + 4 * eax]
push ecx
call createB
add esp, 0
push eax
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
pop ecx
mov edx, [ecx]
mov eax, dword 0
lea ecx, [edx + 4 * eax]
push ecx
lea eax, [ebp - 4]
push eax
pop ecx
mov edx, [ecx]
mov eax, dword 1
lea ecx, [edx + 4 * eax]
push ecx
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
mov eax, dword 1
lea ecx, [edx + 4 * eax]
push ecx
pop ecx
mov edx, [ecx]
mov eax, dword 0
lea ecx, [edx + 4 * eax]
push ecx
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
pop eax
pop edx
mov [edx], eax
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
mov eax, dword 0
mov [ebp - 4], eax
lea eax, [ebp - 4]
push eax
pop eax
mov edx, [eax]
push edx
push dword 0
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
call createPair
add esp, 0
push eax
pop eax
pop edx
mov [edx], eax
lea eax, [ebp - 4]
push eax
pop eax
mov edx, [eax]
push edx
push dword 0
pop edx
pop eax
cmp eax, edx
jne .main2
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
lea eax, [ebp - 4]
push eax
pop ecx
mov edx, [ecx]
mov eax, dword 1
lea ecx, [edx + 4 * eax]
push ecx
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
pop ecx
mov edx, [ecx]
mov eax, dword 1
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
lea eax, [ebp - 4]
push eax
pop ecx
mov edx, [ecx]
mov eax, dword 1
lea ecx, [edx + 4 * eax]
push ecx
pop eax
mov edx, [eax]
push edx
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
lea eax, [ebp - 4]
push eax
pop ecx
mov edx, [ecx]
mov eax, dword 1
lea ecx, [edx + 4 * eax]
push ecx
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
pop ecx
mov edx, [ecx]
mov eax, dword 0
lea ecx, [edx + 4 * eax]
push ecx
pop eax
mov edx, [eax]
push edx
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
pop ecx
mov edx, [ecx]
mov eax, dword 0
lea ecx, [edx + 4 * eax]
push ecx
pop eax
mov edx, [eax]
push edx
pop eax
mov [ebp - 8], eax
mov eax, dword 0
mov [ebp - 12], eax
lea eax, [ebp - 4]
push eax
pop ecx
mov edx, [ecx]
mov eax, dword 1
lea ecx, [edx + 4 * eax]
push ecx
pop eax
mov edx, [eax]
push edx
pop eax
mov [ebp - 16], eax
mov eax, dword 0
mov [ebp - 20], eax
lea eax, [ebp - 8]
push eax
pop ecx
mov edx, [ecx]
mov eax, dword 0
lea ecx, [edx + 4 * eax]
push ecx
pop eax
mov edx, [eax]
push edx
lea eax, [ebp - 16]
push eax
pop eax
mov edx, [eax]
push edx
pop edx
pop eax
cmp eax, edx
je .main14
push dword 0
jmp .main15
.main14:
push dword 1
.main15:
call assert
add esp, 4
push eax
pop eax
lea eax, [ebp - 16]
push eax
pop ecx
mov edx, [ecx]
mov eax, dword 0
lea ecx, [edx + 4 * eax]
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
pop eax
cmp eax, edx
je .main16
push dword 0
jmp .main17
.main16:
push dword 1
.main17:
call assert
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
pop eax
mov edx, [eax]
push edx
lea eax, [ebp - 16]
push eax
pop eax
mov edx, [eax]
push edx
pop edx
pop eax
cmp eax, edx
je .main18
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
pop ecx
mov edx, [ecx]
mov eax, dword 0
lea ecx, [edx + 4 * eax]
push ecx
pop eax
mov edx, [eax]
push edx
lea eax, [ebp - 16]
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
lea eax, [ebp - 8]
push eax
pop eax
mov edx, [eax]
push edx
pop edx
pop eax
cmp eax, edx
je .main22
push dword 0
jmp .main23
.main22:
push dword 1
.main23:
call assert
add esp, 4
push eax
pop eax
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
lea eax, [ebp - 8]
push eax
pop eax
mov edx, [eax]
push edx
pop edx
pop eax
cmp eax, edx
je .main24
push dword 0
jmp .main25
.main24:
push dword 1
.main25:
call assert
add esp, 4
push eax
pop eax
lea eax, [ebp - 8]
push eax
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
lea eax, [ebp - 8]
push eax
pop eax
mov edx, [eax]
push edx
pop edx
pop eax
cmp eax, edx
jne .main26
push dword 0
jmp .main27
.main26:
push dword 1
.main27:
call assert
add esp, 4
push eax
pop eax
lea eax, [ebp - 12]
push eax
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
pop eax
pop edx
mov [edx], eax
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
lea eax, [ebp - 12]
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
mov eax, dword 0
lea ecx, [edx + 4 * eax]
push ecx
pop eax
mov edx, [eax]
push edx
lea eax, [ebp - 16]
push eax
pop eax
mov edx, [eax]
push edx
pop edx
pop eax
cmp eax, edx
je .main28
push dword 0
jmp .main29
.main28:
push dword 1
.main29:
call assert
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
lea eax, [ebp - 8]
push eax
pop eax
mov edx, [eax]
push edx
pop edx
pop eax
cmp eax, edx
jne .main30
push dword 0
jmp .main31
.main30:
push dword 1
.main31:
call assert
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
lea eax, [ebp - 12]
push eax
pop eax
mov edx, [eax]
push edx
pop edx
pop eax
cmp eax, edx
je .main32
push dword 0
jmp .main33
.main32:
push dword 1
.main33:
call assert
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
pop ecx
mov edx, [ecx]
mov eax, dword 0
lea ecx, [edx + 4 * eax]
push ecx
pop eax
mov edx, [eax]
push edx
push dword 0
pop edx
pop eax
cmp eax, edx
je .main34
push dword 0
jmp .main35
.main34:
push dword 1
.main35:
call assert
add esp, 4
push eax
pop eax
lea eax, [ebp - 16]
push eax
pop ecx
mov edx, [ecx]
mov eax, dword 0
lea ecx, [edx + 4 * eax]
push ecx
pop eax
mov edx, [eax]
push edx
lea eax, [ebp - 12]
push eax
pop eax
mov edx, [eax]
push edx
pop edx
pop eax
cmp eax, edx
je .main36
push dword 0
jmp .main37
.main36:
push dword 1
.main37:
call assert
add esp, 4
push eax
pop eax
lea eax, [ebp - 16]
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
push dword 0
pop edx
pop eax
cmp eax, edx
je .main38
push dword 0
jmp .main39
.main38:
push dword 1
.main39:
call assert
add esp, 4
push eax
pop eax
lea eax, [ebp - 12]
push eax
pop ecx
mov edx, [ecx]
mov eax, dword 0
lea ecx, [edx + 4 * eax]
push ecx
pop eax
mov edx, [eax]
push edx
push dword 0
pop edx
pop eax
cmp eax, edx
je .main40
push dword 0
jmp .main41
.main40:
push dword 1
.main41:
call assert
add esp, 4
push eax
pop eax
lea eax, [ebp - 20]
push eax
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
pop edx
mov [edx], eax
lea eax, [ebp - 20]
push eax
pop ecx
mov edx, [ecx]
mov eax, dword 0
lea ecx, [edx + 4 * eax]
push ecx
lea eax, [ebp - 8]
push eax
pop eax
mov edx, [eax]
push edx
pop eax
pop edx
mov [edx], eax
lea eax, [ebp - 12]
push eax
pop ecx
mov edx, [ecx]
mov eax, dword 0
lea ecx, [edx + 4 * eax]
push ecx
lea eax, [ebp - 20]
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
mov eax, dword 0
lea ecx, [edx + 4 * eax]
push ecx
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
pop ecx
mov edx, [ecx]
mov eax, dword 0
lea ecx, [edx + 4 * eax]
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
pop eax
cmp eax, edx
je .main42
push dword 0
jmp .main43
.main42:
push dword 1
.main43:
call assert
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
lea eax, [ebp - 8]
push eax
pop eax
mov edx, [eax]
push edx
pop edx
pop eax
cmp eax, edx
jne .main44
push dword 0
jmp .main45
.main44:
push dword 1
.main45:
call assert
add esp, 4
push eax
pop eax
lea eax, [ebp - 16]
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
lea eax, [ebp - 16]
push eax
pop eax
mov edx, [eax]
push edx
pop edx
pop eax
cmp eax, edx
je .main46
push dword 0
jmp .main47
.main46:
push dword 1
.main47:
call assert
add esp, 4
push eax
pop eax
lea eax, [ebp - 16]
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
lea eax, [ebp - 16]
push eax
pop eax
mov edx, [eax]
push edx
pop edx
pop eax
cmp eax, edx
jne .main48
push dword 0
jmp .main49
.main48:
push dword 1
.main49:
call assert
add esp, 4
push eax
pop eax
lea eax, [ebp - 12]
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
lea eax, [ebp - 12]
push eax
pop eax
mov edx, [eax]
push edx
pop edx
pop eax
cmp eax, edx
je .main50
push dword 0
jmp .main51
.main50:
push dword 1
.main51:
call assert
add esp, 4
push eax
pop eax
lea eax, [ebp - 12]
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
lea eax, [ebp - 12]
push eax
pop eax
mov edx, [eax]
push edx
pop edx
pop eax
cmp eax, edx
jne .main52
push dword 0
jmp .main53
.main52:
push dword 1
.main53:
call assert
add esp, 4
push eax
pop eax
lea eax, [ebp - 20]
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
lea eax, [ebp - 20]
push eax
pop eax
mov edx, [eax]
push edx
pop edx
pop eax
cmp eax, edx
je .main54
push dword 0
jmp .main55
.main54:
push dword 1
.main55:
call assert
add esp, 4
push eax
pop eax
lea eax, [ebp - 20]
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
lea eax, [ebp - 20]
push eax
pop eax
mov edx, [eax]
push edx
pop edx
pop eax
cmp eax, edx
jne .main56
push dword 0
jmp .main57
.main56:
push dword 1
.main57:
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
