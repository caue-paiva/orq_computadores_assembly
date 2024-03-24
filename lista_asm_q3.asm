	.macro print_str (%addr)
             li a7,4
             la a0, %addr
             ecall
        .end_macro
	
	.eqv STR_SIZE 9
	
	.eqv STR1_ADDR_R s0 #reg para endereço da str 1 e 2
	.eqv STR2_ADDR_R s1
	.eqv STR_SIZE_REG s2
	
	.eqv LOOP_INDEX_R t0
	.eqv LOOP_MAX_R t1
	
	
	
	.eqv INDEX1_OFFSET_R t2 #offset para str1
	.eqv INDEX2_OFFSET_R t3 #offset para str2
	.eqv STR2_INDEX_R t4
	.eqv CUR_CHAR_R t5 



	.data
	.align 0

str1:	.asciz "ola mundo"
str2: 	.asciz "aaaaaaaaa"



	.text
	.align 2
	.globl main
	
main:

	li LOOP_INDEX_R, 0
	li LOOP_MAX_R, STR_SIZE
	
	li STR_SIZE_REG, STR_SIZE #guarda o tamanho da str nesse registrador
	addi STR_SIZE_REG, STR_SIZE_REG, -1 #subtrai -1 pq o ultimo index da string é n-1
	

	
	la STR1_ADDR_R, str1
	la STR2_ADDR_R, str2
	


lp_start:

        sub STR2_INDEX_R, STR_SIZE_REG, LOOP_INDEX_R #o indice da str2 que vamos mudar será: (N-1-i), onde N é o tamanho das strs
        
        #pegar char da str1
        addi INDEX1_OFFSET_R, LOOP_INDEX_R, 0 #n precisa shiftar pq cada char tem 1 byte
        add INDEX1_OFFSET_R, INDEX1_OFFSET_R, STR1_ADDR_R #carrega o endereço base + offset
        
        lb CUR_CHAR_R, 0(INDEX1_OFFSET_R) #carrega o char da str1
        
        
        addi INDEX2_OFFSET_R, STR2_INDEX_R, 0
        add INDEX2_OFFSET_R, INDEX2_OFFSET_R, STR2_ADDR_R #carrega o endereço do char da str2
        
        sb CUR_CHAR_R, 0(INDEX2_OFFSET_R)
     
        addi LOOP_INDEX_R, LOOP_INDEX_R,1
        beq LOOP_INDEX_R, LOOP_MAX_R, lp_end
        j lp_start
lp_end:

        print_str str2
