	.eqv AUX_REG t0 #reg temp para a troca
	
	.eqv CUR_NUM_ADDR t1 #registradores para guardar os valores do endereço e valor do numero atual
	.eqv CUR_NUM_VAL t2
	
	.eqv PREV_NUM_VAL t3  #registrador par aguardar o valor do numero anterior
	.eqv ADDR_SHIFT_REG t4 #registrador usado para transformar um index em um offset de bytes endereçavel no array
	
	.eqv ARR_REG s0 #reg pra o endereço base do array
	.eqv I_REG s1 #registrador para o valor do i
	.eqv J_REG s2 #registrador para o valor do j
	
	.eqv ARR_SIZE 7 #num de elementos
	.eqv ARR_SIZE_REG s4
	
	.eqv MAX_VAL 6 #ultimo index
	.eqv MAX_REG s3 
	
	 .macro print_int_reg (%reg)
             li a7 ,1
             add a0,zero ,%reg
             ecall
        .end_macro

	.data
	.align 2
arr:    .word  7, 5, 2, 1, 1, 3, 4
	
	
	
	
	
	.text
	.align 2
	.globl main
	
main:
	#la ARR_REG,arr
	#lw s1, 0(ARR_REG)
	#print_int_reg s1
	 
	 li I_REG, 0 #i comeca com 0
	 la ARR_REG, arr  #carrega o endereço do array num registrador
	 li MAX_REG, MAX_VAL
	 li ARR_SIZE_REG, ARR_SIZE
	
outer_loop:

	  li J_REG,MAX_VAL
inner_loop:

          add ADDR_SHIFT_REG , J_REG , zero #guarda o valor do indice no registrador que vai mexer no endereço do array
          slli ADDR_SHIFT_REG , ADDR_SHIFT_REG , 2
          
          add CUR_NUM_ADDR, ARR_REG , ADDR_SHIFT_REG #endereço do numero atual é o endereço base mais o index dado por j
          lw CUR_NUM_VAL , 0(CUR_NUM_ADDR) #carrega o valor do numero atual a partir do endereço de memória calculado
          
          lw PREV_NUM_VAL, -4(CUR_NUM_ADDR) #carrega o valor do array do indice anterior ao atual, -4 pq são 4 bytes por index
          
          bge CUR_NUM_VAL, PREV_NUM_VAL, end_swap #se o valor atual for maior ou igual ao anterior, não precisa fazer o swap
          
          add AUX_REG , CUR_NUM_VAL, zero #guarda o valor do num atual no aux
          sw  PREV_NUM_VAL , 0(CUR_NUM_ADDR) #coloca o valor do anterior no index do atual
          sw AUX_REG , -4(CUR_NUM_ADDR)  #coloca o valor do atual , guardado no aux  no index do anterior
      	 

end_swap:
          addi J_REG,J_REG, -1 #decrementa J com -1
	  beq J_REG, I_REG, end_inner #loop interno roda de MAX até i+1, então se J = I, temos que para o loop interno
          j inner_loop #continua loop iterno
end_inner:

          addi I_REG,I_REG, 1 #incrementa i com i
          beq I_REG, MAX_REG , end_outer #caso I seja igual ao ultimo indice, acaba o loop externo
          j outer_loop #continua loop externo
end_outer:

          li t5,0


print_loop:

          addi ADDR_SHIFT_REG , t5, 0
          slli ADDR_SHIFT_REG,ADDR_SHIFT_REG,2

          add t6, ARR_REG, ADDR_SHIFT_REG #endereço do valor que vamos printar
          lw t4, 0(t6)
          
          print_int_reg t4
          
          
          addi t5,t5,1
          beq t5, ARR_SIZE_REG, end_print
          j print_loop
end_print:




