
.text

.globl _tigermain
_tigermain:
	pushq %rbp 
	movq %rsp,%rbp 
L3:
	movq %rdi,16(%rbp) 
	movq $4,%rax 
	movq $10,%rax 
	movq $65,%rax 
	movq $0,%rdi 
	movq $10,%rsi 
	cmpq %rsi, %rdi 
	ja L0
L1:
	movq $2,%rcx 
	cqto 
	idivq %rcx 
	movq $2,%rcx 
	imulq %rcx,%rax 
	addq $1,%rdi 
	cmpq %rsi, %rdi 
	jbe L1
L0:
	subq $8,%rsp 
	movq %rax,%rdi
	call chr
	addq $8,%rsp 
	subq $8,%rsp 
	movq %rax,%rdi
	call print
	addq $8,%rsp 
L2:
	
	movq %rbp,%rsp 
	popq %rbp 
	ret 
