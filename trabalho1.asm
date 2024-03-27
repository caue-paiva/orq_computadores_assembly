		#MACROS
		.macro print_int_reg (%reg) #macro pra printar um int
            		li a7 ,1
             		add a0,zero ,%reg
            		ecall
      		.end_macro
		
		#RANDINT DEFINES
		.eqv RNG_RETURN_R a0 #labels para registradores da função de criar numeros randomicos
		.eqv RNG_A_R a1
		.eqv RNG_C_R a2
		.eqv RNG_M_R a3 
		.eqv RNG_SEED_ADDR_R a4
		.eqv RNG_SEED_R a5
		
		.eqv RANDSEED_ECALL 40 #label para ecall de randseet
		
		.eqv RNG_A_VAL 34 #valor inicial para o A do algoritmo de randomização
		.eqv RNG_C_VAL 145
		.eqv RNG_M_VAL 99 #valor de Módulo do algo. de RNG, vai gerar uma seed final entre [0,99]
		
		
		#MAIN_GAME DEFINES



	 	.data
	 	.align 0
	 	
user_prompt:	.asciz "Qual e o numero certo?"
vict_answr:	.asciz "Parabens, voce venceu!!"
smaller_answr:	.asciz "Numero dado é menor que a resposta"
bigger_answr:	.asciz "Numero dado é maior que a resposta"	
		

	
		.text
		.align 2
		.globl main
		
		


main:
	jal randint
	mv t0 , RNG_RETURN_R
	
	print_int_reg t0
	

#algoritmo:  Linear Congruential Generator (LCG)
randint:

	li RNG_A_R, RNG_A_VAL #carrega valores que vão ser usados para gerar numeros randomicos
	li RNG_C_R, RNG_C_VAL
	li RNG_M_R, RNG_M_VAL	
	
	li a7, RANDSEED_ECALL #ecall de randseed
	ecall
	mv RNG_SEED_R, a0 #guarda a nova randomseed no registrador apropiado
		  
	mul RNG_SEED_R, RNG_SEED_R, RNG_A_R  #multiplica a seed por A
	add RNG_SEED_R, RNG_SEED_R, RNG_C_R  #add C à seed
	rem RNG_SEED_R, RNG_SEED_R, RNG_M_R  #faz mod da seed por M
	
	addi RNG_RETURN_R, RNG_SEED_R, 1 #registrador de retorno vai ter o valor da seed +1 , já que a seed pode estar entre [0,99] e queremos [1,100]
	jr ra #retorna pro endereço de chamada


	
