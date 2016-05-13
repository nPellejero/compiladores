.file "file.tig"
.text
.globl L1
.type L1, @function
L1: 
pushq %rbp
movq %rsp, %rbp
subq $936, %rsp
jmp L34
L34: 
movq %rdi, -8(%rbp)
movq %rsi, -24(%rbp)
movq -8(%rbp), %rbx
movq -24(%rbx), %rbx
movq -24(%rbp), %r10
cmp %rbx, %r10 
je L17 
L18: 
movq $0, %rbx 
movq %rbx, -32(%rbp)
L15: 
movq -8(%rbp), %rbx
movq -24(%rbx), %rbx
movq $1, %r10 
sub %r10, %rbx
movq -32(%rbp), %r10
cmp %rbx, %r10 
jg L2 
L16: 
movq -8(%rbp), %rax
movq -32(%rax), %rax
movq %rax, -112(%rbp)
movq -32(%rbp), %rax
movq %rax, -168(%rbp)
movq -168(%rbp), %rsi
movq -112(%rbp), %rdi
call _checkIndexArray
movq $-0, %r11 
movq -112(%rbp), %rax
movq %rax, %r10
movq -168(%rbp), %rax
movq $8, %rbx 
mul %rbx 
movq %rax, %rbx
addq %rbx, %r10
movq (%r10), %rbx
cmp %r11, %rbx 
je L5 
L6: 
movq $0, %rbx 
L7: 
movq $-0, %r10 
cmp %r10, %rbx 
jne L10 
L11: 
movq $0, %rbx 
L12: 
movq $-0, %r10 
cmp %r10, %rbx 
jne L13 
L14: 
movq -32(%rbp), %rbx
movq $1, %r10 
addq %r10, %rbx
movq %rbx, -32(%rbp)
jmp L15 
L17: 
movq -8(%rbp), %rdi
call L0
L19: 
jmp L33 
L5: 
movq $1, %rax 
movq %rax, -192(%rbp)
movq -8(%rbp), %rax
movq -48(%rax), %rax
movq %rax, -176(%rbp)
movq -32(%rbp), %rax
movq -24(%rbp), %rbx
addq %rbx, %rax
movq %rax, -184(%rbp)
movq -184(%rbp), %rsi
movq -176(%rbp), %rdi
call _checkIndexArray
movq $-0, %r11 
movq -176(%rbp), %rax
movq %rax, %r10
movq -184(%rbp), %rax
movq $8, %rbx 
mul %rbx 
movq %rax, %rbx
addq %rbx, %r10
movq (%r10), %rbx
cmp %r11, %rbx 
je L3 
L4: 
movq $0, %rbx 
movq %rbx, -192(%rbp)
L3: 
movq -192(%rbp), %rbx
jmp L7 
L10: 
movq $1, %rax 
movq %rax, -40(%rbp)
movq -8(%rbp), %rax
movq -56(%rax), %rax
movq %rax, -200(%rbp)
movq -32(%rbp), %rax
movq $7, %rbx 
addq %rbx, %rax
movq -24(%rbp), %rbx
sub %rbx, %rax
movq %rax, -208(%rbp)
movq -208(%rbp), %rsi
movq -200(%rbp), %rdi
call _checkIndexArray
movq $-0, %r11 
movq -200(%rbp), %rax
movq %rax, %r10
movq -208(%rbp), %rax
movq $8, %rbx 
mul %rbx 
movq %rax, %rbx
addq %rbx, %r10
movq (%r10), %rbx
cmp %r11, %rbx 
je L8 
L9: 
movq $0, %rbx 
movq %rbx, -40(%rbp)
L8: 
movq -40(%rbp), %rbx
jmp L12 
L13: 
movq -8(%rbp), %rax
movq -32(%rax), %rax
movq %rax, -48(%rbp)
movq -32(%rbp), %rax
movq %rax, -56(%rbp)
movq -56(%rbp), %rsi
movq -48(%rbp), %rdi
call _checkIndexArray
movq -48(%rbp), %rax
movq %rax, %rbx
movq -56(%rbp), %rax
movq $8, %r10 
mul %r10 
addq %rax, %rbx
movq $1, %rax 
movq %rax, (%rbx) 
movq -8(%rbp), %rax
movq -48(%rax), %rax
movq %rax, -64(%rbp)
movq -32(%rbp), %rax
movq -24(%rbp), %rbx
addq %rbx, %rax
movq %rax, -72(%rbp)
movq -72(%rbp), %rsi
movq -64(%rbp), %rdi
call _checkIndexArray
movq -64(%rbp), %rax
movq %rax, %rbx
movq -72(%rbp), %rax
movq $8, %r10 
mul %r10 
addq %rax, %rbx
movq $1, %rax 
movq %rax, (%rbx) 
movq -8(%rbp), %rax
movq -56(%rax), %rax
movq %rax, -80(%rbp)
movq -32(%rbp), %rax
movq $7, %rbx 
addq %rbx, %rax
movq -24(%rbp), %rbx
sub %rbx, %rax
movq %rax, -88(%rbp)
movq -88(%rbp), %rsi
movq -80(%rbp), %rdi
call _checkIndexArray
movq -80(%rbp), %rax
movq %rax, %rbx
movq -88(%rbp), %rax
movq $8, %r10 
mul %r10 
addq %rax, %rbx
movq $1, %rax 
movq %rax, (%rbx) 
movq -8(%rbp), %rax
movq -40(%rax), %rax
movq %rax, -96(%rbp)
movq -24(%rbp), %rax
movq %rax, -104(%rbp)
movq -104(%rbp), %rsi
movq -96(%rbp), %rdi
call _checkIndexArray
movq -96(%rbp), %rax
movq %rax, %rbx
movq -104(%rbp), %rax
movq $8, %r10 
mul %r10 
addq %rax, %rbx
movq -32(%rbp), %rax
movq %rax, (%rbx) 
movq -24(%rbp), %rsi
movq $1, %rax 
addq %rax, %rsi
movq -8(%rbp), %rdi
call L1
movq -8(%rbp), %rax
movq -32(%rax), %rax
movq %rax, -120(%rbp)
movq -32(%rbp), %rax
movq %rax, -128(%rbp)
movq -128(%rbp), %rsi
movq -120(%rbp), %rdi
call _checkIndexArray
movq -120(%rbp), %rax
movq %rax, %rbx
movq -128(%rbp), %rax
movq $8, %r10 
mul %r10 
addq %rax, %rbx
movq $-0, %rax 
movq %rax, (%rbx) 
movq -8(%rbp), %rax
movq -48(%rax), %rax
movq %rax, -136(%rbp)
movq -32(%rbp), %rax
movq -24(%rbp), %rbx
addq %rbx, %rax
movq %rax, -144(%rbp)
movq -144(%rbp), %rsi
movq -136(%rbp), %rdi
call _checkIndexArray
movq -136(%rbp), %rax
movq %rax, %rbx
movq -144(%rbp), %rax
movq $8, %r10 
mul %r10 
addq %rax, %rbx
movq $-0, %rax 
movq %rax, (%rbx) 
movq -8(%rbp), %rax
movq -56(%rax), %rax
movq %rax, -152(%rbp)
movq -32(%rbp), %rax
movq $7, %rbx 
addq %rbx, %rax
movq -24(%rbp), %rbx
sub %rbx, %rax
movq %rax, -160(%rbp)
movq -160(%rbp), %rsi
movq -152(%rbp), %rdi
call _checkIndexArray
movq -152(%rbp), %rax
movq %rax, %r10
movq -160(%rbp), %rax
movq $8, %rbx 
mul %rbx 
movq %rax, %rbx
addq %rbx, %r10
movq $-0, %rbx 
movq %rbx, (%r10) 
jmp L14 
L2: 
jmp L19 
L33: 
leave
ret
.size L1, .-L1
.section  .rodata
.L22:
	.quad 2
	.string " O"
	.text
