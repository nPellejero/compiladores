	.file	"prueba.c"
	.globl	var
	.data
	.align 8
	.type	var, @object
	.size	var, 8
var:
	.quad	4
	.text
	.globl	func1
	.type	func1, @function
func1:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %eax
	movl	%eax, %edi
	call	func2
	movl	-4(%rbp), %eax
	addl	$1, %eax
	leave
	ret
	.size	func1, .-func1
	.globl	func2
	.type	func2, @function
func2:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %eax
	movl	%eax, %edi
	call	func1
	movl	-4(%rbp), %eax
	addl	$2, %eax
	leave
	ret
	.size	func2, .-func2
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	$3, %edi
	call	func1
	movl	$0, %eax
	popq	%rbp
	ret
	.size	main, .-main
	.ident	"GCC: (Debian 4.9.2-10) 4.9.2"
	.section	.note.GNU-stack,"",@progbits
