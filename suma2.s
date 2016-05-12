	.file	"suma.c"
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
	.section	.rodata
.LC0:
	.string	"chau\n"
	.text
	.globl	g
	.type	g, @function
g:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movl	%edi, -4(%rbp)
	movl	%esi, -8(%rbp)
	movl	%edx, -12(%rbp)
	movl	%ecx, -16(%rbp)
	movl	%r8d, -20(%rbp)
	movl	%r9d, -24(%rbp)
	movl	$.LC0, %edi
	movl	$0, %eax
	call	print
	movl	-4(%rbp), %eax
	leal	1(%rax), %edx
	movl	16(%rbp), %eax
	addl	%eax, %edx
	movl	24(%rbp), %eax
	addl	%eax, %edx
	movl	32(%rbp), %eax
	addl	%edx, %eax
	leave
	ret
	.size	g, .-g
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movq	%rsi, -16(%rbp)
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
	subq	$8, %rsp
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
	addq	$32, %rsp
	movl	$0, %eax
	leave
	ret
	.size	main, .-main
	.ident	"GCC: (Debian 4.9.2-10) 4.9.2"
	.section	.note.GNU-stack,"",@progbits
