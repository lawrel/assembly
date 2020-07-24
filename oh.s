.data
	text: .asciiz "Enter a number: "
.text
.globl main
main:
	li $v0, 4
    la $a0, text
    syscall
	
	li $v0, 5
    syscall
	move $t0,$v0 
	
	li $v0, 4
    la $a0, text
    syscall
	
	li $v0, 5
    syscall
	move $t1,$v0 
	
start:	beq $t0,$t1,Exit
		blt $t0,$t1, Else
		sub $t0, $t0, $t1
		j start
		
Else:	sub $t1, $t1, $t0
		j start
		
Exit:	li $v0, 1       
		move $a0, $t0  
		syscall 

		jr $ra