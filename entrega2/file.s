.file "file.tig"
.text
.section  .rodata
.L3:
	.quad 1
	.string " "
	.text
.section  .rodata
.L4:
	.quad 1
	.string "\x0a"
	.text
.globl L2
.type L2, @function
L2: 
pushq %rbp
movq %rsp, %rbp
subq $536, %rsp
jmp L58
L58: 
movq %rdi, -8(%rbp)
L11: 
movq $.L3, %rsi
movq -8(%rbp), %rax
movq -8(%rax), %rax
movq -24(%rax), %rdi
call _stringCompare
movq %rax, %rbx 
movq $-0, %r10 
cmp %r10, %rbx 
je L7 
L8: 
movq $1, %rax 
movq %rax, -24(%rbp)
movq $.L4, %rsi
movq -8(%rbp), %rax
movq -8(%rax), %rax
movq -24(%rax), %rdi
call _stringCompare
movq %rax, %rbx 
movq $-0, %r10 
cmp %r10, %rbx 
je L5 
L6: 
movq $0, %rbx 
movq %rbx, -24(%rbp)
L5: 
movq -24(%rbp), %rbx
L9: 
movq $-0, %r10 
cmp %r10, %rbx 
jne L12 
L10: 
jmp L57 
L7: 
movq $1, %rbx 
jmp L9 
L12: 
movq -8(%rbp), %rax
movq -8(%rax), %rax
movq $-24, %rbx 
addq %rbx, %rax
movq %rax, -32(%rbp)
call getstr
movq -32(%rbp), %rbx
movq %rax, (%rbx) 
movq %rbx, -32(%rbp)
jmp L11 
L57: 
leave
ret
.size L2, .-L2
.section  .rodata
.L13:
	.quad 1
	.string "0"
	.text
.section  .rodata
.L14:
	.quad 1
	.string "9"
	.text
.globl L1
.type L1, @function
L1: 
pushq %rbp
movq %rsp, %rbp
subq $496, %rsp
jmp L60
L60: 
movq %rdi, -8(%rbp)
movq %rsi, -40(%rbp)
movq $.L13, %rdi
call ord
movq %rax, -24(%rbp)
movq -40(%rbp), %rdi
call ord
movq -24(%rbp), %rbx
cmp %rax, %rbx 
jle L17 
L18: 
movq $0, %rax 
L19: 
jmp L59 
L17: 
movq $1, %rax 
movq %rax, -48(%rbp)
movq -40(%rbp), %rdi
call ord
movq %rax, -32(%rbp)
movq $.L14, %rdi
call ord
movq -32(%rbp), %rbx
cmp %rax, %rbx 
jle L15 
L16: 
movq $0, %rax 
movq %rax, -48(%rbp)
L15: 
movq -48(%rbp), %rax
jmp L19 
L59: 
leave
ret
.size L1, .-L1
.section  .rodata
.L21:
	.quad 1
	.string "0"
	.text
.globl L0
.type L0, @function
L0: 
pushq %rbp
movq %rsp, %rbp
subq $416, %rsp
jmp L62
L62: 
movq %rdi, -8(%rbp)
movq %rsi, -24(%rbp)
movq $0, %rax 
movq %rax, -32(%rbp)
movq %rbp, %rdi
call L2
movq -24(%rbp), %rax
movq %rax, %rbx
movq $-0, %rax 
movq $8, %r10 
mul %r10 
addq %rax, %rbx
movq %rbx, %rax 
movq %rax, -40(%rbp)
movq -8(%rbp), %rax
movq -24(%rax), %rsi
movq %rbp, %rdi
call L1
movq -40(%rbp), %rbx
movq %rax, (%rbx) 
movq %rbx, -40(%rbp)
L22: 
movq -8(%rbp), %rax
movq -24(%rax), %rsi
movq %rbp, %rdi
call L1
movq $-0, %rbx 
cmp %rbx, %rax 
jne L23 
L20: 
movq -32(%rbp), %rax
jmp L61 
L23: 
movq -32(%rbp), %rax
movq $10, %rbx 
mul %rbx 
movq %rax, -48(%rbp)
movq -8(%rbp), %rax
movq -24(%rax), %rdi
call ord
movq -48(%rbp), %rbx
addq %rax, %rbx
movq %rbx, %rax 
movq %rax, -56(%rbp)
movq $.L21, %rdi
call ord
movq -56(%rbp), %rbx
sub %rax, %rbx
movq %rbx, %rax 
movq %rax, -32(%rbp)
movq -8(%rbp), %rax
movq $-24, %rbx 
addq %rbx, %rax
movq %rax, -64(%rbp)
call getstr
movq -64(%rbp), %rbx
movq %rax, (%rbx) 
movq %rbx, -64(%rbp)
jmp L22 
L61: 
leave
ret
.size L0, .-L0
.section  .rodata
.L28:
	.quad 1
	.string "\x0a"
	.text
