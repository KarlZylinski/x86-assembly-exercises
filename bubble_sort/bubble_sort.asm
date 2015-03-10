global _main
extern _printf
extern _ExitProcess@4


;;;;;;;;;;;;
; CODE
;;;;;;;;;;;;

section .text

; number to print in eax
print_number:
push ebp
mov ebp, esp
push eax
push number_format
call _printf
mov esp, ebp
pop ebp
ret

print_all_numbers:
push ebp
mov ebp, esp
push eax
push ebx
mov ebx, 0
.loop:
mov eax, [numbers + ebx * 4]
call print_number
inc ebx
cmp ebx, [num_numbers]
jl .loop
pop ebx
pop eax
mov esp, ebp
pop ebp
ret

sort:
push ebp
mov ebp, esp
push eax
push ebx
push ecx
push edx
.start:
mov ecx, 0
.loop:
mov eax, ecx
inc eax
cmp eax, [num_numbers]
jge .continue ; avoids comparing with number outside of numbers
mov eax, [numbers + ecx * 4]
mov ebx, [numbers + (ecx + 1) * 4]
cmp eax, ebx
jle .continue
mov [numbers + (ecx + 1) * 4], eax
mov [numbers + ecx * 4], ebx
jmp .start
.continue:
inc ecx
cmp ecx, [num_numbers]
jl .loop
.end:
pop edx
pop ecx
pop ebx
pop eax
mov esp, ebp
pop ebp
ret

_main:
call sort
call print_all_numbers
push 0
call _ExitProcess@4


;;;;;;;;;;;;
; DATA
;;;;;;;;;;;;

section .data
num_numbers: dd 14
numbers: dd 5,2,3,12,-1,225,1,231,255,294,15511,125,515115,-13343
number_format: db "%i", 10, 0
