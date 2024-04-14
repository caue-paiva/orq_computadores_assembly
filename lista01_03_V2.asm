          .eqv BUFFER_SIZE 32
	
	  .eqv str_input s0
	  .eqv str_inver s1
	
	  .eqv str_size_r t0
	
	  .eqv i_loop_var t1
	  .eqv i_loop_condi t2
	
	  .eqv char1_addr t3
	  .eqv char1_val t4
	
	  .eqv char2_addr t5
	  .eqv char2_val t6
	
	
	  .data
str_in:   .space BUFFER_SIZE
str_out:  .space BUFFER_SIZE


	  .text
	  .align 2
	  .globl main

main:

	li str_size_r, BUFFER_SIZE #tamanho da str original é o do buffer
	la str_input, str_in
	la str_inver, str_out #guarda endereço da string que vai ser invertida

	li a7, 8
        mv a0, str_input
	mv a1, str_size_r
	ecall # le uma string do usuario
	
	
	##chama strlen
	mv a1, str_input #move str lida para o argumento da strlen
	jal str_len #chama strlen
	mv str_size_r , a0 #guarda valor de retorno do strlen
	addi str_size_r, str_size_r , -1 #não vamos considerar o \0 por enquanto
	

	##loop de inverter
	li i_loop_var, 0
	mv i_loop_condi, str_size_r
	
loop2:
	li char2_addr, 0 #zera o endereço  da str2
	
	add char1_addr, str_input, i_loop_var #endereço da str 1 é o endereço base + o index do loop
	
	sub char2_addr, str_size_r, i_loop_var # na inversão o index da str invertida será TAM - I -1
	addi char2_addr,char2_addr, -1  
	
	add char2_addr, char2_addr, str_inver #soma o offset mais o endereço base
	
	lb char1_val, 0(char1_addr) #carrega char da string original
	sb char1_val,  0(char2_addr) #guarda byte no endereço da string copiada
	
	addi i_loop_var, i_loop_var, 1
	bge i_loop_var,i_loop_condi, end_loop2
	j loop2
end_loop2:
	
	add char2_addr, str_inver, str_size_r #carrega o ultimo endereço da string (onde seria o \0)
	
	li char2_val, 0 
	sb char2_val, 0(char2_addr) #coloca o \0 no final
	
	
	li a7,4 #print string
	mv a0, str_inver
	ecall
	
	li a7,10 #exit
	ecall 


str_len:
	# Args:
	# a1 endereço da string
	# a0 retorno do tamanho
	
	li i_loop_var, 0
	mv char1_addr, a1 #carrega endereço da string
loop:

	lb char1_val, 0(char1_addr)
	
	addi char1_addr, char1_addr, 1
	addi i_loop_var, i_loop_var, 1 
	
	beq char1_val, zero, end_loop
	j loop
end_loop:

	mv a0, i_loop_var
	jr ra
