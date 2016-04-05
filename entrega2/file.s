L0: 
prologo
L2: 
movq rbp, rax
movq $0, rax 
add rax, rax
movq rsi, (rax) 
movq rdi, rax
movq r8, rax
movq r9, rax
movq rbp, rbx
movq $4, r10 
add r10, rbx
movq (rbx), rbx
movq $8, rbx 
add rbx, rbp
movq (rbp), rbx
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
movq $3, rax 
pushq rax
movq $2, rax 
pushq rax
movq $1, rax 
movq $9, rax 
movq rax, r9
movq $8, rax 
movq rax, r8
movq $7, rax 
movq rax, rdx
movq $6, rax 
movq rax, rcx
movq $5, rax 
movq rax, rdi
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
