
	.macro alloc (%reg_tam, %addr_retorno) 
             li a7,9
             mv a0, %reg_tam
             ecall
             mv %addr_retorno, a0 
        .end_macro
        
          .macro print_str_reg (%reg)
             li a7, 4
             mv a0, %reg
             ecall
        .end_macro



	.eqv I_LOOP_VAR t0
	.eqv I_LOOP_CONDI t1
	
	.eqv PTR_R s0
	.eqv STR1_R s1
	.eqv STR2_R s2
	
	.eqv SIZE1_R s3
	.eqv SIZE2_R s4
	
	.eqv CHAR_ADDR_R t2
	.eqv CHAR_VAL_R t3
	
	.eqv FINAL_SIZE_R s5
	.eqv NEW_STR_R t4
	.eqv NEW_STR_CHAR_R t5
	.eqv NEW_STR_INDEX_R t6
	
	.eqv FINAL_PRINT_R s6


	.data 
	.align 2
ptr:	.word
	.align 0
str1:   .asciz "hello "
str2:	.asciz "world!"



	.text
	.align 2
	.globl main
	

main:

	la PTR_R, ptr
	la STR1_R, str1
	la STR2_R, str2
	
	
	
	mv a1, STR1_R #carrega endereço da str no arg da função
	jal str_size #chama func
	
	mv SIZE1_R,a0 #carrega tamanho da string 1
	
	addi SIZE1_R, SIZE1_R,-1
	
	mv a1, STR2_R
	jal str_size
	mv SIZE2_R, a0 #acha o tamanho da segunda string
	
	
	mv a1, STR1_R
	mv a2, STR2_R
	mv a3, SIZE1_R
	mv a4, SIZE2_R
	
	jal str_cat
	
	lw FINAL_PRINT_R, 0(PTR_R)
	
	print_str_reg FINAL_PRINT_R
	
	
	li a7,10
	ecall 
	
	

str_size:
	#a1 endereço da string
	#a0 tamanho retornando 
	
	mv CHAR_ADDR_R, a1 #move endereço da string para o registrado do byte atual
	li I_LOOP_VAR, 0 

loop1:
	
	lb CHAR_VAL_R, 0(CHAR_ADDR_R) #carrega char
	addi I_LOOP_VAR, I_LOOP_VAR, 1 #add 1 ao i 
	addi CHAR_ADDR_R, CHAR_ADDR_R, 1 #soma o endereço base mais o index do loop
	
	beq CHAR_VAL_R, zero, end_loop1  #se o char for igual a zero (\0)
	j loop1

end_loop1:
	mv a0,I_LOOP_VAR
	jr ra
	


str_cat:
	#a1 endereço str1
	#a2 endereço str 2
	#a3 tam str1
	#a4 tam str2
	
	add FINAL_SIZE_R, a3,a4
	
	alloc FINAL_SIZE_R, NEW_STR_R 
	
	mv NEW_STR_CHAR_R, NEW_STR_R #carrega endereço da nova string nesse registrador
	li NEW_STR_INDEX_R, 0 #index da nova string é 0
	
	li I_LOOP_VAR, 0
	mv I_LOOP_CONDI, a3 #condição de parada é o tamanho da string 1
	mv CHAR_ADDR_R, a1
	
loop2:
	
	lb CHAR_VAL_R, 0(CHAR_ADDR_R) #carrega char da str1
	sb CHAR_VAL_R, 0(NEW_STR_CHAR_R) #guardar char da str1 no endereço atual da nova str
	
	addi CHAR_ADDR_R, CHAR_ADDR_R, 1 #adiciona o index do loop ai endereço base da str1
	addi NEW_STR_CHAR_R, NEW_STR_CHAR_R, 1 #endereço da nova string base é somado ao seu index

	
	addi I_LOOP_VAR, I_LOOP_VAR, 1
	#addi NEW_STR_INDEX_R, NEW_STR_INDEX_R, 1 #soma 1 a variavel do loop 1 e ao index da string
	beq I_LOOP_VAR, I_LOOP_CONDI, end_loop2
	j loop2
end_loop2:
	
	li I_LOOP_VAR, 0
	mv I_LOOP_CONDI, a4
	mv CHAR_ADDR_R, a2
	
loop3:
	
	lb CHAR_VAL_R, 0(CHAR_ADDR_R)
	sb CHAR_VAL_R, 0(NEW_STR_CHAR_R)
	
	addi CHAR_ADDR_R, CHAR_ADDR_R, 1
	addi NEW_STR_CHAR_R, NEW_STR_CHAR_R, 1

	addi I_LOOP_VAR,I_LOOP_VAR,1
	#addi NEW_STR_INDEX_R, NEW_STR_INDEX_R,1
	beq  I_LOOP_VAR, I_LOOP_CONDI, end_loop3
	j loop3
end_loop3:

	sw NEW_STR_R, 0(PTR_R) #guarda o valor da nova string no ponteiro
	jr ra
