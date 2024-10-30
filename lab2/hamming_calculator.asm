.data
    prompt: .asciiz "Enter the register value: "
    hamming_res: .asciiz "Hamming distance between the registers is: "
    continue_prompt: .asciiz "Do you want to continue? (1 for yes, 0 for no): "
    first: .asciiz "First register value (hex): 0x"
    second:.asciiz "Second register value (hex): 0x"
    newLine: .asciiz "\n"
    hex_buffer: .space 9
    
.text
	.globl main

main:
	jal get_value
	add $t0, $v0, $zero
	
	jal get_value
	add $t1, $v0, $zero
	
	li $v0, 4
	la $a0, first
	syscall
	add $a0, $t0, $zero
	jal store_hex
	jal reverse_print
	
	li $v0, 4
	la $a0, newLine
	syscall
	
	li $v0, 4
	la $a0, second
	syscall
	add $a0, $t1, $zero
	jal store_hex
	jal reverse_print
	
	li $v0, 4
	la $a0, newLine
	syscall
	
	add $a0, $t0, $zero
	add $a1, $t1, $zero
	jal hamming_distance
	add $t2, $v0, $zero
	li $v0, 4
	la $a0, hamming_res
	syscall
	
	add $a0, $t2, $zero
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, newLine
	syscall
	
	li $v0, 4
	la $a0, continue_prompt
	syscall
	
	li $v0, 5
	syscall
	beq $v0, $zero, exit
	
	j main
	
exit:
	li $v0, 10
	syscall	

get_value:
	li $v0, 4
	la $a0, prompt
	syscall
	
	li $v0, 5
	syscall
	add $v0, $v0, $zero
	jr $ra	
	
store_hex:
	li $s0, 8
	add $s1, $a0, $zero
	la $s7, hex_buffer 
store_loop:
	li $s2, 15
	and $s3, $s1, $s2
	
	li $s4, 10
	blt $s3, $s4, num_to_ascii
	addi $s3, $s3, 55
	j store_char

num_to_ascii:
	addi $s3, $s3, 48
	
store_char:
	sb $s3, 0($s7)
	addi $s7, $s7, 1
	

	srl $s1, $s1, 4
	li $s6, -1
	add $s0, $s0, $s6
	bgtz $s0, store_loop
	
	jr $ra
		 
		 								 				
reverse_print:
	la $s0, hex_buffer
	addi $s1, $s0, 7
	
reverse_loop:
	lb $a0, 0($s1)
	li $v0, 11
	syscall
	
	li $s5, -1
	add $s1, $s1, $s5
	bge $s1, $s0, reverse_loop
	jr $ra	
	
hamming_distance:
	add $s7, $a0, $zero
	add $s6, $a1, $zero
	li $s0, 0
	li $s1, 32
	
compare_nibbles:
	andi $s2, $s7, 1
	andi $s3, $s6, 1
	
	bne $s2, $s3, increment
	
next_nibble:
	srl $s7, $s7, 1
	srl $s6, $s6, 1
	li $s4, -1
	add $s1, $s1, $s4
	bgtz $s1, compare_nibbles
	
	add $v0, $s0, $zero
	jr $ra	
increment:
	addi $s0, $s0, 1
	j next_nibble						 								 						 								 								 						 								 								 									 								 								 						 								 								 						 								 								 						 								 								 							 								 								 						 								 								 						 								 								 						 								 								 								 								 								 						 								 								 						 								 								 						 								 								 							 								 								 						 								 								 						 								 								 						 								 								 				

			 								 										 								 														 								 								
