    section .data
section .text
    global _start
_start:
    mov eax, 42
    add eax, 8
    mov ebx, eax
    mov eax, 1
    xor ecx, e