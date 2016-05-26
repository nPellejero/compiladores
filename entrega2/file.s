.file "file.tig"
.text
.section  .rodata
.L1:
	.quad 6
	.string "ieaaa\x0a"
	.text
.globl L0
.type L0, @function
L0: 
pushq %rbp
movq %rsp, %rbp
subq $40, %rsp
jmp L6
L6: 
movq %rdi, -8(%rbp)
movq $-0, %rax 
cmp %rax, %rsi 
je L2 
L3: 
movq $1, %rax 
subq %rax, %rsi
movq -8(%rbp), %rdi
call L0
L4: 
jmp L5 
L2: 
movq $.L1, %rdi
call print
jmp L4 
L5: 
leave
ret
.size L0, .-L0
.globl _tigermain
.type _tigermain, @function
_tigermain: 
pushq %rbp
movq %rsp, %rbp
subq $40, %rsp
jmp L8
L8: 
movq %rdi, -8(%rbp)
movq $9999999, %rsi 
movq %rbp, %rdi
call L0
movq $0, %rax 
jmp L7 
L7: 
leave
ret
.size _tigermain, .-_tigermain
.ident "GCC: (DEBIAN 4.9.2-10) 4.9.2"
.section .note.GNU-stack,"",@progbits
