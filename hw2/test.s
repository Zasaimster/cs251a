	.file	"test.c"
	.text
	.globl	reverse_subtract
	.type	reverse_subtract, @function
reverse_subtract:
.LFB0:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movss	%xmm0, -20(%rbp)
	movss	%xmm1, -24(%rbp)
	pxor	%xmm0, %xmm0
	movss	%xmm0, -4(%rbp)
	movss	-20(%rbp), %xmm0
	movss	-24(%rbp), %xmm2
	movss	%xmm2, -28(%rbp)
	movss	%xmm0, -32(%rbp)
	flds	-28(%rbp)
	flds	-32(%rbp)
#APP
# 4 "test.c" 1
	fsubr %st(1), %st
# 0 "" 2
#NO_APP
	fstp	%st(1)
	fstps	-4(%rbp)
	movss	-4(%rbp), %xmm0
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	reverse_subtract, .-reverse_subtract
	.section	.rodata
	.align 8
.LC4:
	.string	"reverse_subtract(%f, %f) = %f\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB1:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movss	.LC2(%rip), %xmm0
	movss	%xmm0, -12(%rbp)
	movss	.LC3(%rip), %xmm0
	movss	%xmm0, -8(%rbp)
	movss	-8(%rbp), %xmm0
	movl	-12(%rbp), %eax
	movaps	%xmm0, %xmm1
	movd	%eax, %xmm0
	call	reverse_subtract
	movd	%xmm0, %eax
	movl	%eax, -4(%rbp)
	pxor	%xmm1, %xmm1
	cvtss2sd	-4(%rbp), %xmm1
	pxor	%xmm0, %xmm0
	cvtss2sd	-8(%rbp), %xmm0
	pxor	%xmm3, %xmm3
	cvtss2sd	-12(%rbp), %xmm3
	movq	%xmm3, %rax
	movapd	%xmm1, %xmm2
	movapd	%xmm0, %xmm1
	movq	%rax, %xmm0
	leaq	.LC4(%rip), %rdi
	movl	$3, %eax
	call	printf@PLT
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.section	.rodata
	.align 4
.LC2:
	.long	1078530008
	.align 4
.LC3:
	.long	1086918616
	.ident	"GCC: (Ubuntu 10.5.0-1ubuntu1~20.04) 10.5.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
