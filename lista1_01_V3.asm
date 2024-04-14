	.eqv SIZE 7
	.eqv vec_addr s0
	.eqv sum s1
	
	.eqv num_addr t0
	.eqv num_val t1
	
	.eqv i_loop_var t2
	.eqv i_loop_condi t3
	
	.data
	.align 2
vec:	.word 2,3,4,5,9,10,2

	.text
	.align 2
	.globl main

main:
	la vec_addr, vec #carrega endereço do vetor
	li sum, 0 #inicia a soma com 0
	
	li i_loop_var, 0 #variaveis do loop
	li i_loop_condi, SIZE
loop:
	mv num_addr, i_loop_var #index do array é setado como index do loop 
	slli num_addr, num_addr, 2 #multiplica o indice do array por 4 pq cada numero tem 4 bytes
	
	add num_addr, num_addr, vec_addr #soma offset + endereço base
	
	lw num_val, 0(num_addr) #guarda o valor do numero acessado
	
	add sum, num_val, sum #adiciona o valor do numero atual a soma total

	addi i_loop_var, i_loop_var, 1  #incrementa i
	bge i_loop_var, i_loop_condi, end_loop
	j loop
end_loop:

	li a7, 1 #print Int
	mv a0, sum
	ecall
	
	li a7,10 #exit
	ecall

