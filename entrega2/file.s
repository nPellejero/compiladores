;;-------: 
L5: 
MOV RBP, RBX
MOV $0, R10 
ADD R10, RBX
MOV RSI, (RBX) 
MOV RBP, RBX
MOV $0, R10 
ADD R10, RBX
MOV $123456, RCX 
MOV $L0, RDI
MOV $2, RSI 
CALL _allocRecord
MOV RAX, (RBX) 
MOV RBP, RAX
MOV $0, RBX 
ADD RBX, RAX
MOV (RAX), RAX
MOV $343, RDI 
MOV RBP, RSI
CALL L1
MOV $0, RAX 
JMP L4 
L4: 
leave
ret
_tigermain: 
;;-------: 
L3: 
MOV RBP, RAX
MOV $0, RBX 
ADD RBX, RAX
MOV RSI, (RAX) 
MOV (RBP), RAX
MOV $0, RBX 
ADD RBX, RAX
MOV (RAX), RBX
MOV $1, RAX 
MOV $4, R10 
MUL R10 
ADD RAX, RBX
MOV (RBX), RAX
ADD RDI, RAX
JMP L2 
L2: 
leave
ret
L1: 
L0:
	.long 4
	.string "Hola"
.size main, .-main
.ident "GCC: (DEBIAN 4.9.2-10) 4.9.2"
.section .note.GNU-stack,"",@progbits