.section  .rodata
.L23:
	.quad 2
	.string " ."
	.text
.section  .rodata
.L29:
	.quad 1
	.string "\x0a"
	.text
.section  .rodata
.L32:
	.quad 1
	.string "\x0a"
	.text
.globl L0
.type L0, @function
L0: 
pushq %rbp
movq %rsp, %rbp
subq $216, %rsp
jmp L36
L36: 
movq %rdi, -8(%rbp)
movq $0, %rax 
movq %rax, -24(%rbp)
L30: 
movq -8(%rbp), %rax
movq -24(%rax), %rax
movq $1, %rbx 
sub %rbx, %rax
movq -24(%rbp), %rbx
cmp %rax, %rbx 
jg L20 
L31: 
movq $0, %rax 
movq %rax, -32(%rbp)
L27: 
movq -8(%rbp), %rax
movq -24(%rax), %rax
movq $1, %rbx 
sub %rbx, %rax
movq -32(%rbp), %rbx
cmp %rax, %rbx 
jg L21 
L28: 
movq -8(%rbp), %rax
movq -40(%rax), %rax
movq %rax, -40(%rbp)
movq -24(%rbp), %rax
movq %rax, -48(%rbp)
movq -48(%rbp), %rsi
movq -40(%rbp), %rdi
call _checkIndexArray
movq -40(%rbp), %rax
movq %rax, %rbx
movq -48(%rbp), %rax
movq $8, %r10 
mul %r10 
addq %rax, %rbx
movq (%rbx), %rbx
movq -32(%rbp), %rax
cmp %rax, %rbx 
je L24 
L25: 
movq $.L23, %rdi
L26: 
call print
movq -32(%rbp), %rax
movq $1, %rbx 
addq %rbx, %rax
movq %rax, -32(%rbp)
jmp L27 
L24: 
movq $.L22, %rax
movq %rax, %rdi 
jmp L26 
L21: 
movq $.L29, %rdi
call print
movq -24(%rbp), %rax
movq $1, %rbx 
addq %rbx, %rax
movq %rax, -24(%rbp)
jmp L30 
L20: 
movq $.L32, %rdi
call print
jmp L35 
L35: 
leave
ret
.size L0, .-L0
.globl _tigermain
.type _tigermain, @function
_tigermain: 
pushq %rbp
movq %rsp, %rbp
subq $88, %rsp
jmp L38
L38: 
movq %rdi, -8(%rbp)
movq $8, %rax 
movq %rax, -24(%rbp)
movq %rbp, %rax
movq $-32, %rbx 
addq %rbx, %rax
movq %rax, -64(%rbp)
movq $-0, %rsi 
movq -24(%rbp), %rdi
call _initArray
movq -64(%rbp), %rbx
movq %rax, (%rbx) 
movq %rbx, -64(%rbp)
movq %rbp, %rax
movq $-40, %rbx 
addq %rbx, %rax
movq %rax, -72(%rbp)
movq $-0, %rsi 
movq -24(%rbp), %rdi
call _initArray
movq -72(%rbp), %rbx
movq %rax, (%rbx) 
movq %rbx, -72(%rbp)
movq %rbp, %rax
movq $-48, %rbx 
addq %rbx, %rax
movq %rax, -80(%rbp)
movq $-0, %rsi 
movq -24(%rbp), %rdi
movq -24(%rbp), %rax
addq %rax, %rdi
movq $1, %rax 
sub %rax, %rdi
call _initArray
movq -80(%rbp), %rbx
movq %rax, (%rbx) 
movq %rbx, -80(%rbp)
movq %rbp, %rax
movq $-56, %rbx 
addq %rbx, %rax
movq %rax, -88(%rbp)
movq $-0, %rsi 
movq -24(%rbp), %rdi
movq -24(%rbp), %rax
addq %rax, %rdi
movq $1, %rax 
sub %rax, %rdi
call _initArray
movq -88(%rbp), %rbx
movq %rax, (%rbx) 
movq %rbx, -88(%rbp)
movq $-0, %rsi 
movq %rbp, %rdi
call L1
movq $0, %rax 
jmp L37 
L37: 
leave
ret
.size _tigermain, .-_tigermain
.ident "GCC: (DEBIAN 4.9.2-10) 4.9.2"
.section .note.GNU-stack,"",@progbits
