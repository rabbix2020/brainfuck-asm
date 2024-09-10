section .bss
file_stat resb 144
array resb 30000

section .rdata
prompt db 10,">>> ", 0
file_error db "bf: unable to open file", 10, 0

section .text

; rax - instruction pointer
; r8 - array pointer
; r10 - pointer to code

global _start

_start:

pop rax
cmp rax, 2
je _fileread

push rax
mov rax, prompt
call _print_text
pop rax

pop rax

push rax
mov rax, 12
mov rdi, 0
syscall

add rax, 30001
mov rdi, rax
mov rax, 12
syscall

mov r10, rax
pop rax

push rax
mov rax, 0
mov rdi, 0
mov rsi, r10
mov rdx, 30000
syscall
pop rax

cmp rax, 2
jne _skip_fileread

_fileread:
mov rax, 2
pop rdi
pop rdi
mov rsi, 0
mov rdx, 0
syscall

push rax
mov rax, 4
mov rsi, file_stat
syscall

cmp rax, 0
jne _file_error

pop rax

push rax
mov rax, 12
mov rdi, 0
syscall

add rax, qword [file_stat+48]
mov rdi, rax
mov rax, 12
syscall

mov r10, rax
pop rax

push rax
mov rdi, rax
mov rax, 0
mov rsi, r10
mov rdx, qword [file_stat+48]
inc rdx
syscall

mov rax, 3
pop rdi
syscall

_skip_fileread:

mov rax, -1
_loop:
inc rax

cmp byte [r10+rax], '>'
je _left

cmp byte [r10+rax], '<'
je _right

cmp byte [r10+rax], '+'
je _add

cmp byte [r10+rax], '-'
je _sub

cmp byte [r10+rax], '.'
je _print

cmp byte [r10+rax], ','
je _getch

cmp byte [r10+rax], '['
je _while

cmp byte [r10+rax], ']'
je _endwhile

cmp byte [r10+rax], 0
jne _loop

jmp _exit

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
inc r9
cmp byte [array+r8], 0
je _skip_while
push rax
jmp _loop

_skip_while:
inc rax

cmp byte [r10+rax], '['
je _r9_add

cmp byte [r10+rax], ']'
je _r9_sub

cmp r9, 0
jne _skip_while
jmp _loop

_r9_sub:
dec r9
jmp _skip_while

_r9_add:
inc r9
jmp _skip_while

_endwhile:
cmp byte [array+r8], 0
je _loop
pop rax
dec rax
jmp _loop

_print_text:

mov rbx, -1

_print_text_loop:
inc rbx
cmp byte [rax+rbx], 0
jne _print_text_loop

push rax
mov rax, 1
mov rdi, 1
pop rsi
mov rdx, rbx
syscall

ret

_exit:
mov rax, 60
mov rdi, 1
syscall

_file_error:
mov rax, file_error
call _print_text
jmp _exit
