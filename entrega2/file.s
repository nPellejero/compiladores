.file "file.tig"
.text
.section  .rodata
.L0:
	.quad 1
	.string " "
	.text
.globl _tigermain
.type _tigermain, @function
_tigermain: 
pushq %rbp
movq %rsp, %rbp
subq $40, %rsp
jmp L2
L2: 
movq %rdi, -8(%rbp)
movq $0, %rax 
movq $.L0, %rax
movq $0, %rax 
jmp L1 
L1: 
leave
ret
.size _tigermain, .-_tigermain
.ident "GCC: (DEBIAN 4.9.2-10) 4.9.2"
.section .note.GNU-stack,"",@progbits