.section  .rodata
.L29:
	.quad 1
	.string " "
	.text
.globl L27
.type L27, @function
L27: 
pushq %rbp
movq %rsp, %rbp
subq $304, %rsp
jmp L64
L64: 
movq %rdi, -8(%rbp)
movq %rsi, -24(%rbp)
movq $-0, %rbx 
movq -24(%rbp), %rax
cmp %rbx, %rax 
je L30 
L31: 
movq -24(%rbp), %rax
movq %rax, %rbx
movq $-0, %rax 
movq $8, %r10 
mul %r10 
addq %rax, %rbx
movq (%rbx), %rsi
movq -8(%rbp), %rdi
call L26
movq $.L29, %rdi
call print
movq -24(%rbp), %rax
movq %rax, %rbx
movq $1, %rax 
movq $8, %r10 
mul %r10 
addq %rax, %rbx
movq (%rbx), %rsi
movq -8(%rbp), %rdi
call L27
L32: 
jmp L63 
L30: 
movq $.L28, %rdi
call print
jmp L32 
L63: 
leave
ret
.size L27, .-L27
.section  .rodata
.L34:
	.quad 1
	.string "0"
	.text
.globl L33
.type L33, @function
L33: 
pushq %rbp
movq %rsp, %rbp
subq $272, %rsp
jmp L66
L66: 
movq %rdi, -8(%rbp)
movq %rsi, -32(%rbp)
movq $-0, %r10 
movq -32(%rbp), %rbx
cmp %r10, %rbx 
jg L35 
L36: 
jmp L65 
L35: 
movq -32(%rbp), %rax
movq $0, %rdx
movq $10, %rbx 
div %rbx 
movq %rax, %rsi
movq -8(%rbp), %rdi
call L33
movq -32(%rbp), %rax
movq %rax, %rbx
movq -32(%rbp), %rax
movq $0, %rdx
movq $10, %r10 
div %r10 
movq $10, %r10 
mul %r10 
sub %rax, %rbx
movq %rbx, %rax 
movq %rax, -24(%rbp)
movq $.L34, %rdi
call ord
movq -24(%rbp), %rdi
addq %rax, %rdi
call chr
movq %rax, %rdi 
call print
jmp L36 
L65: 
leave
ret
.size L33, .-L33
.section  .rodata
.L37:
	.quad 1
	.string "-"
	.text
.section  .rodata
.L38:
	.quad 1
	.string "0"
	.text
