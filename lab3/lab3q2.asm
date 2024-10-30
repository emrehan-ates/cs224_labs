.data
    prompt1:  .asciiz "Enter number of nodes: "
    prompt2:  .asciiz "Enter key: "
    prompt3:  .asciiz "Enter data: "
    newLine:  .asciiz "\n"
    reversePrompt:    .asciiz "Reverse List: \n"
    comma:	       .asciiz ", " 		
    


.text
.globl main

main:
	jal input_list
	
	add $t0, $zero, $v0
	
	la $a0, reversePrompt
	li $v0, 4
	syscall
	
	add $a0, $zero, $t0
	jal reverse_print
	
	li $v0, 10
	syscall
	
input_list:
	la $a0, prompt1
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	add $s0, $zero, $v0   #number of nodes
	
	li $s1, 0
	li $s2, 0
	li $s3, 0
	
input_loop:
	
	beq $s1, $s0, input_end
	
	li $a0, 12
	li $v0, 9
	syscall
	add $s4, $zero, $v0
	
	beqz $s1, set_head
	sw $s4, 8($s3)
	
set_head:
	beqz $s1, store_head
	j skip_store_head

store_head:
	add $s2, $zero, $s4
	
skip_store_head:
	la $a0, prompt2
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	sw $v0, 0($s4)
	
	la $a0, prompt3
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	sw $v0, 4($s4)
	
	sw $zero, 8($s4)
	
	add $s3, $zero, $s4
	addi $s1, $s1, 1
	j input_loop																																							
																																								
	
input_end:
	add $v0, $zero, $s2
	jr $ra
	
reverse_print:
	add $s0, $a0, $zero
	
	
printer:
	beqz $s0, finish
	lw $s1, 0($s0)
	lw $s2, 4($s0)
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	
	lw $s0, 8($s0)
	jal printer
	
finish:
	lw $ra, 0($sp)
	lw $s3, 4($sp)
	lw $s4, 8($sp)
	addi $sp, $sp, 12
	
	li $v0, 1
	add $a0, $s3, $zero
	syscall
	
	la $a0, comma
	li $v0, 4
	syscall
	
	li $v0, 1
	add $a0, $s4, $zero
	syscall
	
	la $a0, newLine
	li $v0, 4
	syscall	
	
	jr $ra		