	.macro print_str (%addr)
             li a7,4
             la a0, %addr
             ecall
        .end_macro
	
	
	.eqv STR_SIZE 11
	
	.eqv LOOP_INDEX_R t0
	.eqv LOOP_MAX_R t1
	
	.eqv STR1_ADDR_R s0
	.eqv BUFF_ADDR_R s1
	
	.eqv OFFSET1_ADDR_R t2
	.eqv OFFSET2_ADDR_R t3
	.eqv CHAR_R t4

	.data
	.align 0

str1:	.asciz "strinz aqui"
str_buf:.space STR_SIZE




	.text
	.align 2
	.globl main
	
main:
	li LOOP_INDEX_R, 0
	li LOOP_MAX_R, STR_SIZE
	
	la STR1_ADDR_R, str1
	la BUFF_ADDR_R , str_buf


lp_start:
	
	addi OFFSET1_ADDR_R , LOOP_INDEX_R,0
	addi OFFSET2_ADDR_R , LOOP_INDEX_R,0
	
	add OFFSET1_ADDR_R, OFFSET1_ADDR_R ,  STR1_ADDR_R #acha o endereço certo do char da str1 original e do buffer
	add OFFSET2_ADDR_R, OFFSET2_ADDR_R ,  BUFF_ADDR_R
	
	lb CHAR_R, 0(OFFSET1_ADDR_R)
	sb CHAR_R, 0(OFFSET2_ADDR_R)

	addi LOOP_INDEX_R, LOOP_INDEX_R, 1
	beq LOOP_INDEX_R, LOOP_MAX_R, lp_end
	j lp_start
lp_end:



	print_str str_buf