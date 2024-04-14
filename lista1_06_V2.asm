	.eqv BUF_SIZE 64
	.eqv str1_addr s0
	.eqv str_size s1
	.eqv ptr_addr s2
	
	.eqv i_loop_var t0
	.eqv i_loop_condi t1
	
	.eqv char1_addr t2
	.eqv char1_val t3
	
	.eqv copy_addr t4
	.eqv copy_val t5

	.data
	.align 0
str1:	.space BUF_SIZE

	.align 2
ptr:	.word 

	.text
	.align 2
	.globl main
	
main:
	la str1_addr, str1
	la ptr_addr, ptr

	li a7,8
	mv a0, str1_addr
	li a1, BUF_SIZE 
	ecall #agora a string lida esta no endereço str1
	
	mv a1, str1_addr  #coloca endereço da string no reg de argumento a1
	jal str_len
	mv str_size , a0 #guarda tamanho da string
	
	mv a1, str1_addr
	mv a2, str_size
	mv a3 , ptr_addr
	jal str_cpy
	
	li a7,4
	lw a0, 0(ptr_addr)
	ecall 
	
	li a7,10
	ecall 
str_len:
	#argumento a1 é a string que vai ser medida
	#a0 é o retorno do seu tamanho
	li i_loop_var, 0
	mv char1_addr, a1 #endereço do primeiro char e o endereço do começo da str

loop1:
	lb char1_val, 0(char1_addr) #carrega char atual
	
	addi i_loop_var, i_loop_var,1 #soma 1 a variavel do loop  e endereço da string
	addi char1_addr, char1_addr, 1
	
	beq char1_val, zero, end_loop1 #se o char atual for um \0 da break no loop
	j loop1
end_loop1:
	mv a0, i_loop_var #retorna o tamanho da str em a0
	jr ra
	
str_cpy:
 	# Args:
	# a1 = endereço da string a ser copiada
	# a2 = tamanho da str em a1
	# a3 = ptr que vai ser setado a esse novo endereço copiado
	
	li i_loop_var, 0
	mv i_loop_condi, a2 #condição de parada é o tamanho da string
	mv char1_addr, a1 
	
	li a7, 9
	mv a0, a2 #tamanho do espaço alocado
	ecall
	mv copy_addr, a0 #endereço do bloco alocado 
	
	sw  copy_addr, 0(a3) #guarda o endereço alocado no endereço do ptr 

loop2:
	lb char1_val, 0(char1_addr) #carrega o char atual
	sb char1_val, 0(copy_addr) #guarda o char atual no endereço alocado
	
	addi char1_addr, char1_addr, 1 #avança ambo os endereços
	addi copy_addr, copy_addr, 1
	
	addi i_loop_var, i_loop_var, 1
	bge i_loop_var, i_loop_condi, end_loop2
	j loop2
end_loop2:
	jr ra

	