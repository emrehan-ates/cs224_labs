.data
prompt1: .asciiz "Enter B:"
prompt2: .asciiz "Enter C:"
result: .asciiz "A="
newline: .asciiz "\n"


.text
.globl main

main:

	li $v0, 4
	la $a0, prompt1
	syscall
	li $v0, 5 
	syscall
	move $s0, $v0
	
	li $v0, 4
	la $a0, prompt2
	syscall
	li $v0, 5 
	syscall
	move $s1, $v0
	
	div $s1, $s0
	mfhi $t0
	
	div $s0, $t0
	mflo $t1
	
	mult $t1, $s1
	mflo $t2
	
	li $v0, 4
	la $a0, result
	syscall
	
	li $v0, 1
	move $a0, $t2
	syscall
	
	li $v0, 10
	syscall
	