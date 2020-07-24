.data
	text: .asciiz "Enter a number: "
	x: .word 5
	y: .word 1
.text
.globl main
main:
	li $v0, 4
    la $a0, text
    syscall
	
	li $v0, 5
    syscall
	move $t0,$v0           
	
	lw $t1, x
    lw $t3, y
	
	slt $t2, $t0, $t1
	beq $t2, $t3, Target
	j Else
	
Target: add $t0, $t0, $t1
	
Else:	li $v0, 1       
		move $a0, $t0  
		syscall  
	
		jr $ra