	.eqv BUF_SIZE 64
	
	.eqv str1_addr s0
	.eqv str1_size s1
	
	.eqv str2_addr s2

	.eqv char1_addr t0
	.eqv char1_val t1
	
	.eqv i_loop_var t2
	.eqv i_loop_condi t3
	
	.eqv char2_addr t4

	.data
	.align 0
str1:	.space BUF_SIZE
str_inv:.space BUF_SIZE


	.text
	.align 2
	.globl main
	
main:

	la str1_addr, str1
	la str2_addr, str_inv 
	
	li a7,8 
	mv a0, str1_addr 
	li a1, BUF_SIZE
	ecall
	
	mv a1, str1_addr
	jal str_len
	mv str1_size, a0 #pega o tamanho da string 
	addi str1_size, str1_size , -1 #ignora o \0 da str lida
	
	li i_loop_var,0
	mv i_loop_condi, str1_size
	mv char1_addr, str1_addr 
	
loop2:
	sub char2_addr, str1_size, i_loop_var
	addi char2_addr, char2_addr, -1  #endereço da segunda string invertida é TAM - i -1
	
	add char2_addr, char2_addr, str2_addr #soma endereço base + offset
	
	lb char1_val, 0(char1_addr)
	sb char1_val, 0(char2_addr)
	
	addi char1_addr, char1_addr, 1
	addi i_loop_var, i_loop_var, 1

	bge i_loop_var, i_loop_condi, end_loop2 
	j loop2
end_loop2:
	
	add char2_addr, str1_size, str2_addr
	sb zero , 0(char2_addr)

	li a7, 4 #printa str invertida
	mv a0, str2_addr
	ecall 
	
	li a7,10
	ecall
	

str_len:
	# a1 = endereço da str a ser medida
	# a0 = retorno do tamanho
	
	mv char1_addr, a1
	li i_loop_var, 0
loop1:
	lb char1_val, 0(char1_addr)
	
	addi char1_addr, char1_addr, 1
	addi i_loop_var, i_loop_var, 1

	beq char1_val,zero, end_loop1
	j loop1
end_loop1:
	mv a0, i_loop_var
	jr ra
	
	
	


	
	