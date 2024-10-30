.data
    prompt: .asciiz "Enter the register value: "
    hex_res: .asciiz "Hex of the number you entered: 0x"
    continue_prompt: .asciiz "Do you want to continue? (1 for yes, 0 for no): "
    hex_rev: .asciiz "Hex of the reversed version: 0x"
    newLine: .asciiz "\n"
    hex_buffer: .space 9
    
.text
	.globl main

main:		
	jal get_value
	add $t0, $v0, $zero
	
	li $v0, 4
	la $a0, hex_res
	syscall
	add $a0, $t0, $zero
	jal store_hex
	jal reverse_print
	
	li $v0, 4
	la $a0, newLine
	syscall
	
	add $a0, $t0, $zero
	jal reverser
	add $t2, $v0, $zero
	
	li $v0, 4
	la $a0, hex_rev
	syscall
	add $a0, $t2, $zero
	jal store_hex
	jal reverse_print
	
	li $v0, 4
	la $a0, newLine
	syscall
	
	li $v0, 4
	la $a0, continue_prompt
	syscall
	
	li $v0, 5
	syscall
	
	beqz $v0, quit
	j main
	

quit: 
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
	
reverser:
	
	add $s0, $zero, $a0
	li $s1, 31
	li $s3, 0
	li $s4, -1
	
reverser_loop:
	
	beqz $s1, reverser_exit
	andi $s2, $s0, 1
	or $s3, $s3, $s2
	sll $s3, $s3, 1
	srl $s0, $s0, 1
	add $s1, $s4, $s1
	j reverser_loop  		

reverser_exit:
	andi $s2, $s0, 1
	or $s3, $s3, $s2
	add $v0, $zero, $s3
	jr $ra				