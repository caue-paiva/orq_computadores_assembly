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


	.data
	.align 0
str1:   .asciz "hello world"	
str2:   .asciz "goodbye world"
        .align 2
        


prnt_arg:.word 4



	.text
	.align 2
	.globl main
	
	
main:

	read_int_reg s0 #guarda valor lido no s0
        addi s1,zero,1 #variavel da multi do fatorial
        add s2 ,zero,s0 #variavel do loop
        
loop_start:
        mul s1,s1,s2
        addi s2,s2, -1

        beq s2,zero,end_loop
        j loop_start
end_loop:
          print_int_reg s1
        
      
	
