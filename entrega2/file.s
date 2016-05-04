.file "file.tig"
.text
.globl L1
.type L1, @function
L1: 
pushq %rbp
movq %rsp, %rbp
subq $24, %rsp
jmp L3
L3: 
movq %rsi, -8(%rbp)
movq -8(%rbp), %rax
movq -24(%rax), %rax
addq %rdi, %rax
jmp L2 
L2: 
leave
ret
.size L1, .-L1
.globl L0
.type L0, @function
L0: 
pushq %rbp
movq %rsp, %rbp
subq $48, %rsp
jmp L5
L5: 
movq %rsi, -8(%rbp)
movq %rdi, -16(%rbp)
movq $5, %rax 
movq -16(%rbp), %rbx
addq %rbx, %rax
movq %rax, -24(%rbp)
movq $10, %rdi 
movq %rbp, %rsi
call L1
movq -16(%rbp), %rbx
addq %rbx, %rax
jmp L4 
L4: 
leave
ret
.size L0, .-L0
.globl _tigermain
.type _tigermain, @function
_tigermain: 
pushq %rbp
movq %rsp, %rbp
subq $24, %rsp
jmp L7
L7: 
movq %rsi, -8(%rbp)
movq $15, %rdi 
movq %rbp, %rsi
call L0
movq $0, %rax 
jmp L6 
L6: 
leave
ret
.size _tigermain, .-_tigermain
.ident "GCC: (DEBIAN 4.9.2-10) 4.9.2"
.section .note.GNU-stack,"",@progbits
