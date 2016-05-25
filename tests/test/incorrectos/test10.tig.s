
.text

.globl _tigermain
_tigermain:
	pushq %rbp 
	movq %rsp,%rbp 
	subq $136,%rsp 
L5:
	movq %rdi,16(%rbp) 
	movq $0,%rax 
	movq %rax,-72(%rbp) 
	movq $0,%rax 
	movq $0,%rax 
	movq %rax,-16(%rbp) 
	movq -72(%rbp),%rax 
	movq %rax,-64(%rbp) 
	subq $8,%rsp 
	movq -64(%rbp),%rdi 
	call _checkNil
	addq $8,%rsp 
	movq -64(%rbp),%rax 
	movq 0(%rax),%rax 
	movq %rax,-56(%rbp) 
	subq $8,%rsp 
	movq -56(%rbp),%rdi 
	call _checkNil
	addq $8,%rsp 
	movq -56(%rbp),%rax 
	movq 0(%rax),%rax 
	movq %rax,-48(%rbp) 
	subq $8,%rsp 
	movq -48(%rbp),%rdi 
	call _checkNil
	addq $8,%rsp 
	movq -48(%rbp),%rax 
	movq 0(%rax),%rax 
	movq %rax,-8(%rbp) 
	movq -72(%rbp),%rax 
	movq %rax,-40(%rbp) 
	subq $8,%rsp 
	movq -40(%rbp),%rdi 
	call _checkNil
	addq $8,%rsp 
	movq -40(%rbp),%rax 
	movq 0(%rax),%rax 
	movq %rax,-32(%rbp) 
	subq $8,%rsp 
	movq -32(%rbp),%rdi 
	call _checkNil
	addq $8,%rsp 
	movq -32(%rbp),%rax 
	movq 0(%rax),%rax 
	movq %rax,-24(%rbp) 
	subq $8,%rsp 
	movq -24(%rbp),%rdi 
	call _checkNil
	addq $8,%rsp 
	movq -24(%rbp),%rdi 
	addq $0,%rdi 
	movq (%rdi),%rsi 
	movq -8(%rbp),%rdi 
	cmpq %rsi, %rdi 
	je L0
L1:
	movq $0,%rsi 
	movq -16(%rbp),%rdi 
	cmpq %rsi, %rdi 
	jne L2
L3:
	jmp L4 
L0:
	movq $1,%rdi 
	movq %rdi,-16(%rbp) 
	jmp L1 
L2:
	jmp L3 
L4:
	
	addq $136,%rsp 
	movq %rbp,%rsp 
	popq %rbp 
	ret 
