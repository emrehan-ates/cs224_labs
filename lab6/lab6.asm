
		.data 

opt:	.asciiz "Please choose an option:  "
menuHead: .asciiz " \n ___MENU___ \n"

sel1: .asciiz " 1) Create matrix (NxN) initialized with consecutive values \n"
sel2: .asciiz " 2) Display desired element of the matrix by row*column \n"
sel3: .asciiz " 3) Obtain summation of matrix elements row-major (row by row) summationse\n"
sel4: .asciiz " 4) Obtain summation of matrix elements column-major (column by column)summation \n"
sel5: .asciiz " 5) Exit \n"

enterRow: .asciiz "Please enter Row number i: \n " 
enterCol: .asciiz "Please enter Column number j: \n " 
showItem: .asciiz "Item in the given row and column is :  " 
DimCount: .asciiz "Enter the matrix dimension N of (NxN) matrix: " 
displaySum:  .asciiz "\n Sum is : "


line: .asciiz "\n"
space: .asciiz " "


		.text
	.globl _start

_start:
	jal main
	li $v0, 10
	syscall
	
main:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
menu:
	jal displayOpts
	li $v0, 4
	la $a0, opt
	syscall
	
	li $v0, 5
	syscall
	
	beq $v0, 1, opt1
	beq $v0, 2, opt2
	beq $v0, 3, opt3
	beq $v0, 4, opt4
	beq $v0, 5, opt5
	
opt1:
	li $v0, 4
	la $a0, DimCount
	syscall
	
	li $v0, 5
	syscall
	
	add $s0, $0, $v0
	mul $s1, $s0, $s0
	mul $a0, $s1, 4
	li $v0, 9
	syscall
	
	add $a1, $v0, $0
	
	add $a0, $s1, $0
	add $s2, $v0, $0
	jal fillMatrix
	j straightBackToIt
	
opt2:
	li $v0, 4
	la $a0, enterRow
	syscall
	
	li $v0, 5
	syscall
	
	add $t7, $v0, $0
	li $v0, 4
	la $a0, enterCol
	syscall
	li $v0, 5
	syscall
	
	add $t6, $v0, $0 #used t7 and t6 to pass parameters
	jal getIndexed
	j straightBackToIt

opt3:
	add $a0, $s0, $0
	add $a1, $s2, $0
	jal rowsum
	j straightBackToIt
	
opt4:
	add $a0, $s1, $0	
	add $a1, $s2, $0
	jal colsum
	j straightBackToIt
	
straightBackToIt:
	j menu

opt5:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
getIndexed:
	addi $sp, $sp, -28
	sw $ra, 0($sp)
	sw $s0, 4($sp) 
	sw $s1, 8($sp)	
	sw $s2, 12($sp)	
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	
	add $t1, $t7, $0
	add $t0, $t6, $0
	
	addi $t0, $t0, -1
	mul $t0, $t0, $s0
	mul $t0, $t0, 4
	addi $t1, $t1, -1
	mul $t1, $t1, 4
	add $t0, $t0, $t1
	add $t2, $t0, $s2
	
	li $v0, 4
	la $a0, showItem
	syscall
	
	lw $a0, 0($t2)
	addi $v0,$v0, -3
	syscall
	
	lw $s5, 24($sp)
	lw $s4, 20($sp)
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 28
	jr $ra 
	
	
fillMatrix:
	addi $sp, $sp, -28
	sw $ra, 0($sp)
	sw $s0, 4($sp) 
	sw $s1, 8($sp)	
	sw $s2, 12($sp)	
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	
	li $t0, 1
	add $t1, $a1, $0
	add $t2, $a0, $0
	filler:
		sw $t0, 0($t1)
		addi $t0, $t0, 1
		addi $t2, $t2, -1
		addi $t1, $t1, 4
		bne $t2, 0, filler

	lw $s5, 24($sp)
	lw $s4, 20($sp)
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 28
	jr $ra
	
rowsum:
	addi $sp, $sp, -32
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)	
	sw $s2, 12($sp)	
	sw $s3, 16($sp) 
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	sw $s7, 32($sp)
	
	add $s0, $a0, $0
	add $s3, $a1, $0
	
	li $s1, 0
	mul $s2, $s0, 4
	add $s6, $0, $0
	
	rowOut:
		bge $s6, $s0, rowOutEnd
		add $s7, $0, $0
		add $s5, $s3, $0
		
	rowIn:
		bge $s7, $s0, rowInEnd
		lw $t1, 0($s3)
		add $s1, $s1, $t1
		add $s3, $s3, $s2
		addi $s7, $s7, 1
		b rowIn
	
	rowInEnd:
		add $s3, $s5, $0
		addi $s3, $s3, 4
		addi $s6, $s6, 1
		b rowOut
		
	rowOutEnd:
		li $v0, 4
		la $a0, displaySum
		syscall
		add $a0, $s1, $0
		li $v0, 1
		syscall
		add $v0, $s1, $0
		
	lw $s7, 32($sp)
	lw $s6, 28($sp)
	lw $s5, 24($sp)
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 32
	jr $ra 
	
colsum:
	
	addi $sp, $sp, -32
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)	
	sw $s2, 12($sp)	
	sw $s3, 16($sp) 
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	sw $s7, 32($sp)
	
	add $s0, $a1, $0
	add $s1, $a0, $0
	add $s2, $0,$0
	
	summation:
		lw $s3, 0($s0)
		add $s2, $s2, $s3
		addi $s0, $s0, 4
		subi $s1, $s1, 1
		bne $s1, $zero, summation
		
	li $v0, 4
	la $a0, displaySum
	syscall
	
	add $a0, $s2, $0
	li $v0, 1
	syscall
	add $v0, $s2, $0

	lw $s7, 32($sp)
	lw $s6, 28($sp)
	lw $s5, 24($sp)
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 32
	jr $ra 
	
displayOpts:
	addi $sp, $sp, -4 
	sw $ra, 0($sp)
	li $v0, 4 
	
	la $a0, menuHead
	syscall	
	
	la $a0, sel1
	syscall
	la $a0, sel2
	syscall
	la $a0, sel3
	syscall
	la $a0, sel4
	syscall
	la $a0, sel5
	syscall 
	lw $ra, 0($sp) 
	addi $sp, $sp, 4
	jr $ra 