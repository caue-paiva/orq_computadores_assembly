	.eqv BUF_SIZE 64
	
	.eqv str1_addr s0
	.eqv str_size s1
	.eqv copy_addr s2
	
	
	.eqv i_loop_val t0
	.eqv i_loop_condi t1
	
	.eqv char1_addr t2
	.eqv char1_val t3
	.eqv char2_addr t4
	

	.data
	.align 0

str1:	.space BUF_SIZE
copy:	.space BUF_SIZE


	.text
	.align 2
	.globl main

main:

	la str1_addr, str1
	la copy_addr, copy
	
	
	li a7, 8
	mv a0 , str1_addr
	li a1 , BUF_SIZE
	ecall # le a string do user
	
	mv a1, str1_addr
	jal str_len
	mv str_size, a0 #pega o tamanho da string
	
	
	mv a1, str1_addr
	mv a2, str_size
	mv a3, copy_addr
	jal str_cpy
	
	li a7, 4
	mv a0, copy_addr
	ecall
	
	li a7,10
	ecall #sai do programa
	
	


str_len:
	#Args: a1 = endereço da string para ser medida
	# Retorno: a0 = tamanho da string
	li i_loop_val, 0
	mv char1_addr, a1 

loop1:
	lb char1_val, 0(char1_addr)
	
	addi char1_addr, char1_addr, 1
	addi i_loop_val, i_loop_val, 1
	
	beq char1_val, zero, end_loop1
	j loop1
end_loop1:

	mv a0, i_loop_val
	jr ra


str_cpy:
	# Args: a1 = endereço da string a ser copiada, a2 = seu tamanho, a3 = endereço de memoria inicial do buffer de copia
	# Retorno: nada
	
	li i_loop_val, 0
	mv i_loop_condi, a2
	
	mv char1_addr, a1 #endereço de memoria da str original
	mv char2_addr, a3 #endereço de memoria da copia
	
loop2:
	lb char1_val, 0(char1_addr) #carrega char da string atual
	sb char1_val, 0(char2_addr) #guarda esse char no buffer
	
	addi char1_addr, char1_addr, 1 #avança o endereço da str original e do buffer
	addi char2_addr, char2_addr, 1
	
	addi i_loop_val, i_loop_val, 1 #incrementa contador do loop
	bge i_loop_val, i_loop_condi, end_loop2
	j loop2
end_loop2:

	jr ra