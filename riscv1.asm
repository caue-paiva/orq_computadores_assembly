        .macro print_str (%addr)
             li a7,4
             la a0, %addr
             ecall
        .end_macro
       
        .macro print_str_reg (%reg)
             li a7, 4
             mv a0, %reg
             ecall
        .end_macro
        
        .macro read_str_reg (%addr_reg, %max_size_reg)
             li a7 ,8
             mv a0 , %addr_reg
             mv a1, %max_size_reg
             ecall 
        .end_macro
              
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
        
        .eqv PRINT_ARG 4
        .eqv BUF_SIZE 64
        .eqv str_size s1
        .eqv str_addr s0


	.data
	.align 0
str1:   .space BUF_SIZE	

	.text
	.align 2
	.globl main
	
	
main:
	li str_size, BUF_SIZE
	la str_addr , str1
	
	read_str_reg str_addr, str_size
	
	print_str_reg str_addr
        
      
	
