	.eqv BUF_SIZE 64
	
	.eqv str1_addr s0
	.eqv str1_size s1
	
	.eqv str2_addr s2
	.eqv str2_size s3
	.eqv new_str_addr s4
	
	.eqv i_loop_var t0
	.eqv i_loop_condi t1
	
	.eqv char_addr t2
	.eqv char_val t3
	
	
	.data
	.align 0
str1:	.space  BUF_SIZE
str2:	.space  BUF_SIZE
new_str:.space  BUF_SIZE


	.text
	.align 2
	.globl main
	
main:

	la str1_addr, str1 #guarda os endereços das labels do .data em registradores
	la str2_addr, str2
	la new_str_addr, new_str
	
	li a7, 8 #le a str1 do usuario
	li a1, BUF_SIZE
	mv a0 , str1_addr
	ecall 
	
	li a7, 8 #le a str2 do usuario
	li a1, BUF_SIZE
	mv a0 , str2_addr
	ecall 
	
	mv a1 , str1_addr
	jal str_len
	mv str1_size, a0 #seta o tamanho da str1 com a função str_len

	mv a1, str2_addr
	jal str_len
	mv str2_size, a0 # seta o tamanho da str2 com a função str_len
	
	addi str1_size, str1_size, -1 #vamos ignorar o \0 da primeira string
	
	li i_loop_var, 0 #preparando o loop pela primeira str
	mv i_loop_condi, str1_size
	mv char_addr, str1_addr #endereço do char de copia é o começo da str1
	
lp_str1:
	lb char_val, 0(char_addr)
	sb char_val, 0(new_str_addr)
	
	addi char_addr, char_addr, 1
	addi new_str_addr, new_str_addr, 1 #avança o endereço da string antiga e nova, o endereço da nova string não 
	#é resetado entre loops
	addi i_loop_var, i_loop_var, 1
	bge i_loop_var, i_loop_condi, end_lp_str1
	j lp_str1
end_lp_str1:
	#loop na segunda string
	li i_loop_var, 0
	mv i_loop_condi, str2_size
	mv char_addr, str2_addr #endereço do char de copia é o começo da str1
lp_str2:
	lb char_val, 0(char_addr)
	sb char_val, 0(new_str_addr)
	
	addi char_addr, char_addr, 1
	addi new_str_addr, new_str_addr, 1
	
	addi i_loop_var, i_loop_var, 1
	bge i_loop_var, i_loop_condi, end_lp_str2
	j lp_str2
end_lp_str2:

	li a7, 4 #print_str
	la a0, new_str
	ecall

	li a7,10
	ecall
str_len:
	# a1 = endereço da string
	# a0 = retorno do tamanho
	li i_loop_var, 0
	mv char_addr, a1
	
loop1:
	lb char_val, 0(char_addr)
	
	addi char_addr, char_addr , 1
	addi i_loop_var, i_loop_var, 1

	beq char_val, zero, end_loop1
	j loop1
end_loop1:
	mv a0, i_loop_var
	jr ra
	
	
	

