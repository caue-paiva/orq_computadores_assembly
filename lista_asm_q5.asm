	.macro print_str (%addr)
             li a7,4
             la a0, %addr
             ecall
        .end_macro
	
	.eqv BUF_SIZE 9
	.eqv STR1_SIZE 4
	.eqv STR2_SIZE 5
	
	.eqv LOOP_INDEX_R t0 #variaveis do loop
	.eqv LOOP_MAX_R s0
	
	.eqv STR_ADDR_R s1 #guarda o endereço da string a ser acessada em cada loop
	
	.eqv BUF_ADDR_R s3 #guarda o endereço do buffer
	.eqv BUF_INDEX_R s4 #vai guardar o indice que vamos buscar no buffer
	
	.eqv STR_OFFSET_R t1 #offset da string que representa o char que estamos buscando
	.eqv BUF_OFFSET_R t2 #vai guardar o endereço de memoria com offset do buffer
	
	.eqv CHAR_R t3 #registrador para guardar o char lido em cada iteração do loop


	.data 
	.align 0
	
str1:	.asciz "hla "
str2:	.asciz "mundo"

str_buf:.space BUF_SIZE


	.text
	.align 2
	.globl main
	
main:
	li LOOP_INDEX_R, 0
	li BUF_INDEX_R, 0 #essa variavel vai guardar o index do buffer a ser acessado em cada momento, não reinicia a cada loop
	li LOOP_MAX_R, STR1_SIZE #loop pela string 1
	la STR_ADDR_R, str1
	la BUF_ADDR_R, str_buf

		
lp1_start:
	
	addi STR_OFFSET_R, LOOP_INDEX_R, 0
	add STR_OFFSET_R, STR_OFFSET_R, STR_ADDR_R #acha o endereço da str principal que vamos buscar
	
	add  BUF_OFFSET_R, BUF_INDEX_R, BUF_ADDR_R #acha o endereço que vamo acessar o buffer
	
	lb CHAR_R, 0(STR_OFFSET_R) #carrega o char da str
	sb CHAR_R, 0(BUF_OFFSET_R) #coloca o char da str no indice do buffer


	addi BUF_INDEX_R, BUF_INDEX_R, 1 #move o indice que vamos acessar o buffer por 1
	addi LOOP_INDEX_R, LOOP_INDEX_R, 1
	beq LOOP_INDEX_R, LOOP_MAX_R , lp1_end
	j lp1_start
lp1_end:

        #reseta index do loop, coloca nova variavel max do loop e carrega novo endereço 
	li LOOP_INDEX_R, 0
	li LOOP_MAX_R, STR2_SIZE #loop pela string2
	la STR_ADDR_R, str2

lp2_start:

	addi STR_OFFSET_R, LOOP_INDEX_R, 0
	add STR_OFFSET_R, STR_OFFSET_R, STR_ADDR_R #acha o endereço da str principal que vamos buscar
	
	add  BUF_OFFSET_R, BUF_INDEX_R, BUF_ADDR_R #acha o endereço que vamo acessar o buffer
	
	lb CHAR_R, 0(STR_OFFSET_R)
	sb CHAR_R, 0(BUF_OFFSET_R)



	addi BUF_INDEX_R, BUF_INDEX_R, 1
	addi LOOP_INDEX_R, LOOP_INDEX_R, 1
	beq LOOP_INDEX_R, LOOP_MAX_R , lp2_end
	j lp2_start
lp2_end:

	print_str str_buf

