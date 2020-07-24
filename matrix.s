#############################################################################
#############################################################################
## Assignment 3: Madison Lawrence
#############################################################################
#############################################################################

#############################################################################
#############################################################################
## Data segment
#############################################################################
#############################################################################

.data

matrix_a:    .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
matrix_b:    .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
result:      .word 0, 0, 0, 0, 0, 0, 0, 0, 0,  0,  0,  0,  0,  0,  0,  0

newline:     .asciiz "\n"
tab:         .asciiz "\t"
text1:		 .asciiz "Enter the values for matrix A:\n"
text2:		 .asciiz "Enter the values for matrix B:\n"
text3:		 .asciiz "Product A x B matrices:\n"

#############################################################################
#############################################################################
## Text segment
#############################################################################
#############################################################################

.text                  # this is program code
.align 2               # instructions must be on word boundaries
.globl main            # main is a global label
.globl multiply
.globl matrix_multiply
.globl matrix_print
.globl matrix_ask

#############################################################################
matrix_ask:
#############################################################################
# Ask the user for the current matrix residing in the $a0 register
    sub $sp, $sp, 4
    sw $ra, 0($sp)

    # init our counter
    li $t0, 0
    # t1 holds our the address of our matrix
    move $t1, $a0

ma_head:
# if counter less than 16, go to ma_body
# else go to exit
    li $t2, 16
    blt $t0, $t2, ma_body
    j ma_exit

ma_body:
    # read int
    li $v0, 5
    syscall
    li $t2, 4
    # ints are 4 bytes
    multu $t0, $t2
    mflo $t2
    add $t2, $t2, $t1
    sw $v0, 0($t2)
    j ma_latch

ma_latch:
    addi $t0, $t0, 1
    j ma_head

ma_exit:
    lw $ra, 0($sp)
    add $sp, $sp, 4
    jr $ra

#############################################################################
main:
#############################################################################
    # alloc stack and store $ra
    sub $sp, $sp, 4
    sw $ra, 0($sp)

    # load A, B, and result into arg regs
	li $v0, 4
    la $a0, text1
    syscall
	
    la $a0, matrix_a
    jal matrix_ask
	
	li $v0, 4
    la $a0, text2
    syscall
	
    la $a0, matrix_b
    jal matrix_ask

    la $a0, matrix_a
    la $a1, matrix_b
    la $a2, result
	jal matrix_multiply

    la $a0, result
    jal matrix_print

    # restore $ra, free stack and return
    lw $ra, 0($sp)
    add $sp, $sp, 4
    jr $ra

##############################################################################
multiply:
##############################################################################  
# mult subroutine $a0 times $a1 and returns in $v0

    # start with $t0 = 0
    add $t0,$zero,$zero
mult_loop:
    # loop on a1
    beq $a1,$zero,mult_eol

    add $t0,$t0,$a0
    sub $a1,$a1,1
    j mult_loop

mult_eol:
    # put the result in $v0
    add $v0,$t0,$zero

    jr $ra

##############################################################################
matrix_multiply: 
##############################################################################
# mult matrices A and B together of square size N and store in result.

    # alloc stack and store regs
    sub $sp, $sp, 24
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $a1, 8($sp)
    sw $s0, 12($sp)
    sw $s1, 16($sp)
    sw $s2, 20($sp)
	
    add $t7, $zero, $zero   #Set i counter to zero.
    add $t1, $zero, $zero   #Set j counter to zero.
    add $t2, $zero, $zero   #Set k counter to zero.
	li $t3, 4 #value of row/cols for all matrices

	
	i_start: 
		slti $s4, $t7, 4
		beq $s4,$zero, exit_loop
		j j_start
	j_start:
		slti $s4, $t1, 4
		beq $s4,$zero,i_end
		li $t4,0
		j k_start
	k_start:
		slti $s4, $t2, 4
		beq $s4,$zero,j_end
	#loop body
		#get A[i][k]
		
		la $s1, matrix_a
		
		move $a0,$t7
		move $a1,$t3
		jal multiply
		move $t5,$v0
		add $t5,$t5,$t2 #4i+k
		
		move $a0,$t5
		move $a1,$t3
		jal multiply #offset by 4
		add $t5,$v0,$s1
		lw $t5,($t5)
		
		
		#get B[k][j]
		la $s2, matrix_b
		move $a0,$t2
		move $a1,$t3
		jal multiply
		move $t6,$v0
		add $t6,$t6,$t1 #4k+j
		
		move $a0,$t6
		move $a1,$t3
		jal multiply #offset by 4
		add $t6,$v0,$s2
		lw $t6,($t6)
		
		#do math
		move $a0,$t5
		move $a1,$t6
		jal multiply 
		add $t4,$t4,$v0
		
		addi $t2,$t2,1
		j k_start # increment k and jump back or exit
    
	j_end: 
		#save to result
		la $s2,result
		move $a0,$t7
		move $a1,$t3
		jal multiply
		add $v0,$v0,$t1 #4i+j
		
		move $a0,$v0
		move $a1,$t3
		jal multiply #offset by 4
		add $t9,$v0,$s2
		sw $t4,($t9)
		
		
		#increment j and jump back or exit
		addi $t1,$t1,1
		li $t2,0
		j j_start
		
	i_end: #increment i and jump back or exit
		addi $t7,$t7,1
		li $t1,0
		li $t2,0
		j i_start
    
	exit_loop:
    # retore saved regs from stack
    lw $s2, 20($sp)
    lw $s1, 16($sp)
    lw $s0, 12($sp)
    lw $a1, 8($sp)
    lw $a0, 4($sp)
    lw $ra, 0($sp)

    # free stack and return
    add $sp, $sp, 24
    jr $ra

##############################################################################
matrix_print:
##############################################################################

    # alloc stack and store regs.
    sub $sp, $sp, 16
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $a0, 12($sp)

    li $t0, 4 # size of one dimension of matrix
	li $t1, 0 # counter for whole matrix
	li $t2, 0 # counter for one row
	move $s1, $a0
	
	li $v0, 4
    la $a0, text3
    syscall
	
	
    # do your two loops here
    loop1:
		beq $t2,$t0,print_newline
		
	loop2:
		lw $a0,($s1)
		addi $v0,$0,1
		syscall
		li $v0, 4
		la $a0,tab
		syscall
		addi $s1,$s1,4
		add $t2,$t2,1
		j loop1
		
	print_newline:
		li $v0, 4
		la $a0, newline
		syscall
		li $t2, 0
		add $t1,$t1,1
		beq $t1,$t0,exit
		j loop2
		
	exit:

    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $a0, 12($sp)
    add $sp, $sp, 16
    jr $ra
