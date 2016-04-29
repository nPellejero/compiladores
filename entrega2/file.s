.file "file.tig"
.text
.globl L0
.type L0, @function
L0: 
pushq %rbp
movq %rsp, %rbp
subq $40, %rsp
jmp L5
L5: 
movq %rsi, -8(%rbp)
movq $0, %rax 
cmp %rdi, %rax 
je L1 
L2: 
movq %rdi, %rax
movq %rax, 0(%rbp)
movq $1, %rax 
sub %rax, %rdi
movq (%rbp), %rsi
call L0
movq %rax, %rbx 
movq 0(%rbp), %rax
mul %rbx 
L3: 
jmp L4 
L1: 
movq $1, %rax 
jmp L3 
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
movq $10, %rdi 
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
