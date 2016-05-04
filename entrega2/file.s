.file "file.tig"
.text
.globl L0
.type L0, @function
L0:
	.long 4
	.string "Hola"
.globl L2
.type L2, @function
L2: 
pushq %rbp
movq %rsp, %rbp
subq $24, %rsp
jmp L4
L4: 
movq %rsi, -8(%rbp)
movq $-0, %rax 
movq $8, %rbx 
mul %rbx 
addq %rax, %rdi
movq (%rdi), %rax
movq -8(%rbp), %rbx
movq -16(%rbx), %rbx
addq %rbx, %rax
jmp L3 
L3: 
leave
ret
.size L2, .-L2
.globl L1
.type L1, @function
L1: 
pushq %rbp
movq %rsp, %rbp
subq $24, %rsp
jmp L6
L6: 
movq %rsi, -8(%rbp)
movq %rdi, -16(%rbp)
movq -8(%rbp), %rax
movq -24(%rax), %rdi
movq %rbp, %rsi
call L2
movq -16(%rbp), %rbx
addq %rbx, %rax
jmp L5 
L5: 
leave
ret
.size L1, .-L1
.globl _tigermain
.type _tigermain, @function
_tigermain: 
pushq %rbp
movq %rsp, %rbp
subq $40, %rsp
jmp L8
L8: 
movq %rsi, -8(%rbp)
movq %rbp, %rax
movq $-24, %rbx 
addq %rbx, %rax
movq %rax, -8(%rbp)
movq $L0, %rcx
movq $10, %rdi 
movq $2, %rsi 
call _allocRecord
movq -8(%rbp), %rbx
movq %rax, (%rbx) 
movq %rbx, -8(%rbp)
movq $342, %rdi 
movq %rbp, %rsi
call L1
movq $0, %rax 
jmp L7 
L7: 
leave
ret
.size _tigermain, .-_tigermain
.ident "GCC: (DEBIAN 4.9.2-10) 4.9.2"
.section .note.GNU-stack,"",@progbits
