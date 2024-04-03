	 .macro read_int_reg (%reg)
             li a7, 5
             ecall
             add %reg, zero ,a0
        .end_macro
        
        .macro print_int_reg (%reg)
             li a7 ,1
             add a0,zero ,%reg
             ecall
        .end_macro
	
	
	.eqv LOOP_INDEX_R t0
	.eqv LOOP_CONDI_R t1
	
	
	.eqv FAT_NUM_R s0
	
	.eqv FAT_FUNC_ARG_R a3
	.eqv FAT_FUNC_RETURN_R a0
	.eqv FAT_FUNC_RESULT_R t2

	.data

	.text
	.align 2
	.globl main
	
main:

	read_int_reg FAT_NUM_R #le inteiro e guarda no registrado do num do fatorial
	mv FAT_FUNC_ARG_R, FAT_NUM_R #move num do fatorial para registrador de argumento da func fatorial
	
	jal factorial
	
	print_int_reg FAT_FUNC_RETURN_R
	
	 



factorial:	
	li LOOP_CONDI_R, 1 #vamos parar o loop quando o index for 1
	li FAT_FUNC_RESULT_R , 1 #carrega um no registrador que guarda a multiplicação/resultado
	mv LOOP_INDEX_R, FAT_FUNC_ARG_R #o index vai começar no numero que foi passado como argumento

loop:
	mul FAT_FUNC_RESULT_R, FAT_FUNC_RESULT_R, LOOP_INDEX_R
	addi LOOP_INDEX_R,LOOP_INDEX_R, -1 #subtrai index do loop
	ble LOOP_INDEX_R, LOOP_CONDI_R , loop_end
	j loop
loop_end:

	mv FAT_FUNC_RETURN_R, FAT_FUNC_RESULT_R #carrega o valor multiplicado no registrador de retorno
	jr ra

	

	
