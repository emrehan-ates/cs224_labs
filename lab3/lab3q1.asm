.data
prompt1:	.asciiz "Enter dividend: "
prompt2:	.asciiz "Enter divisor: "
result:		.asciiz "Quotient: "
newLine: 	.asciiz "\n"
quit:		.asciiz "Quitting... \n"

.text
.globl main

main:
	li $v0, 4
	la $a0, prompt1
	syscall
	
	li $v0, 5
	syscall
	add $t0, $v0, $zero
	
	beqz $t0, end
	
	li $v0, 4
	la $a0, prompt2
	syscall
	
	li $v0, 5
	syscall
	add $t1, $v0, $zero
	
	
	beqz $t1, end
	
	add $a0, $zero, $t0
	add $a1, $zero, $t1
	jal pre_divide
	
	add $t2, $zero, $v0
	
	li $v0, 4
	la $a0, result
	syscall
	
	li $v0, 1
	add $a0, $zero, $t2
	syscall
	
	li $v0, 4
	la $a0, newLine
	syscall
	
	j main
	
end:
	li $v0, 4
	la $a0, quit
	syscall
	li $v0, 10
	syscall
	
pre_divide:
	add $s0, $a0, $zero
	add $s1, $a1, $zero	
	li $s3, 0
	
divide:

	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	
	blt $s0, $s1, done
	
	sub $s0, $s0, $s1
	addi $s3, $s3, 1
	jal divide
	
done:
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	addi $sp, $sp, 12
	add $v0, $s3, $zero
	jr $ra	
	
		