L0:
	.long 4
	.string "Hola"
L1: 
prologo2
L3: 
movq rbp, rbx
movq $0, rax 
add rax, rbx
movq ERR, (rbx) 
movq ERR, r10
movq rbp, rbx
movq $0, rax 
add rax, rbx
movq r10, (rbx) 
movq (rbp), rax
movq $0, rbx 
add rbx, rax
movq (rax), rax
movq rax, r10
movq $1, rax 
movq $4, rbx 
mul rbx 
add rax, r10
movq (r10), rax
movq $0, rbx 
add rbx, rbp
movq (rbp), rbx
add rbx, rax
jmp L2 
L2: 
leave
ret
_tigermain: 
prologo0
L5: 
movq rbp, r10
movq $0, rbx 
add rbx, r10
movq ERR, (r10) 
movq rbp, r10
movq $0, rbx 
add rbx, r10
movq r10, rbx 
movq $123456, ERR 
movq $L0, ERR
movq $2, ERR 
call _allocRecord
movq rax, (rbx) 
movq rbp, rax
movq $0, rbx 
add rbx, rax
movq (rax), rax
movq $343, ERR 
movq rbp, ERR
call L1
movq $0, rax 
jmp L4 
L4: 
leave
ret
.size main, .-main
.ident "GCC: (DEBIAN 4.9.2-10) 4.9.2"
.section .note.GNU-stack,"",@progbits
