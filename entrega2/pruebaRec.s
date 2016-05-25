	.file	"pruebaRec.c"
	.section	.rodata
.LC0:
	.string	"%d is odd\n"
.LC1:
	.string	"%d is even\n"
	.text
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movq	%rsi, -32(%rbp)
	movl	$23945, -4(%rbp)
	movl	-4(%rbp), %eax
	movl	%eax, %edi
	movl	$0, %eax
	call	odd
	cmpl	$1, %eax
	jne	.L2
	movl	-4(%rbp), %eax
	movl	%eax, %esi
	movl	$.LC0, %edi
	movl	$0, %eax
	call	printf
	jmp	.L3
.L2:
	movl	-4(%rbp), %eax
	movl	%eax, %esi
	movl	$.LC1, %edi
	movl	$0, %eax
	call	printf
.L3:
	movl	$0, %eax
	leave
	ret
	.size	main, .-main
	.globl	odd
	.type	odd, @function
odd:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	cmpl	$0, -4(%rbp)
	jne	.L6
	movl	$0, %eax
	jmp	.L7
.L6:
	movl	-4(%rbp), %eax
	subl	$1, %eax
	movl	%eax, %edi
	movl	$0, %eax
	call	even
.L7:
	leave
	ret
	.size	odd, .-odd
	.globl	even
	.type	even, @function
even:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	cmpl	$0, -4(%rbp)
	jne	.L9
	movl	$1, %eax
	jmp	.L10
.L9:
	movl	-4(%rbp), %eax
	subl	$1, %eax
	movl	%eax, %edi
	call	odd
.L10:
	leave
	ret
	.size	even, .-even
	.ident	"GCC: (Debian 4.9.2-10) 4.9.2"
	.section	.note.GNU-stack,"",@progbits
