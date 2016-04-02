L0: 
prologo
L2: 
movq $0, rax 
add rax, rbp
movq rsi, (rbp) 
movq rdi, rax
movq $1, rbx 
add rbx, rax
jmp L1 
L1: 
leave
ret
_tigermain: 
prologo
L4: 
movq rbp, rax
movq $0, rbx 
add rbx, rax
movq rsi, (rax) 
movq $5, rdi 
movq rbp, rsi
call L0
movq $0, rax 
jmp L3 
L3: 
leave
ret
.size main, .-main
.ident "GCC: (DEBIAN 4.9.2-10) 4.9.2"
.section .note.GNU-stack,"",@progbits
