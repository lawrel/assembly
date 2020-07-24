.data
	text: .asciiz "What is n? "
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
	li $t2, 0

head:
	beq $t1, $t0, exit
	#body
	add $t2, $t2, $t1
	#latch
	add $t1,$t1,1
	j head

exit:
    li $v0, 1
    move $a0, $t2
    syscall

	jr $ra