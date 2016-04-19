.file "file.tig"
.text
.globl L0
.type L0, @function
L0: 
pushq %rbp
movq %rsp, %rbp
subq $0, %rsp
jmp L2
L2: 
movq %rdi, %rax
movq %rcx, %r11
movq %rdx, %r10
movq %r8, %rbx
movq %rbp, %r12
subq $4, %r12
movq (%r12), %r14 
movq %rbp, %r12
movq $8, %r13 
addq %r13, %r12
movq (%r12), %r12
movq %r12, %r13 
movq %rbp, %r12
movq $12, %r15 
addq %r15, %r12
movq (%r12), %r12
addq %r11, %rax
addq %r10, %rax
addq %rbx, %rax
addq %r9, %rax
addq %r14, %rax
addq %r13, %rax
addq %r12, %rax
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
subq $4, %rsp
jmp L4
L4: 
movq %rbp, %rax
movq $0, %rbx 
addq %rbx, %rax
movq %rsi, (%rax) 
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