.globl L26
.type L26, @function
L26: 
pushq %rbp
movq %rsp, %rbp
subq $216, %rsp
jmp L68
L68: 
movq %rdi, -8(%rbp)
movq %rsi, -24(%rbp)
movq $-0, %rbx 
movq -24(%rbp), %rax
cmp %rbx, %rax 
jl L42 
L43: 
movq $-0, %rbx 
movq -24(%rbp), %rax
cmp %rbx, %rax 
jg L39 
L40: 
movq $.L38, %rdi
call print
L41: 
L44: 
jmp L67 
L42: 
movq $.L37, %rdi
call print
movq $-0, %rsi 
movq -24(%rbp), %rax
sub %rax, %rsi
movq %rbp, %rdi
call L33
jmp L44 
L39: 
movq -24(%rbp), %rsi
movq %rbp, %rdi
call L33
jmp L41 
L67: 
leave
ret
.size L26, .-L26
.globl L25
.type L25, @function
L25: 
pushq %rbp
movq %rsp, %rbp
subq $176, %rsp
jmp L70
L70: 
movq %rdi, -8(%rbp)
movq $-0, %rax 
cmp %rax, %rsi 
je L51 
L52: 
movq $-0, %rax 
cmp %rax, %rdx 
je L48 
L49: 
movq %rdx, %rbx
movq $-0, %rax 
movq $8, %r10 
mul %r10 
addq %rax, %rbx
movq (%rbx), %r11
movq %rsi, %rbx
movq $-0, %rax 
movq $8, %r10 
mul %r10 
addq %rax, %rbx
movq (%rbx), %rax
cmp %r11, %rax 
jl L45 
L46: 
movq %rdx, %rbx
movq $-0, %rax 
movq $8, %r10 
mul %r10 
addq %rax, %rbx
movq (%rbx), %rax
movq %rax, -32(%rbp)
movq $1, %rax 
movq $8, %rbx 
mul %rbx 
addq %rax, %rdx
movq (%rdx), %rdx
movq -8(%rbp), %rdi
call L25
movq %rax, %rdx 
movq $0, %rax 
movq -32(%rbp), %rsi
movq $2, %rdi 
call _allocRecord
L47: 
movq %rax, %rdx
L50: 
L53: 
movq %rdx, %rax
jmp L69 
L51: 
jmp L53 
L48: 
movq %rsi, %rdx
jmp L50 
L45: 
movq %rsi, %rbx
movq $-0, %rax 
movq $8, %r10 
mul %r10 
addq %rax, %rbx
movq (%rbx), %rax
movq %rax, -24(%rbp)
movq %rsi, %rbx
movq $1, %rax 
movq $8, %r10 
mul %r10 
addq %rax, %rbx
movq (%rbx), %rsi
movq -8(%rbp), %rdi
call L25
movq %rax, %rdx 
movq $0, %rax 
movq -24(%rbp), %rsi
movq $2, %rdi 
call _allocRecord
jmp L47 
L69: 
leave
ret
.size L25, .-L25
.globl L24
.type L24, @function
L24: 
pushq %rbp
movq %rsp, %rbp
subq $144, %rsp
jmp L72
L72: 
movq %rdi, -8(%rbp)
movq $0, %rax 
movq $-0, %rsi 
movq $1, %rdi 
call _allocRecord
movq %rax, -24(%rbp)
movq -24(%rbp), %rsi
movq -8(%rbp), %rdi
call L0
movq %rax, %r10 
movq $-0, %r12 
movq -24(%rbp), %rax
movq %rax, %rbx
movq $-0, %rax 
movq $8, %r11 
mul %r11 
addq %rax, %rbx
movq (%rbx), %rax
cmp %r12, %rax 
jne L54 
L55: 
movq $0, %rax 
L56: 
jmp L71 
L54: 
movq %r10, %rax
movq %rax, -32(%rbp)
movq -8(%rbp), %rdi
call L24
movq %rax, %rdx 
movq $0, %rax 
movq -32(%rbp), %rsi
movq $2, %rdi 
call _allocRecord
jmp L56 
L71: 
leave
ret
.size L24, .-L24
.globl _tigermain
.type _tigermain, @function
_tigermain: 
pushq %rbp
movq %rsp, %rbp
subq $104, %rsp
jmp L74
L74: 
movq %rdi, -8(%rbp)
movq %rbp, %rax
movq $-24, %rbx 
addq %rbx, %rax
movq %rax, -40(%rbp)
call getstr
movq -40(%rbp), %rbx
movq %rax, (%rbx) 
movq %rbx, -40(%rbp)
movq %rbp, %rdi
call L24
movq %rax, -32(%rbp)
movq %rbp, %rax
movq $-24, %rbx 
addq %rbx, %rax
movq %rax, -48(%rbp)
call getstr
movq -48(%rbp), %rbx
movq %rax, (%rbx) 
movq %rbx, -48(%rbp)
movq %rbp, %rdi
call L24
movq %rax, %rdx 
movq %rbp, %rax
movq %rax, -56(%rbp)
movq -32(%rbp), %rsi
movq %rbp, %rdi
call L25
movq %rax, %rsi 
movq -56(%rbp), %rdi
call L27
movq $0, %rax 
jmp L73 
L73: 
leave
ret
.size _tigermain, .-_tigermain
.ident "GCC: (DEBIAN 4.9.2-10) 4.9.2"
.section .note.GNU-stack,"",@progbits
