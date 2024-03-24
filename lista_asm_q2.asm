	.macro print_int_reg (%reg)
             li a7 ,1
             add a0,zero ,%reg
             ecall
        .end_macro
	
	.eqv ARR_SIZE 7
	
	.eqv ARR_ADDR_R s0
	
	.eqv LOOP_INDEX_R t0
	.eqv LOOP_MAX_R t1
	
	.eqv CUR_ADDR_R t2
	.eqv CUR_VAL_R t3
	
	.eqv SUM_R t4

	.data
	.align 2
arr:    .word 2,3,4,5,6,7,10


	.text
	.align 2
	.globl main
	
main:
	li LOOP_INDEX_R,0
	li LOOP_MAX_R,ARR_SIZE #se o index do loop chegar ao numero de items do array vamos parar
	li SUM_R, 0
	la ARR_ADDR_R, arr

lp_start:

       addi CUR_ADDR_R,LOOP_INDEX_R, 0 #carrega o index no registrador de addres
       slli CUR_ADDR_R, CUR_ADDR_R, 2 #shifta o valor no reg de endereço para multiplicar por 4, ja que cada inteiro do array tem 4 bytes
       add  CUR_ADDR_R, CUR_ADDR_R, ARR_ADDR_R #soma o endereço base do array com o offset de byte

       lw CUR_VAL_R , 0(CUR_ADDR_R) #carrega o valor do vetor no indice atual no registrador de valor
       
       add SUM_R, SUM_R, CUR_VAL_R #soma o valor atual com o valor da soma

       addi LOOP_INDEX_R,LOOP_INDEX_R,1
       beq LOOP_INDEX_R, LOOP_MAX_R , lp_end
       j lp_start
lp_end:

       print_int_reg SUM_R



