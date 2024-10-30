.data
    prompt_msg:  .asciiz "\n\nEnter number of a register (0-31): "
    result_msg:  .asciiz "Number of times this register is used: "
    newline:     .asciiz "\n"
    invalid_msg: .asciiz "Invalid input. Exiting...\n"

.text
main:
    
    jal get_register
    add $a0, $zero, $v0
    jal register_counter
    j main
    
get_register:
	la $a0, prompt_msg
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	add $s0, $zero, $v0
	bgt $s0, 31, exit_program
	blt $s0, 0, exit_program
	
	li $v0, 4
	la $a0, result_msg
	syscall
	add $v0, $zero, $s0
	jr $ra

exit_program:
	la $a0, invalid_msg
	li $v0, 4
	syscall
	li $v0, 10
	syscall
	
register_counter:

 	la $s0, register_counter     
 	la $s1, count_done
 	add $s2, $zero, $a0
 	add $s3, $zero, $zero
 	li $s5, 1	#just to show it counts $s5 as 1
 	
loop:
	beq $s1, $s0, print
	lw $s4, 0($s0)
	
compare_rt:
	andi $s7, $s4, 0x001f0000
	srl $s7, $s7, 16
	bne $s7, $s2, compare_rs
	addi $s3, $s3, 1
	
compare_rs:
	andi $s7, $s4, 0x03e00000
	srl $s7, $s7, 21
	bne $s7, $s2, compare_rd
	addi $s3, $s3, 1

compare_rd:
	andi $s7, $s4, 0x0000F800 
	srl $s7, $s7, 11
	bne $s7, $s2, next_instruction
	addi $s3, $s3, 1
	
next_instruction:
	addi $s0, $s0, 4
	b loop    #ask ta this
	
print:
	la $a0, ($s3)
	li $v0, 1
	syscall

count_done:
	jr $ra		 