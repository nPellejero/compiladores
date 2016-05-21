.file "file.tig"
.text
.section  .rodata
.L0:
	.quad 4
	.string "Hola"
	.text
.section  .rodata
.L1:
	.quad 4
	.string "Hol1"
	.text
.globl L3
.type L3, @function
L3: 
pushq %rbp
movq %rsp, %rbp
subq $24, %rsp
jmp L5
L5: 
movq %rdi, -8(%rbp)
movq $-0, %rax 
movq $8, %rbx 
mul %rbx 
addq %rax, %rsi
movq (%rsi), %rax
movq -8(%rbp), %rbx
movq -16(%rbx), %rbx
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
subq $72, %rsp
jmp L7
L7: 
movq %rdi, -8(%rbp)
movq %rsi, -16(%rbp)
movq -8(%rbp), %rax
movq -24(%rax), %rsi
movq %rbp, %rdi
call L3
movq %rax, -24(%rbp)
movq -8(%rbp), %rax
movq -32(%rax), %rsi
movq %rbp, %rdi
call L3
movq %rax, %rbx 
movq -24(%rbp), %rax
addq %rbx, %rax
movq -16(%rbp), %rbx
addq %rbx, %rax
jmp L6 
L6: 
leave
ret
.size L2, .-L2
.globl _tigermain
.type _tigermain, @function
_tigermain: 
pushq %rbp
movq %rsp, %rbp
subq $56, %rsp
jmp L9
L9: 
movq %rdi, -8(%rbp)
movq %rbp, %rax
movq $-24, %rbx 
addq %rbx, %rax
movq %rax, -32(%rbp)
movq $0, %rax 
movq $.L0, %rdx
movq $10, %rsi 
movq $2, %rdi 
call _allocRecord
movq -32(%rbp), %rbx
movq %rax, (%rbx) 
movq %rbx, -32(%rbp)
movq %rbp, %rax
movq $-32, %rbx 
addq %rbx, %rax
movq %rax, -40(%rbp)
movq $0, %rax 
movq $.L1, %rdx
movq $11, %rsi 
movq $2, %rdi 
call _allocRecord
movq -40(%rbp), %rbx
movq %rax, (%rbx) 
movq %rbx, -40(%rbp)
movq $342, %rsi 
movq %rbp, %rdi
call L2
movq %rax, %rdi 
call printint
movq -24(%rbp), %rax
movq %rax, %rbx
movq $-0, %rax 
movq $8, %r10 
mul %r10 
addq %rax, %rbx
movq (%rbx), %rdi
call printint
movq $0, %rax 
jmp L8 
L8: 
leave
ret
.size _tigermain, .-_tigermain
.ident "GCC: (DEBIAN 4.9.2-10) 4.9.2"
.section .note.GNU-stack,"",@progbits
