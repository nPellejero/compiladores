.file "file.tig"
.text
.section  .rodata
.L0:
	.long 4
	.string "Hola"
	.text
.section  .rodata
.L1:
	.long 4
	.string "Chau"
	.text
.globl _tigermain
.type _tigermain, @function
_tigermain: 
pushq %rbp
movq %rsp, %rbp
subq $64, %rsp
jmp L6
L6: 
movq %rsi, -8(%rbp)
movq $4, %rax 
movq %rax, -24(%rbp)
movq -24(%rbp), %rax
movq $-0, %rbx 
movq -24(%rbp), %rax
cmp %rax, %rbx 
je L2 
L3: 
movq $.L1, %rsi
call print
L4: 
movq $0, %rax 
jmp L5 
L2: 
movq $.L0, %rsi
call print
movq -24(%rbp), %rax
movq $1, %rbx 
sub %rbx, %rax
movq %rax, -24(%rbp)
jmp L4 
L5: 
leave
ret
.size _tigermain, .-_tigermain
.ident "GCC: (DEBIAN 4.9.2-10) 4.9.2"
.section .note.GNU-stack,"",@progbits
