	.macro print_str (%addr)
             li a7,4
             la a0, %addr
             ecall
        .end_macro
	
	.eqv STR_SIZE 7
	
	.eqv LOOP_INDEX_R t0
	.eqv LOOP_MAX_R t1
	
	.eqv OFFSET1_ADDR_R t2
	.eqv OFFSET2_ADDR_R t3
	.eqv CHAR1_R t4
	.eqv CHAR2_R t5
	
	.eqv STR1_ADDR_R s0
	.eqv STR2_ADDR_R s1
	

	.data
	.align 0

str1:   .asciz "parquet"
str2:   .asciz "parquet"

dif:    .asciz "Diferentes"
igual:	.asciz "iguais"


	.text
	.align 2
	.globl main
	
main:
	li LOOP_INDEX_R, 0
	li LOOP_MAX_R, STR_SIZE
	
	la STR1_ADDR_R, str1
	la STR2_ADDR_R, str2
	
	
lp_start:

	add OFFSET1_ADDR_R, LOOP_INDEX_R, zero #offset base da str 1 e 2
	add OFFSET2_ADDR_R, LOOP_INDEX_R, zero
	
	
	add OFFSET1_ADDR_R, OFFSET1_ADDR_R  ,STR1_ADDR_R #add o offset para os endereços das str1 e str2
	add OFFSET2_ADDR_R, OFFSET2_ADDR_R ,STR2_ADDR_R
	
	lb CHAR1_R, 0(OFFSET1_ADDR_R)
	lb CHAR2_R, 0(OFFSET2_ADDR_R)
	bne CHAR1_R, CHAR2_R, not_equal
	
	
	
	addi LOOP_INDEX_R, LOOP_INDEX_R, 1
        beq LOOP_INDEX_R, LOOP_MAX_R, lp_end
	j lp_start
lp_end:


equal:

print_str igual


j main_end


not_equal:

print_str dif


main_end: