	 .macro print_int_reg (%reg)
             li a7 ,1
             add a0,zero ,%reg
             ecall
        .end_macro
	
	.macro print_str_addr (%addr)
             li a7,4
             la a0, %addr
             ecall
        .end_macro
        
        .macro print_str_reg (%reg)
             li a7, 4
             mv a0, %reg
             ecall
        .end_macro
        
        .macro alloc (%reg_tam, %addr_retorno) 
             li a7,9
             mv a0, %reg_tam
             ecall
             mv %addr_retorno, a0 
        .end_macro
        
        
        
	
	
	.eqv NULL_TERM_VAL 0
	
	.eqv FUNC_RETURN_R a0
	.eqv FUNC_ARG_R a2
	.eqv FUNC_ARG2_R a3
	
	
	.eqv STR_SIZE_R s0
	.eqv STR_ADDR_R s1
	.eqv COPY_STR_ADDR_R s2
	.eqv PTR_ADDR_R s3
	
	
	.eqv CHAR_ADDR_R t2
	.eqv CHAR_VALUE_R t3
	
	.eqv STR2_ADDR_R t5
	.eqv CHAR2_ADDR_R t4

	.eqv I_LOOP_VAR t0
	.eqv I_LOOP_CONDI t1


	.data
	.align 0
str1:	.asciz "hello"
	.align 2
ptr:	.word #ponteiro para o novo endereço de memoria alocado



	.text
	.align 2
	.globl main
	
main:
	la STR_ADDR_R, str1 #carrega endereço da str nesses registrador
	la PTR_ADDR_R, ptr
	mv FUNC_ARG_R,STR_ADDR_R #move o endereço da string pro argumento da function call
	
	
	jal str_size #chama a função de tam da string
	
	mv STR_SIZE_R, FUNC_RETURN_R #guarda o retorno da função num registrador do tamanho da string
	
	print_int_reg STR_SIZE_R
	
	mv FUNC_ARG_R,STR_SIZE_R #guarda endereço da string  no primeiro arg da função
	mv FUNC_ARG2_R, STR_ADDR_R
	
	jal str_cpy  #chama função de string copy
	mv COPY_STR_ADDR_R, FUNC_RETURN_R #move o resultado para esse registrador
	
	lw COPY_STR_ADDR_R, 0(COPY_STR_ADDR_R)
	 
	print_str_reg COPY_STR_ADDR_R #printa a string
	
	li a7,10
	ecall
	

str_size:
	mv CHAR_ADDR_R,FUNC_ARG_R
	li I_LOOP_VAR, 0 #carrega o index do loop como 0 inicialmente
	li I_LOOP_CONDI, NULL_TERM_VAL #carrega valor de parada do loop

loop:
	
	lb CHAR_VALUE_R, 0(CHAR_ADDR_R) #carrega um char num registrador 
	addi I_LOOP_VAR,I_LOOP_VAR,1
	beq CHAR_VALUE_R, I_LOOP_CONDI, end_loop
	
	addi CHAR_ADDR_R,CHAR_ADDR_R,1 #soma 1 ao endereço, pra pegar prox char/byte
	j loop
end_loop:

	mv FUNC_RETURN_R, I_LOOP_VAR #carrega no registrado de retorno o index do loop
	jr ra
	

str_cpy: #retorna um endereço de memória com a string copia 

	li I_LOOP_VAR, 0
	mv I_LOOP_CONDI, FUNC_ARG_R #condição de break é o tamanho da str1
	
	mv CHAR_ADDR_R, FUNC_ARG2_R #coloca o endereço do primeiro byte da str original
	
	alloc FUNC_ARG_R, STR2_ADDR_R #primeiro argumento é o tamanho do espaço alocado e ele vai ser colocado em STR2_ADDR_R
	
	mv CHAR2_ADDR_R, STR2_ADDR_R #guarda o endereço inicial da nova string no registrador de endereço do char
	
loop2:
	lb CHAR_VALUE_R, 0(CHAR_ADDR_R) #carrega o byte daquele endereço de memoria da str original
	sb CHAR_VALUE_R, 0(CHAR2_ADDR_R) #guarda o valor lido da str original no endereço de memória da string copiada
	
	
	addi CHAR_ADDR_R,CHAR_ADDR_R,1 #vai pro prox byte da str original
	addi CHAR2_ADDR_R,CHAR2_ADDR_R,1 #vai pro prox byte da str copiada
	
	
	addi I_LOOP_VAR,I_LOOP_VAR,1 #incrementa o valor do loop
	beq I_LOOP_VAR,I_LOOP_CONDI, end_loop2
	j loop2
	
end_loop2:	

	sw STR2_ADDR_R, 0(PTR_ADDR_R) #guarda o endereço da str2 no ponteiro 
	mv FUNC_RETURN_R, PTR_ADDR_R #vamos retornar o endereço da nova string
	jr ra
