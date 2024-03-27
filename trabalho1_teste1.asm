	.macro print_int_reg (%reg)
            		li a7 ,1
             		add a0,zero ,%reg
            		ecall
      	.end_macro


    	.data
    	.align 2
seed:   .word 0x1                # Initial seed

    .text
    .align 2
    .globl random
    .globl _start

# Random number generator function
# Returns a pseudo-random number in a0
random:
    li a0, 0x41c64e6d                # Load A (Multiplier) into a0
    li a1, 0x6073                    # Load C (Increment) into a1
    li a2, 0x10000                   # Load M (Modulus), using 2^16 as an example
    la a4, seed
    
    lw a3, 0(a4)                  # Load current seed value into a3
    mul a3, a3, a0                   # Multiply seed by A: seed * A
    add a3, a3, a1                   # Add C to the result: seed * A + C
    rem a3, a3, a2                   # Modulo M: (seed * A + C) % M
    sw a3, 0(a4)                  # Store new seed value
    mv a0, a3                        # Move result to a0 for return
    ret                              # Return to caller

_start:
    # Example call to the random function
    call random                      # Call the random function, result in a0

    print_int_reg a0
