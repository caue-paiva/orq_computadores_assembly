	
	
	.macro print_int_reg (%reg)
             li a7 ,1
             add a0,zero ,%reg
             ecall
        .end_macro
	
	.eqv SIZE 7
	.eqv I_LOOP_VAR t0
	.eqv I_LOOP_CONDI t1
	
	.eqv J_LOOP_VAR t2
	.eqv J_LOOP_CONDI t3
	
	.eqv ARR_ADDR_R s0
	
	.eqv CUR_INDEX_R t4
	.eqv PREV_INDEX_R t5
	
	.eqv CUR_NUM_R s1
	.eqv PREV_NUM_R s2

	.data 
	.align 2
vec:	.word  1,6,7,8,9,10,2

	.text
	.align 2
	.globl main
main:
	li I_LOOP_VAR, 0 #carrega o i como zero
	li I_LOOP_CONDI, SIZE #se i for igual ao tamanho do vetor, da break
	
	la ARR_ADDR_R, vec

loopi:
	li J_LOOP_VAR, SIZE
	addi J_LOOP_VAR,J_LOOP_VAR,-1 #j começa com MAX-1
	
	mv J_LOOP_CONDI, I_LOOP_VAR #loop interno do j vai ate i+1
	addi J_LOOP_CONDI, J_LOOP_CONDI, 1 
loopj:
	mv CUR_INDEX_R, J_LOOP_VAR #j é o index do numero de indice atual
	
	mv PREV_INDEX_R, J_LOOP_VAR
	addi PREV_INDEX_R, PREV_INDEX_R, -1 #index anterior é o atual -1
	
	slli CUR_INDEX_R, CUR_INDEX_R, 2 #multiplica os 2 indices por 4, pq cada int tem 4 bytes
	slli PREV_INDEX_R, PREV_INDEX_R, 2 
	
	add CUR_INDEX_R, CUR_INDEX_R, ARR_ADDR_R
	add PREV_INDEX_R, PREV_INDEX_R, ARR_ADDR_R #somar o offset + o endereço base
	
	lw CUR_NUM_R, 0(CUR_INDEX_R)
	lw PREV_NUM_R, 0(PREV_INDEX_R) #pega os valores do vetor
	
	ble PREV_NUM_R, CUR_NUM_R, end_swap #caso o anterior seja menor ou igual ao atual, não troca
	
	sw PREV_NUM_R, 0(CUR_INDEX_R) #troca numeros em j e j-1
	sw CUR_NUM_R, 0(PREV_INDEX_R)
	
end_swap:
	addi J_LOOP_VAR,J_LOOP_VAR,-1 #subtrai 1 do J
	ble J_LOOP_VAR, J_LOOP_CONDI, end_loopj
	j loopj
end_loopj:
	
	addi I_LOOP_VAR,I_LOOP_VAR, 1 #add 1 ao i
	beq I_LOOP_VAR,I_LOOP_CONDI, end_loopi
	j loopi
end_loopi:
	
	####### loop de printar
	li I_LOOP_VAR, 0
	li I_LOOP_CONDI , SIZE	
print_loop:
	mv CUR_INDEX_R, I_LOOP_VAR #index do vetor é a variavel do loop
	
	slli CUR_INDEX_R, CUR_INDEX_R, 2
	add CUR_INDEX_R, CUR_INDEX_R, ARR_ADDR_R
	
	lw CUR_NUM_R, 0(CUR_INDEX_R)
	
	print_int_reg CUR_NUM_R
	
	addi I_LOOP_VAR,I_LOOP_VAR, 1 
	beq I_LOOP_VAR,I_LOOP_CONDI, end_print
	j print_loop
end_print:
