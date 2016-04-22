.file "file.tig"
.text
.globl L0
.type L0, @function
L0: 
pushq %rbp
movq %rsp, %rbp
subq $24, %rsp
jmp L2
L2: 
movq %rsi, -8(%rbp)
movq 16(%rbp), %r10
movq 24(%rbp), %rbx
movq 32(%rbp), %rax
addq %rcx, %rdi
addq %rdx, %rdi
addq %r8, %rdi
addq %r9, %rdi
addq %r10, %rdi
addq %rbx, %rdi
addq %rax, %rdi
movq %rdi, %rax
movq $1, %rbx 
addq %rbx, %rax
jmp L1 
L1: 
leave
ret
.size L0, .-L0
.globl main
.type main, @function
main: 
pushq %rbp
movq %rsp, %rbp
subq $24, %rsp
jmp L4
L4: 
movq %rsi, -8(%rbp)
movq $3, %rax 
pushq %rax
movq $2, %rax 
pushq %rax
movq $1, %rax 
pushq %rax
movq $9, %r9 
movq $8, %r8 
movq $7, %rdx 
movq $6, %rcx 
movq $5, %rdi 
movq %rbp, %rsi
call L0
movq $0, %rax 
jmp L3 
L3: 
leave
ret
.size main, .-main
.ident "GCC: (DEBIAN 4.9.2-10) 4.9.2"
.section .note.GNU-stack,"",@progbits
