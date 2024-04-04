
	 .macro print_int_reg (%reg)
             li a7 ,1
             add a0,zero ,%reg
             ecall
        .end_macro

	.data 
	.align 2

num1:    .word 20
num2:    .word -20


         .text
         .align 2
         .globl main
         
main:
	lw s0,num1
	
	blt s0,zero,negative #pula para negativo caso so seja menor que zero
	#codigo executa se s0 >= 0
        j end
negative:
        li s2,-1
        mul s0,s0,s2
        
        print_int_reg s0

end: