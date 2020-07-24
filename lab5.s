.data
	text: .asciiz "What is n? "
	star: .asciiz "*"
	newline: .asciiz "\n"
	
.text
.globl main

main:
	li $v0, 4
    la $a0, text
    syscall
	
	li $v0, 5
    syscall
	move $t0,$v0  
	li $t1, 0
	
start:	beq $t0,$t1,Exit
		li $t2, 0
		
check:	bgt $t2, $t1, Else
		li $v0, 4
		la $a0, star
		syscall
		add $t2, $t2, 1
		j check
		
Else:	li $v0, 4
		la $a0, newline
		syscall

		add $t1, $t1, 1
		j start
		
Exit:
		jr $ra