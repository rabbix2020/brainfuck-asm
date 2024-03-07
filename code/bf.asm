section .bss
code resb 30000
array resb 30000

section .data
prompt db ">>> "

section .text

; rax - instruction pointer
; r8 - array pointer

global _start

_start:
mov rax, 1
mov rdi, 1
mov rsi, prompt
mov rdx, 4
syscall

mov rax, 0
mov rdi, 0
mov rsi, code
mov rdx, 30000
syscall

mov rax, -1
_loop:
inc rax

cmp byte [code+rax], '>'
je _left

cmp byte [code+rax], '<'
je _right

cmp byte [code+rax], '+'
je _add

cmp byte [code+rax], '-'
je _sub

cmp byte [code+rax], '.'
je _print

cmp byte [code+rax], ','
je _getch

cmp byte [code+rax], '['
je _while

cmp byte [code+rax], ']'
je _endwhile

cmp byte [code+rax], 0
jne _loop

mov rax, 60
mov rdi, 0
syscall

_left:
inc r8
jmp _loop

_right:
dec r8
jmp _loop

_add:
inc byte [array+r8]
jmp _loop

_sub:
dec byte [array+r8]
jmp _loop

_print:
push rax

mov rax, 1
mov rdi, 1
mov rsi, array
add rsi, r8
mov rdx, 1
syscall

pop rax
jmp _loop

_getch:
push rax

mov rax, 0
mov rdi, 0
mov rsi, array
add rsi, r8
mov rdx, 1
syscall

pop rax
jmp _loop

_while:
push rax
jmp _loop

_endwhile:
cmp byte [array+r8], 0
je _loop
pop rax
dec rax
jmp _loop
