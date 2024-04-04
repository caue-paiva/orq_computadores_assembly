	.macro print_int_reg (%reg)
             li a7 ,1
             add a0,zero ,%reg
             ecall
        .end_macro
	
	
	.eqv N 2
	.eqv FAT_ARG_R a0
	.eqv FAT_RETURN_R a3
	
	
	.eqv BASE_CASE_R  t0
	.eqv TEMP_RESULT_R t2

	.data
	
	
	
	.text
	.align 2
	.globl main
	

main:	

	li FAT_ARG_R, N
	jal fat_recur
	print_int_reg FAT_RETURN_R
	
fat_recur:	
	li BASE_CASE_R,1 #carrega 1 no caso base
	beq FAT_ARG_R,BASE_CASE_R, base_case #se argumento for igual caso base

	addi, sp,sp,-8 #salvar sp e a3 (argumento da chamada)
	
	sw ra , 0(sp) #salva argumentos na memoria
	sw FAT_ARG_R, 4(sp) 
	
	addi FAT_ARG_R, FAT_ARG_R,-1 #chama a função dnv com n-1
	jal fat_recur #chama função recursiva
	
	lw ra , 0(sp) #retorna argumentos na memoria
	lw FAT_ARG_R, 4(sp)
	
	addi, sp,sp, 8 #libera o espaço no SP
	
	mul FAT_RETURN_R, FAT_ARG_R ,FAT_RETURN_R #multiplica o argumento N atual x o retorno anterior
	#mv FAT_RETURN_R, TEMP_RESULT_R #move o resultado no registrador de retorno
	
	jr ra
	

base_case:
	li FAT_RETURN_R, 1
	jr ra