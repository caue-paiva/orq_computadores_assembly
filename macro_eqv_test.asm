	.eqv PRINT_STR 4
	
	.data
	.align 0
str1:	.asciz "teste"
	
	.text
	.align 2
	
	.globl main
	

main:
	li a7,PRINT_STR
	la a0,str1
	ecall
	

