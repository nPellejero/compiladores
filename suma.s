	.file	"suma.c"
	.globl	s
	.data
	.type	s, @object
	.size	s, 6
s:
	.string	"Hola\n"
	.text
	.globl	f
	.type	f, @function
f:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, -4(%rbp)
	movl	%esi, -8(%rbp)
	movl	%edx, -12(%rbp)
	movl	%ecx, -16(%rbp)
	movl	%r8d, -20(%rbp)
	movl	%r9d, -24(%rbp)
	movl	-4(%rbp), %eax
	leal	1(%rax), %edx
	movl	16(%rbp), %eax
	addl	%eax, %edx
	movl	24(%rbp), %eax
	addl	%eax, %edx
	movl	32(%rbp), %eax
	addl	%edx, %eax
	popq	%rbp
	ret
	.size	f, .-f
	.globl	g
	.type	g, @function
g:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, -4(%rbp)
	movl	%esi, -8(%rbp)
	movl	%edx, -12(%rbp)
	movl	%ecx, -16(%rbp)
	movl	%r8d, -20(%rbp)
	movl	%r9d, -24(%rbp)
	movl	-4(%rbp), %eax
	leal	1(%rax), %edx
	movl	16(%rbp), %eax
	addl	%eax, %edx
	movl	24(%rbp), %eax
	addl	%eax, %edx
	movl	32(%rbp), %eax
	addl	%edx, %eax
	popq	%rbp
	ret
	.size	g, .-g
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movq	%rsi, -32(%rbp)
	pushq	$111
	pushq	$4
	pushq	$2
	movl	$1, %r9d
	movl	$9, %r8d
	movl	$8, %ecx
	movl	$7, %edx
	movl	$6, %esi
	movl	$5, %edi
	call	f
	addq	$24, %rsp
	pushq	$111
	pushq	$4
	pushq	$2
	movl	$1, %r9d
	movl	$9, %r8d
	movl	$8, %ecx
	movl	$7, %edx
	movl	$6, %esi
	movl	$5, %edi
	call	g
	addq	$24, %rsp
	movq	-8(%rbp), %rax
	movq	$4, (%rax)
	movzbl	s(%rip), %eax
	movl	%eax, %edx
	movq	-8(%rbp), %rax
	movb	%dl, 8(%rax)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	print
	movl	$0, %eax
	leave
	ret
	.size	main, .-main
	.ident	"GCC: (Debian 4.9.2-10) 4.9.2"
	.section	.note.GNU-stack,"",@progbits
