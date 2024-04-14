	.eqv BUF_SIZE 64
	
	.eqv str1_addr s0
	.eqv str1_size s2
	
	.eqv str2_addr s1
	.eqv str2_size s3
	
	.eqv i_loop_var t0
	.eqv i_loop_condi t1
	
	.eqv char1_addr t2
	.eqv char1_val t3
	
	.eqv char2_addr t4
	.eqv char2_val t5
	

	.data 
	.align 0
dif:	.asciz "strs sao diferentes"
iguais:	.asciz "strs sao iguais"

str1:	.space BUF_SIZE
str2:	.space BUF_SIZE


	.text
	.align 2
	.globl main
	

main:
	la str1_addr, str1
	la str2_addr, str2


	li a7, 8
	mv a0, str1_addr
	li a1, BUF_SIZE
	ecall  #le str1
	 
	li a7, 8
	mv a0, str2_addr
	li a1, BUF_SIZE
	ecall  #le a str2
	
	
	mv a1, str1_addr 
	jal str_len 
	mv str1_size, a0 #chama a função str_len para str1
	
	
	mv a1, str2_addr
	jal str_len
	mv str2_size, a0 #chama str_len para str2
	
	bne str1_size, str2_size, different #caso as strs tenham tamanhos diferentes, elas não são iguais
	
	li i_loop_var, 0
	mv i_loop_condi, str1_size #loop de zero ate o tam-1 da string
	
	mv char1_addr, str1_addr
	mv char2_addr, str2_addr #carrega os endereços iniciais das strings 
	
loop_main:
	lb char1_val, 0(char1_addr) #carrega os 2 chars
	lb char2_val, 0(char2_addr)
	
	bne char1_val, char2_val, different #caso eles sejam diferentes
	
	addi char1_addr, char1_addr, 1 #avança o endereço dos chars
	addi char2_addr, char2_addr, 1
	
	addi i_loop_var, i_loop_var, 1 #incrementa contador do loop
	bge i_loop_var, i_loop_condi, end_lp_main
	j loop_main
end_lp_main:
	#se chegou aqui, as strings são iguais
	li a7, 4
	la a0, iguais
	ecall
	
	li a7,10 #sai do programa
	ecall

different: #strings não sao iguais
	li a7, 4
	la a0, dif
	ecall
	
	li a7,10 #sai do programa
	ecall
	

str_len:
	#Args: a1 = endereço da str
	# retorno a0 = tamanho
	li i_loop_var, 0
	mv char1_addr, a1
	
loop1:
	lb char1_val, 0(char1_addr)
	
	addi char1_addr, char1_addr, 1
	addi i_loop_var, i_loop_var, 1

	beq char1_val, zero, end_loop1
	j loop1
end_loop1:

	mv a0, i_loop_var
	jr ra

	