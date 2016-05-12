.file "file.tig"
.text
.globl L3
.type L3, @function
L3: 
pushq %rbp
movq %rsp, %rbp
subq $40, %rsp
jmp L5
L5: 
movq %rdi, -8(%rbp)
movq %rsi, %rax
movq -8(%rbp), %rbx
movq -16(%rbx), %rbx
addq %rbx, %rax
movq -8(%rbp), %rbx
movq -8(%rbx), %rbx
movq -16(%rbx), %rbx
addq %rbx, %rax
movq -8(%rbp), %rbx
movq -8(%rbx), %rbx
movq -8(%rbx), %rbx
movq -16(%rbx), %rbx
addq %rbx, %rax
movq -8(%rbp), %rbx
movq -8(%rbx), %rbx
movq -8(%rbx), %rbx
movq -8(%rbx), %rbx
addq %rbx, %rax
movq %rax, -24(%rbp)
movq -8(%rbp), %rax
movq -8(%rax), %rax
movq -16(%rax), %rsi
movq $1, %rax 
sub %rax, %rsi
movq -8(%rbp), %rax
movq -8(%rax), %rax
movq -8(%rax), %rdi
call L1
movq %rax, %rbx 
movq -24(%rbp), %rax
addq %rbx, %rax
jmp L4 
L4: 
leave
ret
.size L3, .-L3
.globl L2
.type L2, @function
L2: 
pushq %rbp
movq %rsp, %rbp
subq $24, %rsp
jmp L7
L7: 
movq %rdi, -8(%rbp)
movq %rsi, -16(%rbp)
movq -16(%rbp), %rsi
movq $8, %rax 
addq %rax, %rsi
movq %rbp, %rdi
call L3
movq %rax, %rbx 
movq $2, %rax 
mul %rbx 
jmp L6 
L6: 
leave
ret
.size L2, .-L2
.globl L1
.type L1, @function
L1: 
pushq %rbp
movq %rsp, %rbp
subq $24, %rsp
jmp L9
L9: 
movq %rdi, -8(%rbp)
movq %rsi, -16(%rbp)
movq -16(%rbp), %rax
movq $2, %rbx 
mul %rbx 
movq %rax, %rsi
movq %rbp, %rdi
call L2
jmp L8 
L8: 
leave
ret
.size L1, .-L1
.globl L0
.type L0, @function
L0: 
pushq %rbp
movq %rsp, %rbp
subq $24, %rsp
jmp L11
L11: 
movq %rdi, -8(%rbp)
movq %rsi, -16(%rbp)
movq %rdx, -8(%rbp)
movq -16(%rbp), %rsi
movq -8(%rbp), %rax
addq %rax, %rsi
movq %rbp, %rdi
call L1
jmp L10 
L10: 
leave
ret
.size L0, .-L0
.globl _tigermain
.type _tigermain, @function
_tigermain: 
pushq %rbp
movq %rsp, %rbp
subq $24, %rsp
jmp L13
L13: 
movq %rdi, -8(%rbp)
movq $5, %rdx 
movq $9, %rsi 
movq %rbp, %rdi
call L0
movq $0, %rax 
jmp L12 
L12: 
leave
ret
.size _tigermain, .-_tigermain
.ident "GCC: (DEBIAN 4.9.2-10) 4.9.2"
.section .note.GNU-stack,"",@progbits
