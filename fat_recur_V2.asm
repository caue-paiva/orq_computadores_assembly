	.eqv N 3
	
	.eqv base_case_reg t0
	.eqv fat_num_arg a1

	.eqv main_result s1
	
	.text
	.align 2
	.globl main
	

main:
	li a1, N
	jal fat_recur
	mv main_result, a0
	
	li a7, 1
	mv a0, main_result
	ecall
	
	
	li a7,10
	ecall
	
	
fat_recur:
	# a1 = numero do fatorial a ser calculado
	# a0 = valor retornado 
	beq fat_num_arg, zero, base_case
	
	addi sp, sp , -8 #aloca espaço na stack
	
	sw ra, 0(sp) #guarda o RA e N atual 
	sw fat_num_arg, 4(sp)
	
	addi fat_num_arg, fat_num_arg, -1 #chama a função recursiva com n-1
	jal fat_recur
	
	lw ra, 0(sp)
	lw fat_num_arg, 4(sp) #carrega o valor anterior do n e do ra
	
	addi sp,sp ,8 #libera espaço na stack
	
	mul a0, fat_num_arg, a0 #multiplica o n atual pelo retorno da chamada recursiva
	jr ra
	
base_case:
	li a0, 1
	jr ra
	