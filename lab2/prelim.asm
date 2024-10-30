
.data
	sizePrompt:	.asciiz "Please enter the size of the array:"
	elemPrompt:	.asciiz "Enter element:"
	newLine:	.asciiz "\n"
	printArray:	.asciiz "Array elements: " 
	comma: 		.asciiz ", "
	printFreq:	.asciiz "FreqTable: "
	FreqTable: 	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	
.text
.globl main

main:
	jal CreateArray
	add $t0, $v0, $zero
	add $t1, $v1, $zero
	
	add $a0, $t0, $zero
	add $a1, $t1,$zero
	la $a2, FreqTable
	jal FindFreq
	
	la $a0, FreqTable
	jal print_freq
	
	li $v0, 10
	syscall
	
	
CreateArray:
	li $v0, 4
	la $a0, sizePrompt
	syscall
	
	li $v0, 5
	syscall
	add $s0, $v0, $zero
	
	add $a0, $s0, $zero
	li $v0, 9
	syscall
	add $s1, $v0, $zero
	
	add $s5, $ra, $zero
	add $a0, $s0, $zero
	add $a1, $s1, $zero
	jal InitializeArray
	add $ra, $s5, $zero
	add $v0, $s0, $zero
	add $v1, $s1, $zero
	jr $ra
	
InitializeArray:
	
	add $s2, $a0, $zero
	add $s3, $a1, $zero
	add $s7, $s3, $zero
	li $s4, 0
	
in_loop:
	beq $s4, $s2, in_loop_end
	
	li $v0, 4
	la $a0, elemPrompt
	syscall
	
	li $v0, 5
	syscall
	sw $v0, 0($s3)
	
 	addi $s3, $s3, 4
 	addi $s4, $s4, 1
 	j in_loop
 	
in_loop_end:
	li $v0, 4
	la $a0, printArray
	syscall
	
	li $s4, 1

print_loop:
	beq $s4, $s2, print_end
	
	lw $s3, 0($s7)
	li $v0, 1
	add $a0, $s3, $zero
	syscall
	
	li $v0, 4
	la $a0, comma
	syscall
	
	addi $s4, $s4, 1
	addi $s7, $s7, 4
	j print_loop
	
print_end:
	lw $s3, 0($s7)
	li $v0, 1
	add $a0, $s3, $zero
	syscall
	jr $ra
	
	
FindFreq:
	add $s2, $a0, $zero
	add $s3, $a1, $zero
	add $s4, $a2, $zero
	li $s5, 0
	li $s0, 9
	
freq_loop:
	beq $s5, $s2, freq_loop_end
	
	lw $s6, 0($s3)
	bgt $s6, $s0, not_digit
	ble $s6, $s0, digit
	
	
	
not_digit:
	lw $s1, 40($s4)
	addi $s1, $s1, 1
	sw $s1, 40($s4)
	addi $s5, $s5, 1
	addi $s3, $s3, 4
	j freq_loop	
			
digit:
	lw $s1, 0($s3)
	li $s6, 4
	mult $s6, $s1
	mflo $s6
	add $s1, $s4, $zero
	add $s1, $s1, $s6
	
	lw $s6, 0($s1)
	addi $s6, $s6, 1
	sw $s6, 0($s1)
	
	addi $s5, $s5, 1
	addi $s3, $s3, 4
	j freq_loop
	
freq_loop_end:
	jr $ra
	
print_freq:
	add $s0, $a0, $zero
	add $s3, $s0, $zero
	li $s2, 10
	li $s1, 0
	
	li $v0, 4
	la $a0, newLine
	syscall
	
	li $v0, 4
	la $a0, printFreq
	syscall

print_freq_loop:
	beq $s1, $s2, print_freq_end
	
	lw $s4, 0($s0)
	
	li $v0, 1
	add $a0, $s4, $zero
	syscall
	
	li $v0, 4
	la $a0, comma
	syscall
	
	addi $s1, $s1, 1
	addi $s0, $s0, 4
	j print_freq_loop
	
print_freq_end:	
	lw $s4, 0($s0)
	
	li $v0, 1
	add $a0, $s4, $zero
	syscall
	
	jr $ra
	
	