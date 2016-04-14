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
movq %rcx, %r12
movq %rdx, %r11
movq %r8, %r10
popq %r13
popq %r12
popq %r11
movq %rbp, %rbx
movq $4, %r13 
subq %r13, %rbx
movq (%rbx), %rbx
movq %rbx, %r14 
movq %rbp, %rbx
movq $8, %r13 
addq %r13, %rbx
movq (%rbx), %rbx
movq %rbx, %r13 
movq $12, %rbx 
addq %rbx, %rbp
movq (%rbp), %rbx
addq %r12, %rax
addq %r11, %rax
addq %r10, %rax
addq %r9, %rax
addq %r14, %rax
addq %r13, %rax
addq %rbx, %rax
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
subq $0, %rsp
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
